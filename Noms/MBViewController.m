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

static NSString *kOAuthKey = @"EsClMNOcpTnieYueu5igO44aUSX5kpPzFh0O4kId";

@interface MBViewController () {
}

@end

@implementation MBViewController

//@synthesize cityStateTextField;

- (void)viewDidLoad  {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
}

- (void)didReceiveMemoryWarning  {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Instance methods

- (void)performFactualRestaurantSearch  {
	
	NSLog(@"Got some text, %@ and %@", self.cityStateTextField.text, self.searchTermsTextField.text);
	
	// String processing for city, state location. First, try comma separators...
	NSMutableString *locality = [NSMutableString stringWithFormat:@""];
	NSString *region = @"";
	NSArray *locationComponents = [self.cityStateTextField.text componentsSeparatedByString:@", "];
	// ...if there aren't any, try spaces...
	if (locationComponents.count < 2) {
		locationComponents = [self.cityStateTextField.text componentsSeparatedByString:@" "];
		// ...if still not, just send the single string as "locality"...
		if (locationComponents.count < 2) {
			locality = locationComponents[0];
		} else if (locationComponents.count > 2) {  // ...otherwise, check for multiple spaces (multiple-word cities)...
			region = locationComponents[locationComponents.count - 1];  // ...last string component from the end is the "region". This will not pick up multi-word states ("New Mexico") properly...
			//locality = [locality mutableCopy];
			for (int i=0; i < locationComponents.count - 1; i++) {
				[locality appendFormat:@"%@ %@", locality, locationComponents[i]];
				NSLog(@"Locality is now %@", locality);
			}
		}
	} else {
		locality = locationComponents[0];
		region = locationComponents[1];
	}
	
	NSLog(@"Locality = %@, Region = %@", locality, region);
	
	// Construct the query URL. This all needs to be properly percent-escaped or NSURL won't take it, hence the multiple parts.
	
	NSString *requestURLPrefix  = @"http://api.v3.factual.com/t/restaurants-us?";
	NSString *requestURLQuery   = [NSString stringWithFormat:@"q=%@", self.searchTermsTextField.text];
	NSString *requestURLFilters = [NSString stringWithFormat:@"filters={\"region\":\"%@\",\"locality\":\"%@\"}", region, locality];
	
	//NSString *requestString = [NSString stringWithFormat:@"http://api.v3.factual.com/t/restaurants-us?q=%@&filters={\"region\":\"%@\",\"locality\":\"%@\"}&KEY=%@", self.searchTermsTextField.text, region, locality, kOAuthKey];
	CFStringRef requestURLQueryEncoded = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
																																						   (__bridge CFStringRef)(requestURLQuery),
																																							 NULL,
																																						   CFSTR(":/?#[]@!$&'()*+.,;="),
																																						   kCFStringEncodingUTF8);
	CFStringRef requestURLFiltersEncoded = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
																																								 (__bridge CFStringRef)(requestURLFilters),
																																								 NULL,
																																								 CFSTR(":/?#[]@!$&'()*+.,;="),
																																								 kCFStringEncodingUTF8);
	NSString *requestStringEncoded = [NSString stringWithFormat:@"%@%@&%@&KEY=%@", requestURLPrefix, (__bridge NSString *)(requestURLQueryEncoded), (__bridge NSString *)(requestURLFiltersEncoded), kOAuthKey];
	
	//NSString *requestString = [NSString stringWithFormat:@"http://api.v3.factual.com/t/restaurants-us?q=%@&filters=%%7B%%22region%%22%%3A%%22%@%%22%%2C%%22locality%%22%%3A%%22%@%%22%%7D&KEY=%@", self.searchTermsTextField.text, region, locality, kOAuthKey];
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestStringEncoded]];
	self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
	
	self.jsonData = [NSMutableData data];
	
	NSLog(@"Request string was: %@", requestStringEncoded);
	//NSLog(@"Got some data: %@", jsonData);
}

- (void)parseJSON  {
	NSError *parseError = nil;
	NSDictionary *factualResponse = [NSJSONSerialization JSONObjectWithData:self.jsonData options:0 error:&parseError];
	NSLog(@"JSON -> NSDictionary: %@", factualResponse);
	
	if (!parseError) {
		self.restaurants = [[NSMutableArray alloc] initWithCapacity:20];
		
		for (NSDictionary *dict in [[factualResponse objectForKey:@"response"] objectForKey:@"data"]) {
			MBFactualRestaurant *restaurant = [MBFactualRestaurant restaurantFromFactualDictionary:dict];
			[self.restaurants addObject:restaurant];
			NSLog(@"Just added %@", restaurant.name);
		}
	}
	
	[self.tableView reloadData];
}

#pragma mark - NSURLConnectionDelegate methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error  {
	// XXX handle offline internets here
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Failed"
																									message:[NSString stringWithFormat:@"The error was:\n%@", error]
																								 delegate:nil
																				cancelButtonTitle:@"Dismiss"
																				otherButtonTitles:nil];
	[alert show];
}

#pragma mark - NSURLConnectionDataDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data  {
	[self.jsonData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection  {
	//NSLog(@"I has a JSON: %@", self.jsonData);
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

// This is not a reorderable table
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath  {
	return NO;
}

#pragma mark - UITableViewDelegate methods

/*
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
	MBDetailViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"detailViewController"];
}
*/
#pragma mark - UIViewController override

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender  {
	if ([[segue identifier] isEqualToString:@"showDetail"]) {
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		MBFactualRestaurant *restaurant = self.restaurants[indexPath.row];
		[[segue destinationViewController] setRestaurant:restaurant];
	}
}

#pragma mark - UITextViewDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField  {
	
	[textField resignFirstResponder];
	[self performFactualRestaurantSearch];
	
	return YES;
}


@end
