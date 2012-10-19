//
//  MBDetailViewController.m
//  Noms
//
//  Created by Michael Bailey on 2012-10-14.
//  Copyright (c) 2012 Michael Bailey. All rights reserved.
//

#import "MBDetailViewController.h"
#import "MBFactualRestaurant.h"

@interface MBDetailViewController ()
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
	
	//self.navItem.title = self.restaurant.name;
	
	self.nameLabel.text = self.restaurant.name;
	self.cuisineLabel.text = self.restaurant.cuisine;
	
	// UIControlStateNormal = 0, UIControlStateDisabled = 1 << 0, so can't bitwise or the normal state with disabled.
	[self.websiteButton setTitle:self.restaurant.website forState:UIControlStateNormal];
	[self.websiteButton setTitle:self.restaurant.website forState:(UIControlStateDisabled | UIControlStateHighlighted)];
	[self.phoneNumberButton setTitle:self.restaurant.telephone forState:UIControlStateNormal];
	[self.phoneNumberButton setTitle:self.restaurant.telephone forState:(UIControlStateDisabled | UIControlStateHighlighted)];
	[self.addressButton setTitle:self.restaurant.address forState:UIControlStateNormal];
	[self.addressButton setTitle:self.restaurant.address forState:(UIControlStateDisabled | UIControlStateHighlighted)];

	NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.restaurant.telephone]];
	//[self.phoneNumberButton sendAction:@selector(dialPhoneNumber) to:self forEvent:]
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Instance methods

- (void)dialPhoneNumber  {
	
}

- (void)configureView  {
	
}

@end
