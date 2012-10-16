//
//  NXInstapaperLoginViewController.h
//  NXActivities
//
//  Created by Thomas Kollbach on 12.10.12.
//  Copyright (c) 2012 nxtbgthng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NXReadLaterLoginViewController;
@class NXReadLaterActivity;
typedef void(^NXReadLaterLoginViewControllerResultHandler)(NXReadLaterLoginViewController *controller, BOOL success);


@interface NXReadLaterLoginViewController : UITableViewController

- (id)initWithActivity:(NXReadLaterActivity *)activity resultHandler:(NXReadLaterLoginViewControllerResultHandler)handler;

@property (nonatomic, copy) NXReadLaterLoginViewControllerResultHandler handler;
@property (nonatomic, strong) NXReadLaterActivity *activity;

- (IBAction)login:(id)sender;
- (IBAction)cancel:(id)sender;

@end
