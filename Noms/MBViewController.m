//
//  MBViewController.m
//  Noms
//
//  Created by Michael Bailey on 2012-10-14.
//  Copyright (c) 2012 Michael Bailey. All rights reserved.
//

#import "MBViewController.h"
#import "MBDetailViewController.h"
#import "MBFactualRestaurant.h"

static const NSString *kFactualAPIKey = @"EsClMNOcpTnieYueu5igO44aUSX5kpPzFh0O4kId";

@interface MBViewController () {
}

@end

@implementation MBViewController


- (void)viewDidLoad  {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;	
}

// Deselect any table rows that are selected when the view displays (e.g. when navigating back from the detail view).
// We don't get this for free because we're not just a UITableViewController subclass.
- (void)viewWillAppear:(BOOL)animated  {
	[super viewWillAppear:animated];
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
}

- (void)didReceiveMemoryWarning  {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


#pragma mark - Instance methods

// Parse input from the two text fields (if needed, or use Location Services), and concatenate them into a URL to
// query Factual with.
- (void)performFactualRestaurantSearch  {
	
	// Construct the query URL. This all needs to be properly percent-escaped or NSURL won't take it, hence the multiple parts.
	
	NSString *requestURLPrefix  = @"http://api.v3.factual.com/t/restaurants-us?";
	NSString *requestURLQuery   = [NSString stringWithFormat:@"q=%@", self.searchTermsTextField.text];
	NSString *requestStringEncoded;
	
	// Use Location Services data if it's enabled.
	
	if (self.locationButton.selected) {
		NSString *requestCoordinates = [NSString stringWithFormat:@"geo={\"$circle\":{\"$center\":[%f,%f],\"$meters\":5000}}", self.location.coordinate.latitude, self.location.coordinate.longitude];
		NSString *requestURLQueryEncoded = [requestURLQuery stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSString *requestCoordinatesEncoded = [requestCoordinates stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		
		requestStringEncoded = [NSString stringWithFormat:@"%@%@&%@&KEY=%@", requestURLPrefix, requestURLQueryEncoded, requestCoordinatesEncoded, kFactualAPIKey];
	} else  {
		
		// Otherwise, use input from the city / state text field.
	
		// Strip out periods from the input. Factual doesn't like them, and iOS autocorrects certain things to include periods, e.g. "Washington, D.C.".
		NSString *cityStateText = [self.cityStateTextField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
		
		// String processing for city, state location. First, try to get City, ST as comma-separated values.
		NSMutableString *locality = [NSMutableString stringWithFormat:@""];  // A nil string will print as "(null)"
		NSString *region = @"";
		
		NSArray *locationComponents = [cityStateText componentsSeparatedByString:@", "];
		
		// If there aren't any commas, try checking for words separated by spaces.
		if (locationComponents.count < 2) {
			locationComponents = [cityStateText componentsSeparatedByString:@" "];
			// If there's still only one word found, just use that as the "locality" for Factual.
			if (locationComponents.count < 2) {
				locality = locationComponents[0];
			} else if (locationComponents.count > 2) {  // Otherwise, check for multiple spaces (multiple-word cities).
				region = locationComponents[locationComponents.count - 1];  // Last string component should be the state / "region".
				for (int i=0; i < locationComponents.count - 1; i++) {
					[locality appendFormat:@" %@", locationComponents[i]];
				}
				locality = (NSMutableString *)[locality stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
			}  else {
				locality = locationComponents[0];
				region = locationComponents[1];
			}
		} else {
			locality = locationComponents[0];
			region = locationComponents[1];
		}
				
		NSString *requestURLFilters = [NSString stringWithFormat:@"filters={\"region\":\"%@\",\"locality\":\"%@\"}", region, locality];
		
		NSString *requestURLQueryEncoded = [requestURLQuery stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSString *requestURLFiltersEncoded = [requestURLFilters stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		
		requestStringEncoded = [NSString stringWithFormat:@"%@%@&%@&KEY=%@", requestURLPrefix, requestURLQueryEncoded, requestURLFiltersEncoded, kFactualAPIKey];
		
	}

	// Set up an asynchronous URL request, and initialize the NSMutableData object to start receiving the JSON data.
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestStringEncoded]];
	self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
	
	self.jsonData = [NSMutableData data];
	
}

// Parse the JSON return from Factual into an NSDictionary, create a MBFactualRestaurant object from each sub-dictionary
// it contains, and add those new objects to the array that backs the table view.
- (void)parseJSON  {
	NSError *parseError = nil;
	NSDictionary *factualResponse = [NSJSONSerialization JSONObjectWithData:self.jsonData options:0 error:&parseError];
	
	if (!parseError) {
		self.restaurants = [[NSMutableArray alloc] initWithCapacity:20];
		
		for (NSDictionary *dict in [[factualResponse objectForKey:@"response"] objectForKey:@"data"]) {
			MBFactualRestaurant *restaurant = [MBFactualRestaurant restaurantFromFactualDictionary:dict];
			[self.restaurants addObject:restaurant];
		}
	}
	
	if (self.restaurants.count > 0) {
		[self.tableView reloadData];
		[self.tableView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];  // Scroll to the top when loading new data
	} else  {
		UIAlertView *noResultsAlert = [[UIAlertView alloc] initWithTitle:@"No results found."
																														 message:nil
																														delegate:nil
																									 cancelButtonTitle:@"Dismiss"
																									 otherButtonTitles:nil];
		[noResultsAlert show];
	}
}

// Flip Location services on or off, reset the text in the City, ST text field, and prepopulate it with the last known
// location if we have one cached.
- (IBAction)toggleLocationServices  {
	self.locationButton.selected = !self.locationButton.selected;
	self.cityStateTextField.text = @"";

	if (self.locationButton.selected) {
		[self.locationManager startMonitoringSignificantLocationChanges];
		self.cityStateTextField.enabled = NO;

		// A bit of a hack, but since CLLocationManager doesn't fire its delegate method until the location has *changed*, continue to fill in the existing location if we already have one.
		if (self.location && self.cachedPlacemark) {
			self.cityStateTextField.textColor = [UIColor blueColor];
			self.cityStateTextField.text = [NSString stringWithFormat:@"%@, %@", self.cachedPlacemark.locality, self.cachedPlacemark.administrativeArea];
		}
	} else  {
		[self.locationManager stopMonitoringSignificantLocationChanges];
		self.cityStateTextField.textColor = [UIColor darkTextColor];
		self.cityStateTextField.enabled = YES;
	}
}


#pragma mark - NSURLConnectionDelegate methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error  {
	if (error.code == NSURLErrorNotConnectedToInternet) {
		UIAlertView *notConnectedAlert = [[UIAlertView alloc] initWithTitle:@"Your device is not connected to the internet."
																																message:nil
																															 delegate:nil
																											cancelButtonTitle:@"Dismiss"
																											otherButtonTitles:nil];
		[notConnectedAlert show];
	} else  {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Failed"
																										message:[NSString stringWithFormat:@"The error was:\n%@", error]
																									 delegate:nil
																					cancelButtonTitle:@"Dismiss"
																					otherButtonTitles:nil];
		[alert show];
	}
}


#pragma mark - NSURLConnectionDataDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data  {
	[self.jsonData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection  {
	[self parseJSON];
}


#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView  {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  {
	return self.restaurants.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
	static NSString *cellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
	if (cell == nil)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	
	cell.textLabel.text = [(MBFactualRestaurant *)self.restaurants[[indexPath row]] name];
		
	return cell;
}

// This is not an editable table view
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath  {
	return NO;
}

// This is not a reorderable table view
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath  {
	return NO;
}


#pragma mark - UIViewController override

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender  {
	if ([[segue identifier] isEqualToString:@"showDetail"]) {
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		MBFactualRestaurant *restaurant = self.restaurants[indexPath.row];
		[[segue destinationViewController] setRestaurant:restaurant];
	}
}


#pragma mark - UITextViewDelegate methods

// Run a search when the user press the "Search" key on the keyboard from within either of the two text fields.
- (BOOL)textFieldShouldReturn:(UITextField *)textField  {
	
	[textField resignFirstResponder];
	[self performFactualRestaurantSearch];
	
	return YES;
}


#pragma mark - CLLocationManagerDelegate methods

// When the location updates, cache it and fill in the City, ST text field with geocoded info from the current location.
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations  {
	NSLog(@"XXX Updating location…");
	self.location = (CLLocation *)locations[locations.count - 1];
	CLGeocoder *geocoder = [[CLGeocoder alloc] init];
	[geocoder reverseGeocodeLocation:self.location completionHandler:^(NSArray *placemarks, NSError *error){
		if (placemarks.count > 0 && !error) {
			self.cachedPlacemark = placemarks[0];
			self.cityStateTextField.text = [NSString stringWithFormat:@"%@, %@", self.cachedPlacemark.locality, self.cachedPlacemark.administrativeArea];
			self.cityStateTextField.textColor = [UIColor blueColor];
		} else if (error)  {
			NSLog(@"Failed to get location geocoding information. Error was: \n%@", error);
		}
	}];
}

// If the user turns off Location Services, stop trying to update location, clear any location info we have cached
// and show an alert pointing them to Settings.app to turn it back on.
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error  {
	if (error.code == kCLErrorDenied) {
		[self.locationManager stopMonitoringSignificantLocationChanges];
		self.cachedPlacemark = nil;
		self.location = nil;
		self.locationButton.selected = NO;
		self.cityStateTextField.textColor = [UIColor darkTextColor];

		UIAlertView *locDeniedAlert = [[UIAlertView alloc] initWithTitle:@"Location Services disabled"
																														 message:@"To allow access to your location, go to Settings > Privacy > Location."
																														delegate:nil
																									 cancelButtonTitle:@"Dismiss"
																									 otherButtonTitles:nil];
		[locDeniedAlert show];
	}
}


@end
