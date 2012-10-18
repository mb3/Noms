//
//  MBDetailViewController.h
//  Noms
//
//  Created by Michael Bailey on 2012-10-14.
//  Copyright (c) 2012 Michael Bailey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBFactualRestaurant;

@interface MBDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;
@property (strong, nonatomic) MBFactualRestaurant *restaurant;

@end
