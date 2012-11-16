//
//  CCCountdownViewController.m
//  xmasWishlist
//
//  Created by Csaba Csordas on 05/11/2012.
//  Copyright (c) 2012 Csaba Csordas. All rights reserved.
//

#import "CCCountdownViewController.h"

@interface CCCountdownViewController ()

@end

@implementation CCCountdownViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSDate *) getChristmasDate:(NSString *)christmasDateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* christmasDate = [dateFormatter dateFromString:christmasDateString];
    
    return christmasDate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //Get current date
    NSDate* now = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *currentDateComponents = [gregorian components:(NSYearCalendarUnit) fromDate:now];
    
    NSInteger year = [currentDateComponents year];
    NSLog(@"current year: %d ", year);
    
    //Christmas date
    NSString *christmasDateString = [NSString stringWithFormat:@"%d-12-25", year];
    NSLog(@"Christmas this year: %@", christmasDateString);
    
    NSDate* christmasDate = [self getChristmasDate:christmasDateString];
    
    NSDateComponents *christmasDayComponents = [gregorian components:(NSDayCalendarUnit) fromDate:now toDate:christmasDate options:0];
    
    if([christmasDayComponents day] < 0){
        
        NSString *christmasDateString = [NSString stringWithFormat:@"%d-12-25", year+1];
        NSLog(@"Christmas this year: %@", christmasDateString);
        
        NSDate* newChristmasDate = [self getChristmasDate:christmasDateString];
        
        NSDateComponents *christmasNewDayComponents = [gregorian components:(NSDayCalendarUnit) fromDate:now toDate:newChristmasDate options:0];
        NSLog(@"Days till christmas: %d", [christmasNewDayComponents day] );
        self.yearLabel.text = [NSString stringWithFormat:@"%d", year+1];
        self.daysLabel.text = [NSString stringWithFormat:@"%d", [christmasNewDayComponents day]];
    } else{
        NSLog(@"Days till christmas: %d", [christmasDayComponents day] );
        self.yearLabel.text = [NSString stringWithFormat:@"%d", year];
        self.daysLabel.text = [NSString stringWithFormat:@"%d", [christmasDayComponents day]];
    }
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
