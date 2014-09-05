//
//  ABCPlaceListViewController.m
//  MyFirstMapApp
//
//  Created by Rajesh Kamineni on 1/21/14.
//  Copyright (c) 2014 Rajesh Kamineni. All rights reserved.
//

#import "ABCPlaceListViewController.h"
#import "ABCLocationCellData.h"
#import "ABCLocationMapViewController.h"


@interface ABCPlaceListViewController ()

@property NSMutableArray *LocationCells;

@end

@implementation ABCPlaceListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    _LocationCells = [[NSMutableArray alloc] init];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:220.0/255.0 green:20.0/255.0 blue:60.0/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    
    _LocationCells = [[NSMutableArray alloc] init];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.tableView.contentInset = inset;


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    _databasePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/markerData.db"];
    
    sqlite3_stmt   *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    int resultCount = 0;
    if (sqlite3_open(dbpath, &_mapData) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT count(*) FROM MAPDATA"];
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
        
        querySQL = [NSString stringWithFormat: @"SELECT * FROM MAPDATA"];
        query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_mapData,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *ID = [[NSString alloc]
                                  initWithUTF8String:
                                  (const char *) sqlite3_column_text(
                                                                     statement, 0)];
                
                NSString *reference = [[NSString alloc]
                                       initWithUTF8String:
                                       (const char *) sqlite3_column_text(
                                                                     statement, 1)];
                
                NSString *name = [[NSString alloc]
                                  initWithUTF8String:
                                  (const char *) sqlite3_column_text(
                                                                     statement, 2)];
                NSString *address = [[NSString alloc]
                                  initWithUTF8String:
                                  (const char *) sqlite3_column_text(
                                                                     statement, 3)];
                
                NSString *note = [[NSString alloc]
                                     initWithUTF8String:
                                     (const char *) sqlite3_column_text(
                                                                        statement, 4)];

                
                double lat = sqlite3_column_double(statement, 5);
                
                double lng = sqlite3_column_double(statement, 6);
                
                
                ABCLocationCellData *cellData = [[ABCLocationCellData alloc] init];
                cellData.locationID = ID;
                cellData.locationName = name;
                cellData.locationReference = reference;
                cellData.locationAddress = address;
                cellData.locationLat = lat;
                cellData.locationLng = lng;
                cellData.locationNote = note;
                
                [_LocationCells addObject:cellData];
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_mapData);
    }
    
    return resultCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LocationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    ABCLocationCellData *cellData = [_LocationCells objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UILabel *subLabel = (UILabel *)[cell viewWithTag:100];
    subLabel.text = cellData.locationName;
    
    UILabel *subLabel2 = (UILabel *)[cell viewWithTag:102];
    subLabel2.text = cellData.locationAddress;
    
    // Configure the cell...
    
    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
    
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;
    
    return cell;
}

- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger rowCount = [self tableView:[self tableView] numberOfRowsInSection:0];
    NSInteger rowIndex = indexPath.row;
    UIImage *background = nil;
    
    if (rowIndex == 0) {
        background = [UIImage imageNamed:@"cell_top@2x.png"];
    } else if (rowIndex == rowCount - 1) {
        background = [UIImage imageNamed:@"cell_bottom@2x.png"];
    } else {
        background = [UIImage imageNamed:@"cell_middle@2x.png"];
    }
   
    return background;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSString *docsDir;
        NSArray *dirPaths;
        // Get the documents directory
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        docsDir = dirPaths[0];
        
        // Build the path to the database file
          _databasePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/markerData.db"];
        
        sqlite3_stmt   *statement;
        const char *dbpath = [_databasePath UTF8String];
        
        ABCLocationCellData *locationCell = [_LocationCells objectAtIndex:indexPath.row];
        
        if (sqlite3_open(dbpath, &_mapData) == SQLITE_OK)
        {
            NSString *querySQL = [NSString stringWithFormat: @"DELETE FROM MAPDATA WHERE id = \"%@\"", locationCell.locationID];
            const char *query_stmt = [querySQL UTF8String];
            
            sqlite3_prepare_v2(_mapData, query_stmt, -1, &statement, NULL);
            
            if (sqlite3_step(statement) == SQLITE_DONE) {
                sqlite3_finalize(statement);
                [_LocationCells removeObjectAtIndex:indexPath.row];
                [tableView beginUpdates];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                 withRowAnimation:UITableViewRowAnimationFade];
                [tableView endUpdates];
            }
            sqlite3_close(_mapData);
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"LocationOnMap"]){
        ABCLocationMapViewController *controller = (ABCLocationMapViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        controller.locationData = _LocationCells[indexPath.row];
    }
}



@end
