//
//  NXTextInputCell.h
//  NXActivities
//
//  Created by Thomas Kollbach on 12.10.12.
//  Copyright (c) 2012 nxtbgthng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NXTextInputCell : UITableViewCell

@property (nonatomic, strong, readwrite) IBOutlet UITextField *inputField;
@property (nonatomic, strong, readwrite) id context;

@end
