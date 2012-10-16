//
//  NXInstapaperActivity.m
//  NXActivities
//
//  Created by Thomas Kollbach on 12.10.12.
//  Copyright (c) 2012 nxtbgthng. All rights reserved.
//

#import <Security/Security.h>
#import <QuartzCore/QuartzCore.h>

#import "NSBundle+NXActivities.h"
#import "NXReadLaterLoginViewController.h"
#import "MBProgressHUD.h"

#import "NXInstapaperActivity.h"

NSString * const NXInstapaperServiceIdentifier = @"Instapaper";

@interface NXInstapaperActivity ()



@end


@implementation NXInstapaperActivity

#pragma mark Class methods

+ (NSString *)serviceIdentifier;
{
    return NXInstapaperServiceIdentifier;
}

#pragma mark UIActivity

- (NSString *)activityTitle;
{
    return @"Instapaper";
}

- (NSURLRequest *)readLaterRequest:(NSURL *)shareURL;
{
    NSString *urlString = [NSString stringWithFormat:@"https://www.instapaper.com/api/add?username=%@&password=%@&url=%@",
                           [[[self class] username] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           [[[self class] password] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           [shareURL.absoluteString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    return [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
}

- (NSURLRequest *)loginRequestWithUsername:(NSString *)username password:(NSString *)password;
{
    NSString *urlString = [NSString stringWithFormat:@"https://www.instapaper.com/api/authenticate?username=%@&password=%@",
                           [username stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           [password stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
}

@end