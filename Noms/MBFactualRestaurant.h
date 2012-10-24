//
//  MBFactualRestaurant.h
//  Noms
//
//  Created by Michael Bailey on 2012-10-14.
//  Copyright (c) 2012 Michael Bailey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBFactualRestaurant : NSObject

// The restaurant's name.
@property (nonatomic, copy) NSString *name;
// The cuisine offered by the restaurant.
@property (nonatomic, copy) NSString *cuisine;

// The restaurant's hours of operation.
// Factual provides this information as a JSON object, which is converted to to a dictionary. It is keyed by day numbers
// 1-7, starting on Monday. The values are an array of "groups" of hours (for, e.g. separate lunch and dinner hours), which
// are then represented as an array of two strings, representing opening and closing times, and optionally a third string,
// representing a label for the hour group ("Dinner", "Happy Hour", and so on).
@property (strong, nonatomic) NSDictionary *hours;

// The restaurant's street address. This is a concatenation of Factual's "address", "locality", "region", and "postcode"
// keys.
@property (nonatomic, copy) NSString *address;

// The restaurant's telephone number (stored as (999) 999-9999) and website.
@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, copy) NSString *website;

// Factory method and constructor for creating a restaurant object from an NSDictionary representing the raw data from
// Factual's JSON.
+ (id)restaurantFromFactualDictionary:(NSDictionary *)dictionary;
- (id)initFromFactualDictionary:(NSDictionary *)dictionary;

@end
