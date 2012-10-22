//
//  MBDetailViewController.m
//  Noms
//
//  Created by Michael Bailey on 2012-10-14.
//  Copyright (c) 2012 Michael Bailey. All rights reserved.
//

#import "MBDetailViewController.h"
#import "MBFactualRestaurant.h"

#define WIDTH       280  // Most controls will be 280 pt wide
#define PADDING       7  // 7 pt vertical padding is what IB seems to use between most controls
#define LEFT_MARGIN  20  // Put all controls at a 20 pt indent from the left margin

@interface MBDetailViewController ()

@property (nonatomic, assign) CGFloat totalHeight;

- (void)configureView;

@end

@implementation MBDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
	// Use the header's height to start calculating the total height for the scroll view
	self.totalHeight = self.headerView.frame.origin.y + self.headerView.frame.size.height;
	
	if (self.restaurant.hours) {		
		NSMutableString *hoursText = [[NSMutableString alloc] init];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		NSArray *dayNames = @[@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday"];
		for (int i = 0; i < dayNames.count; i++) {
			// Factual's days are 1-indexed, hence the i+1
			if ([self.restaurant.hours objectForKey:[NSString stringWithFormat:@"%d", i+1]]) {
				[hoursText appendFormat:@"%@:\n", dayNames[i]];
				
				for (NSArray *hourArray	in [self.restaurant.hours objectForKey:[NSString stringWithFormat:@"%d", i+1]]) {
					NSDate *date1 = [dateFormatter dateFromString:hourArray[0]];
					NSDate *date2 = [dateFormatter dateFromString:hourArray[1]];
					[hoursText appendFormat:@"%@ – %@", [dateFormatter stringFromDate:date1], [dateFormatter stringFromDate:date2]];
					if (hourArray.count > 2) {
						[hoursText appendFormat:@" — %@", hourArray[2]];  // Some hours have a label like "Lunch" or "Dinner"
					}
					[hoursText appendFormat:@"\n"];
				}
			}
		}
		
		UILabel *hoursLabel = [[UILabel alloc] init];
		hoursLabel.backgroundColor = [UIColor clearColor];
		hoursLabel.text = [NSString stringWithFormat:@"Hours:\n%@", hoursText];
		hoursLabel.numberOfLines = 0;
		
		// Size the label to fit based on the size of the text, then conform to the size of the scroll view
		[hoursLabel sizeToFit];
		CGRect frame = hoursLabel.frame;
		frame.origin = CGPointMake(LEFT_MARGIN, self.totalHeight + PADDING);
		frame.size = CGSizeMake(WIDTH, hoursLabel.frame.size.height);
		hoursLabel.frame = frame;
		
		hoursLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		[self.scrollView addSubview:hoursLabel];
		self.totalHeight += PADDING;
		self.totalHeight += frame.size.height;
	}
	
	if (self.restaurant.website)  {
		UIButton *websiteButton = [self buttonWithTitle:self.restaurant.website];
		[websiteButton addTarget:self action:@selector(openWebsite) forControlEvents:UIControlEventTouchUpInside];
		[self.scrollView addSubview:websiteButton];
	}
	
	if (self.restaurant.telephone)  {
		UIButton *phoneButton = [self buttonWithTitle:self.restaurant.telephone];
		[phoneButton addTarget:self action:@selector(dialPhoneNumber) forControlEvents:UIControlEventTouchUpInside];
		[self.scrollView addSubview:phoneButton];
	}
	
	if (self.restaurant.address)  {
		UIButton *addressButton = [self buttonWithTitle:self.restaurant.address];
		[addressButton addTarget:self action:@selector(openMap) forControlEvents:UIControlEventTouchUpInside];
		[self.scrollView addSubview:addressButton];
	}
		
	self.nameLabel.text = self.restaurant.name;
	self.cuisineLabel.text = self.restaurant.cuisine;
	
	[self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, (self.totalHeight + PADDING))];
	
	//NSLog(@"XXX scrollView contentSize: (%f, %f)", self.scrollView.contentSize.width, self.scrollView.contentSize.height);
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Instance methods

- (UIButton *)buttonWithTitle:(NSString *)string  {
	// Make a default set of insets for padding the buttons
	UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
	
	UIButton *newButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	newButton.titleLabel.numberOfLines = 0;
	newButton.contentEdgeInsets = insets;
	[newButton setTitle:string forState:UIControlStateNormal];
	
	// Size the button to fit based on the size of the label, then conform to the size of the scroll view
	[newButton sizeToFit];
	CGRect frame = newButton.frame;
	frame.origin = CGPointMake(LEFT_MARGIN, self.totalHeight + PADDING);
	frame.size = CGSizeMake(WIDTH, newButton.frame.size.height);
	newButton.frame = frame;
	
	newButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	// Add the height of the new button to the total height for the next item  and the scroll view
	self.totalHeight += PADDING;
	self.totalHeight += frame.size.height;
	
	return newButton;	
}

- (void)dialPhoneNumber  {
	NSString *telStringConverted = [self.restaurant.telephone stringByReplacingOccurrencesOfString:@"(" withString:@""];
	telStringConverted = [telStringConverted stringByReplacingOccurrencesOfString:@")" withString:@""];
	telStringConverted = [telStringConverted stringByReplacingOccurrencesOfString:@" " withString:@"-"];
	
	//NSLog(@"XXX Phone URL = tel:1-%@", telStringConverted);
	
	NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:1-%@", telStringConverted]];
	if (![[UIApplication sharedApplication] openURL:phoneURL]) {
		NSLog(@"XXX Couldn't dial phone. Possibly just because the simulator doesn't support it.");
	}
}

- (void)openWebsite  {
	NSURL *websiteURL = [NSURL URLWithString:self.restaurant.website];
	if(![[UIApplication sharedApplication] openURL:websiteURL])  {
		NSLog(@"XXX Couldn't open website URL for whatever reason.");
	}
}

- (void)openMap  {
	NSString *addressQuery = [self.restaurant.address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSURL *mapsURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/maps?q=%@", addressQuery]];
	if(![[UIApplication sharedApplication] openURL:mapsURL])  {
		NSLog(@"XXX Couldn't open maps URL for whatever reason.");
	}
}

- (void)configureView  {
	
}

@end
