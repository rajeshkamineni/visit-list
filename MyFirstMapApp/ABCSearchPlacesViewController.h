//
//  ABCSearchPlacesViewController.h
//  MyFirstMapApp
//
//  Created by Rajesh Kamineni on 1/29/14.
//  Copyright (c) 2014 Rajesh Kamineni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <sqlite3.h>


@interface ABCSearchPlacesViewController : UIViewController <GMSMapViewDelegate, NSURLConnectionDelegate, UIBarPositioningDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *mapView;
@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *mapData;
@property NSMutableData *responseData;
@property NSURLConnection *conn;
@property NSDictionary *jsonArray;
@end
