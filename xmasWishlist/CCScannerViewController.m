//
//  CCScannerViewController.m
//  xmasWishlist
//
//  Created by Csaba Csordas on 19/11/2012.
//  Copyright (c) 2012 Csaba Csordas. All rights reserved.
//

#import "CCScannerViewController.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "ListItem.h"

#define gBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kSampleAppKey @"fa74efe2241e44a3ad3c9c8bfce1dcc4"

@interface CCScannerViewController ()

@end

@implementation CCScannerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    
    NetworkStatus internetStatus = [self.internetReacheble currentReachabilityStatus];
    switch (internetStatus)
    
    {
        case NotReachable:
        {
            //NSLog(@"The internet is down.");
            self.internetActive = NO;
            
            break;
            
        }
        case ReachableViaWiFi:
        {
            //NSLog(@"The internet is working via WIFI.");
            self.internetActive = YES;
            
            break;
            
        }
        case ReachableViaWWAN:
        {
            //NSLog(@"The internet is working via WWAN.");
            self.internetActive = YES;
            
            break;
            
        }
    }
    
    NetworkStatus hostStatus = [self.hostReacheble currentReachabilityStatus];
    switch (hostStatus)
    
    {
        case NotReachable:
        {
            //NSLog(@"A gateway to the host server is down.");
            self.hostActive = NO;
            
            break;
            
        }
        case ReachableViaWiFi:
        {
            //NSLog(@"A gateway to the host server is working via WIFI.");
            self.hostActive = YES;
            
            break;
            
        }
        case ReachableViaWWAN:
        {
            //NSLog(@"A gateway to the host server is working via WWAN.");
            self.hostActive = YES;
            
            break;
            
        }
    }
}

- (IBAction)scanPressed:(UIButton *)sender {
    
    if(self.internetActive && self.hostActive){
        
        ZBarReaderViewController *reader = [ZBarReaderViewController new];
        reader.readerDelegate = self;
        reader.supportedOrientationsMask = ZBarOrientationMaskAll;
        
        ZBarImageScanner *scanner = reader.scanner;
        
        [scanner setSymbology:ZBAR_I25
                       config:ZBAR_CFG_ENABLE
                           to:0];
        //present and release the controller
        [self presentModalViewController: reader
                                animated: YES];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"No Internet Connection" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    NSLog(@"%@", symbol.data);

    
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
    
    
    NSString *url = [[NSString alloc] initWithFormat:@"https://www.googleapis.com/shopping/search/v1/public/products?key=AIzaSyAvnnpLAbf8YQlb8ShjsqYHNMXH5GNIxqM&country=%@&q=%@&alt=json", countryCode,symbol.data];
    NSURL *reqUrl = [NSURL URLWithString:url];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        dispatch_async(gBgQueue, ^{
            NSData* data = [NSData dataWithContentsOfURL:reqUrl];
            if(data){
                [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Search Result" message:@"Sorry but no product found" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        });
    });
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissModalViewControllerAnimated: YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    self.internetReacheble = [Reachability reachabilityForInternetConnection];
    [self.internetReacheble startNotifier];
    
    // check if a pathway to a random host exists
    self.hostReacheble = [Reachability reachabilityWithHostName: @"www.google.com"];
    [self.hostReacheble startNotifier];
    
    [super viewWillAppear:animated];
}

-(void) fetchedData:(NSData *)responseData{
    //parse the json data
    self.resultList = [NSMutableArray arrayWithCapacity:1];
    
    
    NSError* error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    
    NSArray *items = [json objectForKey:@"items"];
    NSLog(@"Items: %@", items);
    //self.resultList = [json objectForKey:@"items"];
    if([items count]>0){
        for(NSDictionary* pItem in items){
            ListItem *lItem = [[ListItem alloc] init];
            NSDictionary *product = [pItem objectForKey:@"product"];
            NSDictionary *author = [product objectForKey:@"author"];
            NSArray *inventories = [product objectForKey:@"inventories"];
            NSDictionary *price = [inventories objectAtIndex:0];
            lItem.name = [product objectForKey:@"title"];
            lItem.brand = [product objectForKey:@"brand"];
            lItem.type = [product objectForKey:@"title"];
            lItem.price = [NSString stringWithFormat:@"%@ %@",[price objectForKey:@"price"], [price objectForKey:@"currency"]];
            lItem.placeToBuy = [author objectForKey:@"name"];
            lItem.info = [product objectForKey:@"link"];
            [self.resultList addObject:lItem];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
        //[self performSegueWithIdentifier: @"openTableView" sender:self.resultList];
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Search Result" message:@"Sorry but no product found" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
}


@end
