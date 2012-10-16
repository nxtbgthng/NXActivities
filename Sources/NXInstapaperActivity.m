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
    NSString *username = [[self class] username];
    NSString *password = [[self class] password];
    username = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)username, NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), kCFStringEncodingUTF8);
    password = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)password, NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), kCFStringEncodingUTF8);
    NSString *encodedURL = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)shareURL.absoluteString, NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), kCFStringEncodingUTF8);    
    
    NSString *urlString = [NSString stringWithFormat:@"https://www.instapaper.com/api/add?username=%@&password=%@&url=%@",
                                                     username, password, encodedURL];
    
    return [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
}

- (NSURLRequest *)loginRequestWithUsername:(NSString *)username password:(NSString *)password;
{
    username = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)username, NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), kCFStringEncodingUTF8);
    password = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)password, NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), kCFStringEncodingUTF8);
    
    NSString *urlString = [NSString stringWithFormat:@"https://www.instapaper.com/api/authenticate?username=%@&password=%@", username, password];
    return [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
}

@end