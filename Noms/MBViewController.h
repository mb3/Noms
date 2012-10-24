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

// Text field for the user to enter general search terms. This maps to Factual's free-text search ("q=" in the URL).
@property (strong, nonatomic) IBOutlet UITextField *searchTermsTextField;
// Text field for the user to enter a city and state pair. Attempts to handle both comma-separated and space-separated values.
@property (strong, nonatomic) IBOutlet UITextField *cityStateTextField;
// Table view for storing the search results returned from Factual.
@property (strong, nonatomic) IBOutlet UITableView *tableView;
// Button to enable or disable detection of the user's location.
@property (strong, nonatomic) IBOutlet UIButton *locationButton;

// Called when the location button is pressed. Toggles Location Services on or off, and enables or disables the
// city/state text field accordingly.
- (IBAction)toggleLocationServices;

// Called whne the user taps Search from the keyboard in one of the two text fields. Captures the string values from the
// two text fields, performs some basic string manipulation to get them into a format Factual will accept, and initiates
// a request with a URL contructed from those strings.
- (void)performFactualRestaurantSearch;
// Converts the data returned by Factual for a given query from JSON format to an NSDictionary. Called when the URL
// connection object informs the delegate that its download has completed.
- (void)parseJSON;

// The URL connection object used for sending the request to Factual and receiving the results.
@property (strong, nonatomic) NSURLConnection *connection;

// Buffer for the raw JSON data as it is returned from Factual.
@property (strong, nonatomic) NSMutableData *jsonData;
// An array of MBFactualRestaurant objects created from the Factual data that are used to populate the table view.
@property (strong, nonatomic) NSMutableArray *restaurants;

// Objects for managing Location Services.
@property (strong, nonatomic) CLLocationManager *locationManager;
// Storage for the location (lat/long) and placemark (address, etc.) information retrieved by Location Services.
// If the user disables and then re-enables Location Services without moving significantly, CLLocationManager will
// not send its delagate any location data as the location has not changed. Therefore, it's useful to hold onto the
// last known location.
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) CLPlacemark *cachedPlacemark;

@end
