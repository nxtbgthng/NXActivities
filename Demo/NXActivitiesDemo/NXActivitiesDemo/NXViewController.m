//
//  NXViewController.m
//  NXActivitiesDemo
//
//  Created by Thomas Kollbach on 12.10.12.
//  Copyright (c) 2012 nxtbgthng. All rights reserved.
//

#import "NXInstapaperActivity.h"
#import "NXPocketActivity.h"

#import "NXViewController.h"

@interface NXViewController ()

@end

@implementation NXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

//#error Insert your Pocket API Key here and remove this directive
//    [NXPocketActivity setPocketAPIKey:nil];
}

- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
    
    [self updateButtons];
}

- (IBAction)share:(id)sender;
{
    NXInstapaperActivity *instapaperActivity = [[NXInstapaperActivity alloc] init];
    NXPocketActivity *pocketActivity = [[NXPocketActivity alloc] init];
    
    UINavigationController *navController = (UINavigationController *)instapaperActivity.activityViewController;
    navController.navigationBar.tintColor = [UIColor lightGrayColor];
    
    NSURL *url = [NSURL URLWithString:self.URLField.text];
    if (url) {
        UIActivityViewController *shareController = [[UIActivityViewController alloc] initWithActivityItems:@[ url ]
                                                                                      applicationActivities:@[ instapaperActivity,pocketActivity ]];
        [self presentViewController:shareController animated:YES completion:NULL];
        shareController.completionHandler = ^(NSString *type, BOOL completed) {
            [self updateButtons];
        };
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Invalid URL"
                                   message:[NSString stringWithFormat:@"%@ is not an URL", self.URLField.text]
                                  delegate:nil
                         cancelButtonTitle:@"Done"
                         otherButtonTitles: nil] show];
    }
}

- (IBAction)logOutOfInstapaper:(id)sender;
{
    [NXInstapaperActivity removeAccount];
    [self updateButtons];    
}

- (IBAction)logOutOfPocket:(id)sender;
{
    [NXPocketActivity removeAccount];
    [self updateButtons];
}

- (void)updateButtons;
{
    self.instapaperLogOutButton.enabled = [NXInstapaperActivity hasAccount];
    self.pocketLogOutButton.enabled = [NXPocketActivity hasAccount];
}

@end
