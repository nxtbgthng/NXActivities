//
//  NSBundle+NXActivities.m
//  NXActivities
//
//  Created by Thomas Kollbach on 12.10.12.
//  Copyright (c) 2012 nxtbgthng. All rights reserved.
//

#import "NSBundle+NXActivities.h"

@implementation NSBundle (NXActivities)

+ (NSBundle *)nxactivitiesBundle;
{
	NSBundle *resourceBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"NXActivities" ofType:@"bundle"]];
	NSAssert(resourceBundle, @"Please move the NXActivities.bundle into the resource directory of your application!");
	return resourceBundle;
}

@end
