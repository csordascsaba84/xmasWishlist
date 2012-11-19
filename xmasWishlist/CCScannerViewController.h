//
//  CCScannerViewController.h
//  xmasWishlist
//
//  Created by Csaba Csordas on 19/11/2012.
//  Copyright (c) 2012 Csaba Csordas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@class Reachability;

@interface CCScannerViewController : UIViewController <ZBarReaderDelegate>

@property (nonatomic) BOOL internetActive;
@property (nonatomic) BOOL hostActive;
@property (nonatomic,strong) Reachability* internetReacheble;
@property (nonatomic,strong) Reachability* hostReacheble;

@property (nonatomic, strong) NSMutableArray *resultList;

- (IBAction)scanPressed:(UIButton *)sender;
- (void) checkNetworkStatus:(NSNotification *)notice;

@end
