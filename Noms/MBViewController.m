//
//  MBViewController.m
//  Noms
//
//  Created by Michael Bailey on 2012-10-14.
//  Copyright (c) 2012 Michael Bailey. All rights reserved.
//

#import "MBViewController.h"

#define OAUTH_KEY @"EsClMNOcpTnieYueu5igO44aUSX5kpPzFh0O4kId"

@interface MBViewController ()  {
	NSMutableArray *restaurants;
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
	NSString *locality, *region;
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
				locality = [NSString stringWithFormat:@"%@ %@", locality, locationComponents[i]];
				NSLog(@"Locality is now %@", locality);
			}
		}
	}	
	
	NSString *requestString = [NSString stringWithFormat:@"http://api.v3.factual.com/t/restaurants-us?q=%@&filters={\"region\":\"%@\",\"locality\":\"%@\"}&KEY=%@", self.searchTermsTextField.text, region, locality, OAUTH_KEY];
	NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:requestString]];
	
	
	/* http://blogs.captechconsulting.com/blog/nathan-jones/getting-started-json-ios5 */
	
	// Need to handle being offline here as well
	/*
	NSInputStream *jsonStream = [[NSInputStream alloc] initWithData:jsonData];
	[jsonStream open];
	
	if (jsonStream) {
		NSError *parseError = nil;
		id jsonObject = [NSJSONSerialization JSONObjectWithStream:jsonStream options:NSJSONReadingAllowFragments error:&parseError];
		if ([jsonObject respondsToSelector:@selector(objectForKey:)]) {
			for (NSDictionary *restaurant in [jsonObject objectForKey:@"results"]) {
				NSLog(@"Result: %@", [restaurant objectForKey:@"text"]);
			}
		} else  {
			NSLog(@"Failed to open stream.");
		}
	}
	*/
	
	NSLog(@"Request string was: %@", requestString);
	NSLog(@"Got some data: %@", jsonData);
	
	//NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestString]];

}

#pragma mark - UITableViewDelegate methods


#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView  {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  {
	return restaurants.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	
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


#pragma mark - UITextViewDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField  {
	
	[textField resignFirstResponder];
	[self performFactualRestaurantSearch];
	
	return YES;
}


@end
