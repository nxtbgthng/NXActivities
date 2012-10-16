//
//  NXPocketActivity.m
//  NXActivities
//
//  Created by Thomas Kollbach on 16.10.12.
//  Copyright (c) 2012 nxtbgthng. All rights reserved.
//

#import "NXPocketActivity.h"

static NSString * pocketAPIKey;

NSString * const NXPocketServiceIdentifier = @"Pocket";

@implementation NXPocketActivity

#pragma mark Class methods

+ (NSString *)serviceIdentifier;
{
    return NXPocketServiceIdentifier;
}

+ (void)setPocketAPIKey:(NSString *)apiKey;
{
    pocketAPIKey = [apiKey copy];
}

+ (NSString *)pocketAPIKey;
{
    NSAssert(pocketAPIKey != nil, @"The Pocket API Key is not set. Please set it before using the NXPocketActivity with +[NXPocketActivity setPocketAPIKey:]");
    
    return pocketAPIKey;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems;
{
    if ([[self class] pocketAPIKey] == nil) {
        // this ensures the activity will not show up, if the assert above is disabled.
        return NO;
    }
    
    return [super canPerformWithActivityItems:activityItems];
}


#pragma mark UIActivity

- (NSString *)activityTitle;
{
    return @"Pocket";
}

- (NSURLRequest *)readLaterRequest:(NSURL *)shareURL;
{
    NSString *username = [[self class] username];
    NSString *password = [[self class] password];
    username = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)username, NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), kCFStringEncodingUTF8);
    password = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)password, NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), kCFStringEncodingUTF8);
    NSString *encodedURL = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)shareURL.absoluteString, NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), kCFStringEncodingUTF8);
    
    NSString *urlString = [NSString stringWithFormat:@"https://readitlaterlist.com/v2/add?username=%@&password=%@&url=%@&apikey=%@",
                           username, password, encodedURL, [[self class] pocketAPIKey]];
    return [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
}

- (NSURLRequest *)loginRequestWithUsername:(NSString *)username password:(NSString *)password;
{
    username = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)username, NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), kCFStringEncodingUTF8);
    password = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)password, NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), kCFStringEncodingUTF8);
    
    NSString *urlString = [NSString stringWithFormat:@"https://readitlaterlist.com/v2/auth?username=%@&password=%@&apikey=%@",
                           username, password, [[self class] pocketAPIKey]];
    return [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
}

@end
