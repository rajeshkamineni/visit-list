//
//  ABCLocationMapViewController.h
//  MyFirstMapApp
//
//  Created by Rajesh Kamineni on 1/24/14.
//  Copyright (c) 2014 Rajesh Kamineni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "ABCLocationCellData.h"

@interface ABCLocationMapViewController : UIViewController<GMSMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *directions;
@property ABCLocationCellData *locationData;
@end
