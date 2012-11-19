//
//  ListItem.h
//  christmas wishlist
//
//  Created by Csaba Csordas on 07/11/2011.
//  Copyright (c) 2011 iosdev.hu. All rights reserved.
//



@interface ListItem : NSObject

@property (nonatomic) int itemID;
@property (nonatomic) int listID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *placeToBuy;
@property (nonatomic, strong) NSString *info;

@end
