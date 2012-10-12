//
//  NXInstapaperActivity.m
//  NXActivities
//
//  Created by Thomas Kollbach on 12.10.12.
//  Copyright (c) 2012 nxtbgthng. All rights reserved.
//

#import <Security/Security.h>

#import "NSBundle+NXActivities.h"
#import "NXInstapaperLoginViewController.h"

#import "NXInstapaperActivity.h"

NSString * const NXInstapaperAccountUsernameDefaultsKey = @"NXInstapaperAccountUsername";
NSString * const NXInstapaperKeychainServiceIdentifier = @"NXInstapaperKeychainServiceIdentifier";

@interface NXInstapaperActivity ()

@property (nonatomic, strong, readwrite) NSArray *activityItems;

@end


@implementation NXInstapaperActivity

#pragma mark Class Methods

+ (NSString *)username;
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:NXInstapaperAccountUsernameDefaultsKey];
}

+ (NSString *)password;
{
    if ([self username] == nil ||
        [[self username] isEqualToString:@""])
    {
        return nil;
    }
    
    NSDictionary *result = nil;
    NSDictionary *query = @{ (__bridge NSString *)kSecClass: (__bridge NSString *)kSecClassGenericPassword,
                             (__bridge NSString *)kSecAttrService: NXInstapaperKeychainServiceIdentifier,
                             (__bridge NSString *)kSecAttrAccount: [self username],
                             (__bridge NSString *)kSecReturnAttributes: (__bridge NSNumber *)kCFBooleanTrue  };
    

    CFTypeRef cfResult = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &cfResult);
    result = (__bridge_transfer NSDictionary *)cfResult;
    
    if (status != noErr) {
        NSAssert1(status == errSecItemNotFound, @"unexpected error while fetching token from keychain: %ld", status);
        return nil;
    }
    
    NSData *passwordData = [result objectForKey:(__bridge NSString *)kSecAttrGeneric];
    NSString *password = [[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding];
    
    return password;
}

+ (BOOL)storeAccountWithUsername:(NSString *)username password:(NSString *)password;
{
    NSParameterAssert(username);
    NSParameterAssert(password);
    
    NSData *data = [password dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *query = @{ (__bridge NSString *)kSecClass: (__bridge NSString *)kSecClassGenericPassword,
                             (__bridge NSString *)kSecAttrService: NXInstapaperKeychainServiceIdentifier,
                             (__bridge NSString *)kSecAttrLabel: @"Instapaper",
                             (__bridge NSString *)kSecAttrAccount: username,
                             (__bridge NSString *)kSecAttrGeneric: data };
    
    [self removeAccount];
    
    OSStatus err = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
    NSAssert1(err == noErr, @"error while adding token to keychain: %ld", err);
    
    BOOL result = (err == noErr);
    
    if (result) {
        [[NSUserDefaults standardUserDefaults] setObject:username
                                                  forKey:NXInstapaperAccountUsernameDefaultsKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return result;
}

+ (BOOL)removeAccount;
{
    NSDictionary *query = @{ (__bridge NSString *)kSecClass: (__bridge NSString *)kSecClassGenericPassword,
                             (__bridge NSString *)kSecAttrService: NXInstapaperKeychainServiceIdentifier,
                             (__bridge NSString *)kSecAttrLabel: @"Instapaper" };
    
    OSStatus err = SecItemDelete((__bridge CFDictionaryRef)query);
    
    BOOL result = (err == noErr || err == errSecItemNotFound);
    
    NSAssert1(result, @"error while deleting token from keychain: %ld", err);
    
    if (result) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:NXInstapaperAccountUsernameDefaultsKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return result;
}

#pragma mark UIActivity

- (NSString *)activityType;
{
    return @"NXInstapaper";
}

- (NSString *)activityTitle;
{
    return @"Instapaper";
}

- (UIImage *)activityImage;
{
    NSBundle *bundle  = [NSBundle nxactivitiesBundle];
    
    NSString *resoutionMultiplier = @"";
    if ([[UIScreen mainScreen] scale] == 2.0) {
        resoutionMultiplier = @"@2x";
    }
    
    NSString *imageName;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        imageName = [NSString stringWithFormat:@"InstapaperActivity-ipad%@", resoutionMultiplier];
    } else {
        imageName = [NSString stringWithFormat:@"InstapaperActivity-iphone%@", resoutionMultiplier];
    }

    NSString *path = [bundle pathForResource:imageName ofType:@"png"];

    return [UIImage imageWithContentsOfFile:path];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems;
{
    BOOL canPerform = YES;
    
    for (id activityItem in activityItems) {
        if (![activityItem isKindOfClass:[NSURL class]]) {
            canPerform = NO;
        }
    }
    
    return canPerform;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems;
{
    self.activityItems = activityItems;
}

- (UIViewController * )activityViewController;
{
    NXInstapaperLoginViewController *loginController  = [[NXInstapaperLoginViewController alloc] initWithResultHandler:^(NXInstapaperLoginViewController *controller, BOOL success) {
        if (success) {
            [self performActivity];
        } else {
            [self activityDidFinish:NO];
        }
    }];
    return [[UINavigationController alloc] initWithRootViewController:loginController];
}

- (void)performActivity;
{
    NSString *username = [[self class] username];
    NSString *password = [[self class] password];
    
    if (username) {
        for (NSURL *shareURL in self.activityItems) {
            NSString *urlString = [NSString stringWithFormat:@"https://www.instapaper.com/api/add?username=%@&password=%@&url=%@",
                                   [username stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                   [password stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                   [shareURL.absoluteString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
            
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                       BOOL success = NO;
                                       
                                       [self activityDidFinish:success withItem:shareURL];
                                   }];
        }
        
    
    } else {
        [self activityDidFinish:NO];
    }
}

- (void)activityDidFinish:(BOOL)completed withItem:(id)item;
{
    @synchronized(self.activityItems) {
        NSMutableArray *items = [self.activityItems mutableCopy];
        [items removeObject:item];
        self.activityItems = [items copy];
    }
    
    if (self.activityItems.count == 0) {
        [self activityDidFinish:completed];
    }
}

@end
