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
	
	self.navItem.title = self.restaurant.name;
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Instance methods

- (void)setDetailItem:(id)detailItem  {
	
}

- (void)configureView  {
	
}

@end
