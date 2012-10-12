//
//  NXInstapaperActivity.h
//  NXActivities
//
//  Created by Thomas Kollbach on 12.10.12.
//  Copyright (c) 2012 nxtbgthng. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const NXInstapaperAccountUsernameDefaultsKey;
extern NSString * const NXInstapaperKeychainServiceIdentifier;


@interface NXInstapaperActivity : UIActivity

+ (NSString *)username;
+ (NSString *)password;

+ (BOOL)storeAccountWithUsername:(NSString *)username password:(NSString *)password;
+ (BOOL)removeAccount;

@end
