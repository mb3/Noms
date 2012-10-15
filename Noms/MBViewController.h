//
//  MBViewController.h
//  Noms
//
//  Created by Michael Bailey on 2012-10-14.
//  Copyright (c) 2012 Michael Bailey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITextField *searchTermsTextField;
@property (strong, nonatomic) IBOutlet UITextField *cityStateTextField;

- (void)performFactualRestaurantSearch;

@end
