//
//  ABCTabViewController.h
//  MyFirstMapApp
//
//  Created by Rajesh Kamineni on 2/1/14.
//  Copyright (c) 2014 Rajesh Kamineni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABCLocationCellData.h"


@interface ABCTabViewController : UITabBarController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *directions;
@property ABCLocationCellData *locationData;
@end
