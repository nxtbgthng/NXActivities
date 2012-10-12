//
//  NXViewController.m
//  NXActivitiesDemo
//
//  Created by Thomas Kollbach on 12.10.12.
//  Copyright (c) 2012 nxtbgthng. All rights reserved.
//

#import "NXInstapaperActivity.h"
#import "NXViewController.h"

@interface NXViewController ()

@end

@implementation NXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)share:(id)sender;
{
    NXInstapaperActivity *instapaperActivity = [[NXInstapaperActivity alloc] init];
    NSURL *url = [NSURL URLWithString:self.URLField.text];
    if (url) {
        UIActivityViewController *shareController = [[UIActivityViewController alloc] initWithActivityItems:@[ url ]
                                                                                      applicationActivities:@[ instapaperActivity ]];
        [self presentViewController:shareController animated:YES completion:NULL];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Invalid URL"
                                   message:[NSString stringWithFormat:@"%@ is not an URL", self.URLField.text]
                                  delegate:nil
                         cancelButtonTitle:@"Done"
                         otherButtonTitles: nil] show];
    }
}
@end
