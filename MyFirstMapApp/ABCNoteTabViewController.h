//
//  ABCNoteTabViewController.h
//  MyFirstMapApp
//
//  Created by Rajesh Kamineni on 2/1/14.
//  Copyright (c) 2014 Rajesh Kamineni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>


@interface ABCNoteTabViewController : UIViewController <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UITextView *address;
@property (weak, nonatomic) IBOutlet UITextView *note;
@property (weak, nonatomic) IBOutlet UIButton *editNote;
@property (weak, nonatomic) IBOutlet UIButton *saveNote;
@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *mapData;
@end
