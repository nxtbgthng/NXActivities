//
//  NXPocketActivity.h
//  NXActivities
//
//  Created by Thomas Kollbach on 16.10.12.
//  Copyright (c) 2012 nxtbgthng. All rights reserved.
//

#import "NXReadLaterActivity.h"

extern NSString * const NXPocketServiceIdentifier;

@interface NXPocketActivity : NXReadLaterActivity

+ (void)setPocketAPIKey:(NSString *)apiKey;
+ (NSString *)pocketAPIKey;

@end
