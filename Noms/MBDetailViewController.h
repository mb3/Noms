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

//@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cuisineLabel;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) MBFactualRestaurant *restaurant;

- (UIButton *)buttonWithTitle:(NSString *)string;

- (void)dialPhoneNumber;
- (void)openWebsite;
- (void)openMap;

@end
