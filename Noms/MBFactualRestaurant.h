//
//  MBFactualRestaurant.h
//  Noms
//
//  Created by Michael Bailey on 2012-10-14.
//  Copyright (c) 2012 Michael Bailey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBFactualRestaurant : NSObject

@property (strong, nonatomic) NSMutableArray *cuisine;
@property (nonatomic, assign) NSInteger price;
@property (strong, nonatomic) NSNumber *rating;
@property (strong, nonatomic) NSMutableDictionary *hours;

@property (nonatomic, assign) BOOL servesBreakfast;
@property (nonatomic, assign) BOOL servesLunch;
@property (nonatomic, assign) BOOL servesDinner;

@end
