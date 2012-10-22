//
//  NXViewController.h
//  NXActivitiesDemo
//
//  Created by Thomas Kollbach on 12.10.12.
//  Copyright (c) 2012 nxtbgthng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NXViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *URLField;
@property (weak, nonatomic) IBOutlet UIButton *instapaperLogOutButton;
@property (weak, nonatomic) IBOutlet UIButton *pocketLogOutButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

- (IBAction)share:(id)sender;
- (IBAction)logOutOfInstapaper:(id)sender;
- (IBAction)logOutOfPocket:(id)sender;

@end
