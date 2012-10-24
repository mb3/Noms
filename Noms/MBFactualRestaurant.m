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
		
		// Factual returns hours as another JSON object, so parse it if it exists
		if ([dictionary objectForKey:@"hours"]) {
			NSError *parseError;
			self.hours = [NSJSONSerialization JSONObjectWithData:[[dictionary objectForKey:@"hours"] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&parseError];
			if (parseError) {
				NSLog(@"XXX Error parsing hours JSON: %@", parseError);
			}
		}
		
		NSString *combinedAddress = [NSString stringWithFormat:@"%@\n%@, %@ %@", [dictionary objectForKey:@"address"], [dictionary objectForKey:@"locality"], [dictionary objectForKey:@"region"], [dictionary objectForKey:@"postcode"]];
		[self setAddress:combinedAddress];
		
		[self setTelephone:[dictionary objectForKey:@"tel"]];
		[self setWebsite:[dictionary objectForKey:@"website"]];
	}
	return self;
}

+ (id)restaurantFromFactualDictionary:(NSDictionary *)dictionary  {
	return [[MBFactualRestaurant alloc] initFromFactualDictionary:dictionary];
}

@end
