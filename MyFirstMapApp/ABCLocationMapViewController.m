//
//  ABCLocationMapViewController.m
//  MyFirstMapApp
//
//  Created by Rajesh Kamineni on 1/24/14.
//  Copyright (c) 2014 Rajesh Kamineni. All rights reserved.
//

#import "ABCLocationMapViewController.h"

@interface ABCLocationMapViewController ()

@end

@implementation ABCLocationMapViewController

GMSMapView *mapView_;

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
    
    
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:_locationData.locationLat longitude:_locationData.locationLng];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:location.coordinate.latitude
                                                            longitude:location.coordinate.longitude
                                                                 zoom:12];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    mapView_.settings.myLocationButton = YES;
    self.view = mapView_;
    
    // Creates a marker in the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    marker.map = mapView_;
    
    
}

- (IBAction)directions:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL:
         [NSURL URLWithString:@"comgooglemaps://"]]) {
        
        NSString* url = [NSString stringWithFormat: @"comgooglemaps://?daddr=%f,%f&zoom=10",
                                              _locationData.locationLat, _locationData.locationLng];
        
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:url]];
    } else {
        NSLog(@"Can't use comgooglemaps://");
        NSString* version = [[UIDevice currentDevice] systemVersion];
        NSString *mapScheme = @"maps.apple.com";
        if ([version compare:@"6.0" options:NSNumericSearch] == NSOrderedAscending){
            mapScheme = @"maps.google.com";
        }
        NSString* url = [NSString stringWithFormat: @"http://%@/maps?saddr=Current+Location&daddr=%f,%f", mapScheme,
                         _locationData.locationLat, _locationData.locationLng];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
