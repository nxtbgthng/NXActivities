//
//  NXReadLaterActivity.h
//  NXActivities
//
//  Created by Thomas Kollbach on 16.10.12.
//  Copyright (c) 2012 nxtbgthng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NXReadLaterActivity : UIActivity

+ (NSString *)username;
+ (NSString *)password;

+ (BOOL)hasAccount;
+ (BOOL)storeAccountWithUsername:(NSString *)username password:(NSString *)password;
+ (BOOL)removeAccount;

// Subclasses have to override the following merhods
+ (NSString *)serviceIdentifier;
- (NSURLRequest *)loginRequestWithUsername:(NSString *)username password:(NSString *)password;
- (NSURLRequest *)readLaterRequest:(NSURL *)shareURL;


@end
