//
//  ABCMapTabViewController.m
//  MyFirstMapApp
//
//  Created by Rajesh Kamineni on 2/1/14.
//  Copyright (c) 2014 Rajesh Kamineni. All rights reserved.
//

#import "ABCMapTabViewController.h"

@interface ABCMapTabViewController ()

@end

@implementation ABCMapTabViewController

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
    
    ABCTabViewController *tabBar = (ABCTabViewController *)self.tabBarController;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:tabBar.locationData.locationLat longitude:tabBar.locationData.locationLng];
      
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
