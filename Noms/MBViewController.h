//
//  MBViewController.h
//  Noms
//
//  Created by Michael Bailey on 2012-10-14.
//  Copyright (c) 2012 Michael Bailey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBDetailViewController;

@interface MBViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) IBOutlet UITextField *searchTermsTextField;
@property (strong, nonatomic) IBOutlet UITextField *cityStateTextField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (void)performFactualRestaurantSearch;
- (void)parseJSON;

@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableData *jsonData;
@property (strong, nonatomic) NSMutableArray *restaurants;

@end
