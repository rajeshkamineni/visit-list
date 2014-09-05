//
//  ABCSearchPlacesViewController.m
//  MyFirstMapApp
//
//  Created by Rajesh Kamineni on 1/29/14.
//  Copyright (c) 2014 Rajesh Kamineni. All rights reserved.
//

#import "ABCSearchPlacesViewController.h"
#import "ABCCustomInfoWindow.h"
#import "ABCUserMessages.h"
#import "ABCMapData.h"
#import "Reachability.h"
#import "ABCSaveLocationViewController.h"

@interface ABCSearchPlacesViewController ()

@end

@implementation ABCSearchPlacesViewController

GMSMapView *mapView_;


// replace the below API key with your google places API Key
NSString *search_api_key = @"YOUR_API_KEY";


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
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:220.0/255.0 green:20.0/255.0 blue:60.0/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

	// Do any additional setup after loading the view.
    _searchBar.delegate = (id)self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void) dismissKeyboard
{
    // add self
    [self.searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityView.center=self.view.center;
    [activityView startAnimating];
    [self.mapView addSubview:activityView];
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    //NSLog(@"%@ data: ", data);
    [self.responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    //NSLog(@"Succeeded! Received %d bytes of data",[_responseData length]);
    
    
    NSError *e = nil;
    self.jsonArray = [[NSDictionary alloc] init];
    self.jsonArray = [NSJSONSerialization JSONObjectWithData: self.responseData options: NSJSONReadingMutableContainers error: &e];
    
    NSString *statuscode = [self.jsonArray objectForKey:@"status"];
    
    GMSMapView *locationMapView ;
    
    if ([statuscode isEqualToString:@"OK"]) {
        
        NSArray *results = [self.jsonArray objectForKey:@"results"];
        
        for (int i = 0; i < [results count]; i++)
        {
            NSDictionary *d = [results objectAtIndex:i];
            NSNumber *lat = d[@"geometry"][@"location"][@"lat"];
            NSNumber *lng = d[@"geometry"][@"location"][@"lng"];
            
            NSString *locationName = d[@"name"];
            NSString *locationAddress = d[@"formatted_address"];
            NSString *locationReference = d[@"reference"];
            NSString *locationID = d[@"id"];
            NSString *locationIcon = d[@"icon"];
            
            CLLocation *listingLocation = [[CLLocation alloc] initWithLatitude:[lat doubleValue] longitude:[lng doubleValue]];
            
            
            if (i == 0) {
                // Create a GMSCameraPosition that tells the map to display the
                GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:listingLocation.coordinate.latitude
                                                                        longitude:listingLocation.coordinate.longitude
                                                                             zoom:8];
                
                
                locationMapView = [[[NSBundle mainBundle] loadNibNamed:@"locationMapView" owner:self options:nil] objectAtIndex:0];
                
                locationMapView.camera = camera;
                locationMapView.myLocationEnabled = YES;
                locationMapView.settings.myLocationButton = YES;
                locationMapView.delegate = self;
                
                // Creates a marker in the center of the map.
                GMSMarker *marker = [[GMSMarker alloc] init];
                marker.position = CLLocationCoordinate2DMake(listingLocation.coordinate.latitude, listingLocation.coordinate.longitude);
                marker.title = locationName;
                marker.snippet = locationAddress;
                marker.map = locationMapView;
                
                ABCMapData* data = [[ABCMapData alloc] init];
                data.ID = locationID;
                data.name = locationName;
                data.address = locationAddress;
                data.reference = locationReference;
                data.icon = locationIcon;
                data.lat = [lat doubleValue];
                data.lng = [lng doubleValue];
                
                marker.userData = data;
                
            } else {
                GMSMarker *marker = [[GMSMarker alloc] init];
                marker.position = CLLocationCoordinate2DMake(listingLocation.coordinate.latitude, listingLocation.coordinate.longitude);
                marker.title = locationName;
                marker.snippet = locationAddress;
                marker.map = locationMapView;
                
                ABCMapData* data = [[ABCMapData alloc] init];
                data.ID = locationID;
                data.name = locationName;
                data.address = locationAddress;
                data.reference = locationReference;
                data.icon = locationIcon;
                data.lat = [lat doubleValue];
                data.lng = [lng doubleValue];

                
                marker.userData = data;
            }
            
        }

        [self.mapView addSubview:locationMapView];
        
        
    }  else if ([statuscode isEqualToString:@"OVER_QUERY_LIMIT"]) {
        ABCUserMessages *messageWindow = [[[NSBundle mainBundle] loadNibNamed:@"userMessages" owner:self options:nil] objectAtIndex:0];
        messageWindow.message.text = @"Sorry! Try Again Later";
        [self.mapView addSubview:messageWindow];
    } else {
        ABCUserMessages *messageWindow = [[[NSBundle mainBundle] loadNibNamed:@"userMessages" owner:self options:nil] objectAtIndex:0];
        messageWindow.message.text = @"No Results Found :(";
        [self.mapView addSubview:messageWindow];
    }
    
    
    _jsonArray = nil;
    _conn = nil;
    _responseData = nil;
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    _responseData = nil;
    _conn = nil;
    
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    NSLog(@"%@", @"failed with err");
    
    ABCUserMessages *messageWindow = [[[NSBundle mainBundle] loadNibNamed:@"userMessages" owner:self options:nil] objectAtIndex:0];
    messageWindow.message.text = @"Error Occured! Try Again Later";
    [self.mapView addSubview:messageWindow];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        /* No Internet Connection*/
        ABCUserMessages *messageWindow = [[[NSBundle mainBundle] loadNibNamed:@"userMessages" owner:self options:nil] objectAtIndex:0];
        messageWindow.message.text = @"No Internet Connection :(";
        [self.mapView addSubview:messageWindow];
        
    } else {
        
        NSString *squashed = [_searchBar.text stringByReplacingOccurrencesOfString:@"[ ]+"
                                                                        withString:@"+"
                                                                           options:NSRegularExpressionSearch
                                                                             range:NSMakeRange(0, _searchBar.text.length)];
        
        NSString *queryKeyFinal = [squashed stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSMutableString *queryUrl = [NSMutableString stringWithString: @"https://maps.googleapis.com/maps/api/place/textsearch/json?query="];
        [queryUrl appendString: queryKeyFinal];
        [queryUrl appendString: @"&sensor=true&key="];
        [queryUrl appendString: search_api_key];
        
        /* Asynchronus Request */
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:queryUrl]];
        self.responseData = [NSMutableData dataWithCapacity: 0];
        
        
        _conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        if (!_conn) {
            _responseData = nil;
            NSLog(@"%@", @"No Data Received");
        }
    }

}


- (void) mapView: (GMSMapView *) mapView didTapInfoWindowOfMarker: (GMSMarker *) marker {
    [self.searchBar resignFirstResponder];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle: nil];
    ABCSaveLocationViewController *saveController = [storyboard instantiateViewControllerWithIdentifier:@"saveLocationView"];
    saveController.markerUserData = marker.userData;
    [self.navigationController pushViewController:saveController animated:YES];
    
    mapView.selectedMarker = nil;
}

- (UIView *) mapView: (GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    ABCCustomInfoWindow *infoWindow = [[[NSBundle mainBundle] loadNibNamed:@"InfoWindow" owner:self options:nil] objectAtIndex:0];
    
    infoWindow.name.text = marker.title;
    infoWindow.name.textColor = [UIColor whiteColor];
    infoWindow.snippet.text = marker.snippet;
    infoWindow.snippet.textColor = [UIColor whiteColor];
    
    return infoWindow;
}

- (void) mapView:(GMSMapView *) mapView didTapAtCoordinate:	(CLLocationCoordinate2D) coordinate {
    [self.searchBar resignFirstResponder];
}


@end
