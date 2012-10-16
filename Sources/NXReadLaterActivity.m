//
//  NXReadLaterActivity.m
//  NXActivities
//
//  Created by Thomas Kollbach on 16.10.12.
//  Copyright (c) 2012 nxtbgthng. All rights reserved.
//

#import "MBProgressHUD.h"

#import "NSBundle+NXActivities.h"

#import "NXReadLaterActivity.h"

@interface NXReadLaterActivity ()

+ (NSString *)usernameForServiceIdentifier:(NSString *)serviceIdentifier;
+ (NSString *)passwordForServiceIdentifier:(NSString *)serviceIdentifier;
+ (BOOL)storeUsername:(NSString *)username password:(NSString *)password forServiceIdentifier:(NSString *)serviceIdentifier;
+ (BOOL)removeAccountForServiceIdentifier:(NSString *)serviceIdentifier;

@property (nonatomic, strong, readwrite) NSArray *activityItems;

@end

@implementation NXReadLaterActivity

#pragma mark Class Methods

+ (NSString *)identifierForServiceIdentifier:(NSString *)serviceIdentifier;
{
    return [NSString stringWithFormat:@"NXActivity-%@", serviceIdentifier];
}

+ (NSString *)usernameForServiceIdentifier:(NSString *)serviceIdentifier;
{
    NSParameterAssert(serviceIdentifier);
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:[self identifierForServiceIdentifier:serviceIdentifier]];
}

+ (NSString *)passwordForServiceIdentifier:(NSString *)serviceIdentifier;
{
    NSParameterAssert(serviceIdentifier);
    
    if ([self usernameForServiceIdentifier:serviceIdentifier] == nil ||
        [[self usernameForServiceIdentifier:serviceIdentifier] isEqualToString:@""])
    {
        return nil;
    }
    
    NSString *identifier = [self identifierForServiceIdentifier:serviceIdentifier];
    
    NSDictionary *result = nil;
    NSDictionary *query = @{ (__bridge NSString *)kSecClass: (__bridge NSString *)kSecClassGenericPassword,
    (__bridge NSString *)kSecAttrService: identifier,
    (__bridge NSString *)kSecAttrAccount: [self usernameForServiceIdentifier:serviceIdentifier],
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

+ (BOOL)storeUsername:(NSString *)username password:(NSString *)password forServiceIdentifier:(NSString *)serviceIdentifier;
{
    NSParameterAssert(username);
    NSParameterAssert(password);
    NSParameterAssert(serviceIdentifier);
    
    NSString *identifier = [self identifierForServiceIdentifier:serviceIdentifier];
    
    NSData *data = [password dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *query = @{ (__bridge NSString *)kSecClass: (__bridge NSString *)kSecClassGenericPassword,
    (__bridge NSString *)kSecAttrService: identifier,
    (__bridge NSString *)kSecAttrLabel: serviceIdentifier,
    (__bridge NSString *)kSecAttrAccount: username,
    (__bridge NSString *)kSecAttrGeneric: data };
    
    [self removeAccount];
    
    OSStatus err = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
    NSAssert1(err == noErr, @"error while adding token to keychain: %ld", err);
    
    BOOL result = (err == noErr);
    
    if (result) {
        [[NSUserDefaults standardUserDefaults] setObject:username
                                                  forKey:identifier];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return result;
}

+ (BOOL)removeAccountForServiceIdentifier:(NSString *)serviceIdentifier;
{
    NSParameterAssert(serviceIdentifier);
    
    NSString *identifier = [self identifierForServiceIdentifier:serviceIdentifier];
    NSDictionary *query = @{ (__bridge NSString *)kSecClass: (__bridge NSString *)kSecClassGenericPassword,
    (__bridge NSString *)kSecAttrService: identifier,
    (__bridge NSString *)kSecAttrLabel: serviceIdentifier };
    
    OSStatus err = SecItemDelete((__bridge CFDictionaryRef)query);
    
    BOOL result = (err == noErr || err == errSecItemNotFound);
    
    NSAssert1(result, @"error while deleting token from keychain: %ld", err);
    
    if (result) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:identifier];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return result;
}

#pragma mark Public API

+ (NSString *)serviceIdentifier;
{
    NSAssert(NO, @"Subclasses have to override +serviceIdentifier and return a unique string");
    return nil;
}

+ (NSString *)username;
{
    return [self usernameForServiceIdentifier:[self serviceIdentifier]];
}

+ (NSString *)password;
{
    return [self passwordForServiceIdentifier:[self serviceIdentifier]];
}

+ (BOOL)storeAccountWithUsername:(NSString *)username password:(NSString *)password;
{
    return [self storeUsername:username password:password forServiceIdentifier:[self serviceIdentifier]];
}

+ (BOOL)removeAccount;
{
    return [self removeAccountForServiceIdentifier:[self serviceIdentifier]];
}


#pragma mark UIActivity

- (NSString *)activityType;
{
    return [[self class] serviceIdentifier];
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
        imageName = [NSString stringWithFormat:@"%@-ipad%@", [[self class] serviceIdentifier], resoutionMultiplier];
    } else {
        imageName = [NSString stringWithFormat:@"%@-iphone%@", [[self class] serviceIdentifier], resoutionMultiplier];
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

- (void)performActivity;
{
    NSString *username = [[self class] username];
    
    UIWindow *mainWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
    hud.labelText = @"Saving…";
    
    if (username) {
        for (NSURL *shareURL in self.activityItems) {

            NSURLRequest *request = [self readLaterRequest:shareURL];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [NSURLConnection sendAsynchronousRequest:request
                                                   queue:[NSOperationQueue mainQueue]
                                       completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                           BOOL success = NO;
                                           
                                           [self activityDidFinish:success withItem:shareURL];
                                       }];
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
        int64_t delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            UIWindow *mainWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
            [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
        });
        
        
        [self activityDidFinish:completed];
    }
}

#pragma mark Read later

- (NSURLRequest *)loginRequestWithUsername:(NSString *)username password:(NSString *)password;
{
    NSAssert(NO, @"Subclasses must provide a -loginRequest impelmentation");
    return nil;
}

- (NSURLRequest *)readLaterRequest:(NSURL *)shareURL;
{
    NSAssert(NO, @"Subclasses must provide a -readLaterRequest impelmentation");
    return nil;
}

@end
