//
//  ABCTabViewController.m
//  MyFirstMapApp
//
//  Created by Rajesh Kamineni on 2/1/14.
//  Copyright (c) 2014 Rajesh Kamineni. All rights reserved.
//

#import "ABCTabViewController.h"

@interface ABCTabViewController ()

@end

@implementation ABCTabViewController

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
    self.title = @"Location";
    self.tabBar.translucent = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
