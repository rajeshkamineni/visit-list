//
//  ABCNoteTabViewController.m
//  MyFirstMapApp
//
//  Created by Rajesh Kamineni on 2/1/14.
//  Copyright (c) 2014 Rajesh Kamineni. All rights reserved.
//

#import "ABCNoteTabViewController.h"
#import "ABCTabViewController.h"

@interface ABCNoteTabViewController ()

@end

@implementation ABCNoteTabViewController

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
    
     ABCTabViewController *tabBar = (ABCTabViewController *)self.tabBarController;
    
    self.name.text = tabBar.locationData.locationName;
    
    self.address.text =  tabBar.locationData.locationAddress;
    self.address.contentMode = UIViewContentModeTop;
    self.address.editable = NO;
    
    self.note.layer.borderWidth = 2.0f;
    self.note.layer.borderColor = [[UIColor grayColor] CGColor];
    self.note.layer.cornerRadius = 8;
    self.note.contentInset = UIEdgeInsetsMake(1.0, 0.0, 1.0, 0.0);
    
    NSString *docsDir;
    NSArray *dirPaths;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    _databasePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/markerData.db"];
    
    const char *dbpath = [_databasePath UTF8String];
    
    sqlite3_stmt   *statement;
    NSString *note;
    
    if (sqlite3_open(dbpath, &_mapData) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT note FROM MAPDATA WHERE id = \"%@\"", tabBar.locationData.locationID];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(_mapData,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                        note = [[NSString alloc]
                                initWithUTF8String:
                                (const char *) sqlite3_column_text(
                                                                   statement, 0)];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_mapData);
        
    }
    
    self.note.text = note;
    self.note.editable = NO;
    self.note.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
}

- (void) dismissKeyboard
{
    // add self
    [self.view endEditing:YES];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    
    [UIView beginAnimations:nil context:NULL]; [UIView setAnimationDuration:0.55f];
    
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    [self.view setFrame:frame];
    
    [UIView commitAnimations];
    
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    [UIView beginAnimations:nil context:NULL]; [UIView setAnimationDuration:0.35f];
    
    CGRect frame = self.view.frame;
    frame.origin.y = -161
    ;
    [self.view setFrame:frame];
    
    [UIView commitAnimations];
    
    return YES;
}

- (IBAction)editNote:(id)sender {
    self.editNote.hidden = YES;
    self.saveNote.hidden = NO;
    self.note.editable = YES;
    [self.note becomeFirstResponder];
}

- (IBAction)saveNote:(id)sender {
    
    self.note.editable = NO;
    [self.note resignFirstResponder];
    
    ABCTabViewController *tabBar = (ABCTabViewController *)self.tabBarController;
    
    NSString *docsDir;
    NSArray *dirPaths;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    _databasePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/markerData.db"];
    
    const char *dbpath = [_databasePath UTF8String];
    
    sqlite3_stmt   *statement;
    
    if (sqlite3_open(dbpath, &_mapData) == SQLITE_OK)
    {
        
            NSString *insertSQL = [NSString stringWithFormat:
                                   @"UPDATE MAPDATA SET note = \"%@\" WHERE id = \"%@\"",
                                   self.note.text, tabBar.locationData.locationID];
        
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(_mapData, insert_stmt,
                               -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                //NSLog(@"%@", @"Updated Note successfully :)");
            } else {
                //NSLog(@"%@", @"failed to store data :(");
                NSLog(@"Error %s while preparing statement", sqlite3_errmsg(_mapData));
            }
            sqlite3_finalize(statement);
            sqlite3_close(_mapData);
    }

    self.saveNote.hidden = YES;
    self.editNote.hidden = NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
