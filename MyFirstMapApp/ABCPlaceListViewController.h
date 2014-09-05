//
//  ABCPlaceListViewController.h
//  MyFirstMapApp
//
//  Created by Rajesh Kamineni on 1/21/14.
//  Copyright (c) 2014 Rajesh Kamineni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface ABCPlaceListViewController : UITableViewController
@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *mapData;
@end
