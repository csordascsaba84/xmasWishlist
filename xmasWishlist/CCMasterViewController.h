//
//  CCMasterViewController.h
//  xmasWishlist
//
//  Created by Csaba Csordas on 05/11/2012.
//  Copyright (c) 2012 Csaba Csordas. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface CCMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
