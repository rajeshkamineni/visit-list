//
//  ABCSaveLocationViewController.h
//  MyFirstMapApp
//
//  Created by Rajesh Kamineni on 1/31/14.
//  Copyright (c) 2014 Rajesh Kamineni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABCMapData.h"
#import <sqlite3.h>

@interface ABCSaveLocationViewController : UIViewController <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UITextView *address;
@property (weak, nonatomic) IBOutlet UITextView *note;
@property (weak, nonatomic) IBOutlet UIButton *save;
@property ABCMapData *markerUserData;
@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *mapData;
@end
