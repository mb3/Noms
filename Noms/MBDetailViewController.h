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

// Labels at the top of the window for the name of the restaurant and the type of cuisine they offer.
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cuisineLabel;

// The dark grey/blue background behind the name and cuisine labels. Only used as a reference point for laying out
// the items below it (hours label and contact buttons).
@property (strong, nonatomic) IBOutlet UIView *headerView;
// The scroll view that everything resides in.
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

// The current restaurant object that the detail view is looking at.
@property (strong, nonatomic) MBFactualRestaurant *restaurant;

// Convenience method for creating a button with a given title. Performs some additional sizing and layout operations
// to lay it out vertically beneath the previous view.
- (UIButton *)buttonWithTitle:(NSString *)string;

// Actions for each of the three possible contact buttons.
- (void)dialPhoneNumber;
- (void)openWebsite;
- (void)openMap;

@end
