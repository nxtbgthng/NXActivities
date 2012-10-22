//
//  NXReadLaterActivity.h
//  NXActivities
//
//  Created by Thomas Kollbach on 16.10.12.
//  Copyright (c) 2012 nxtbgthng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NXReadLaterLoginViewController;


@interface NXReadLaterActivity : UIActivity

+ (NSString *)username;
+ (NSString *)password;

+ (BOOL)hasAccount;
+ (BOOL)storeAccountWithUsername:(NSString *)username password:(NSString *)password;
+ (BOOL)removeAccount;

// This view controller is shown, if login is required.
// The controller shown is in a UINaviationController
@property (nonatomic, strong, readonly) NXReadLaterLoginViewController *loginController;

// Subclasses have to override the following methods
+ (NSString *)serviceIdentifier;
- (NSURLRequest *)loginRequestWithUsername:(NSString *)username password:(NSString *)password;
- (NSURLRequest *)readLaterRequest:(NSURL *)shareURL;



@end
