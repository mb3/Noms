//
//  MBViewController.h
//  Noms
//
//  Created by Michael Bailey on 2012-10-14.
//  Copyright (c) 2012 Michael Bailey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class MBDetailViewController;

@interface MBViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, NSURLConnectionDelegate, NSURLConnectionDataDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *searchTermsTextField;
@property (strong, nonatomic) IBOutlet UITextField *cityStateTextField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *locationButton;

- (IBAction)toggleLocationServices;

- (void)performFactualRestaurantSearch;
- (void)parseJSON;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSURLConnection *connection;

@property (strong, nonatomic) NSMutableData *jsonData;
@property (strong, nonatomic) NSMutableArray *restaurants;

@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) CLPlacemark *cachedPlacemark;

@end
