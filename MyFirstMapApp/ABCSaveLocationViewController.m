//
//  ABCSaveLocationViewController.m
//  MyFirstMapApp
//
//  Created by Rajesh Kamineni on 1/31/14.
//  Copyright (c) 2014 Rajesh Kamineni. All rights reserved.
//

#import "ABCSaveLocationViewController.h"
#import "ABCUserMessages.h"


@interface ABCSaveLocationViewController ()

@end

@implementation ABCSaveLocationViewController


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
    
    NSString *docsDir;
    NSArray *dirPaths;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    _databasePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/markerData.db"];
    
    const char *dbpath = [_databasePath UTF8String];
    
    sqlite3_stmt   *statement;
    
    int resultCount = 0;
    
    if (sqlite3_open(dbpath, &_mapData) == SQLITE_OK)
    {
        
        resultCount = 0;
        NSString *querySQL = [NSString stringWithFormat: @"SELECT count(*) FROM MAPDATA WHERE id=\"%@\"", _markerUserData.ID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_mapData,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                resultCount = sqlite3_column_int(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(_mapData);
    }

    
    if (resultCount > 0) {
        ABCUserMessages *messageWindow = [[[NSBundle mainBundle] loadNibNamed:@"userMessages" owner:self options:nil] objectAtIndex:0];
        messageWindow.message.text = @"Already in your List :)";
        [self.view addSubview:messageWindow];
    } else {
        self.name.text = _markerUserData.name;
        
        self.address.text =  _markerUserData.address;
        self.address.contentMode = UIViewContentModeTop;
        self.address.editable = NO;

        self.note.layer.borderWidth = 2.0f;
        self.note.layer.borderColor = [[UIColor grayColor] CGColor];
        self.note.layer.cornerRadius = 8;
        self.note.contentInset = UIEdgeInsetsMake(1.0, 0.0, 1.0, 0.0);
        
        self.note.delegate = self;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(dismissKeyboard)];
        
        [self.view addGestureRecognizer:tap];
        
    }
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
    frame.origin.y = -180;
    [self.view setFrame:frame];
    
    [UIView commitAnimations];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
      
    NSString *docsDir;
    NSArray *dirPaths;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    _databasePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/markerData.db"];
    
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_mapData) == SQLITE_OK)
    {
        
        char *errMsg;
        const char *sql_stmt =
        "CREATE TABLE IF NOT EXISTS MAPDATA (ID TEXT PRIMARY KEY, REFERENCE TEXT, NAME TEXT,  ADDRESS TEXT, NOTE TEXT, LAT DOUBLE, LNG DOUBLE)";
        
        if (sqlite3_exec(_mapData, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
        {
            NSLog(@"%@",@"Failed to create table");
        }
        sqlite3_close(_mapData);
    } else {
        NSLog(@"%@", @"Failed to open/create database");
    }
    
    sqlite3_stmt   *statement;
    
    /* Below code for data insertion */
    
    if (sqlite3_open(dbpath, &_mapData) == SQLITE_OK)
    {
        
        int resultCount = 0;
        NSString *querySQL = [NSString stringWithFormat: @"SELECT count(*) FROM MAPDATA WHERE id=\"%@\"", _markerUserData.ID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_mapData,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                resultCount = sqlite3_column_int(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        
        if (resultCount == 0) {
            NSString *insertSQL = [NSString stringWithFormat:
                                   @"INSERT INTO MAPDATA (id, reference, name, address, note, lat, lng) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%f\", \"%f\")",
                                   _markerUserData.ID, _markerUserData.reference, _markerUserData.name, _markerUserData.address, _note.text, _markerUserData.lat, _markerUserData.lng];
            
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(_mapData, insert_stmt,
                               -1, &statement, NULL);
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSLog(@"Error %s while preparing statement", sqlite3_errmsg(_mapData));
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(_mapData);
    }

    
}

- (IBAction)save:(id)sender {

}

@end
