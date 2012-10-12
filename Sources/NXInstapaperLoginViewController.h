//
//  NXInstapaperLoginViewController.h
//  NXActivities
//
//  Created by Thomas Kollbach on 12.10.12.
//  Copyright (c) 2012 nxtbgthng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NXInstapaperLoginViewController;
typedef void(^NXInstapaperLoginViewControllerResultHandler)(NXInstapaperLoginViewController *controller, BOOL success);


@interface NXInstapaperLoginViewController : UITableViewController

- (id)initWithResultHandler:(NXInstapaperLoginViewControllerResultHandler)handler;

@property (nonatomic, copy) NXInstapaperLoginViewControllerResultHandler handler;

- (IBAction)login:(id)sender;

@end
