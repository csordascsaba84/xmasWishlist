//
//  CCDetailViewController.h
//  xmasWishlist
//
//  Created by Csaba Csordas on 05/11/2012.
//  Copyright (c) 2012 Csaba Csordas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
