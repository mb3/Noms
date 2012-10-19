//
//  MBFactualRestaurant.m
//  Noms
//
//  Created by Michael Bailey on 2012-10-14.
//  Copyright (c) 2012 Michael Bailey. All rights reserved.
//

#import "MBFactualRestaurant.h"

@implementation MBFactualRestaurant

#pragma mark - Initializer

- (id)init  {
	return [self initFromFactualDictionary:nil];
}

- (id)initFromFactualDictionary:(NSDictionary *)dictionary  {
	if (self = [super init]) {
		[self setName:[dictionary objectForKey:@"name"]];
		
		[self setCuisine:[dictionary objectForKey:@"cuisine"]];
		[self setPrice:[[dictionary objectForKey:@"price"] intValue]];
		[self setRating:[dictionary objectForKey:@"rating"]];
		
		[self setServesBreakfast:[[dictionary objectForKey:@"meal_breakfast"] boolValue]];
		[self setServesLunch:[[dictionary objectForKey:@"meal_lunch"] boolValue]];
		[self setServesDinner:[[dictionary objectForKey:@"meal_dinner"] boolValue]];
		
		NSString *combinedAddress = [NSString stringWithFormat:@"%@\n%@, %@ %@", [dictionary objectForKey:@"address"], [dictionary objectForKey:@"locality"], [dictionary objectForKey:@"region"], [dictionary objectForKey:@"postcode"]];
		[self setAddress:combinedAddress];
		
		[self setTelephone:[dictionary objectForKey:@"tel"]];
		[self setWebsite:[dictionary objectForKey:@"website"]];
		
		return self;
	} else return nil;
}

+ (id)restaurantFromFactualDictionary:(NSDictionary *)dictionary  {
	return [[MBFactualRestaurant alloc] initFromFactualDictionary:dictionary];
}

@end
