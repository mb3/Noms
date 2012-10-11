//
//  MBDetailViewController.h
//  Noms
//
//  Created by Michael Bailey on 2012-10-10.
//  Copyright (c) 2012 Michael Bailey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
