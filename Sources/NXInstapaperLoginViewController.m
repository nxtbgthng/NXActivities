//
//  NXInstapaperLoginViewController.m
//  NXActivities
//
//  Created by Thomas Kollbach on 12.10.12.
//  Copyright (c) 2012 nxtbgthng. All rights reserved.
//

#import "NXTextInputCell.h"

#import "NXInstapaperLoginViewController.h"

NSString * const NXInstapaperLoginViewControllerInputCellIdentifier = @"InputCell";


@interface NXInstapaperLoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong, readonly) UITextField *usernameField;
@property (nonatomic, strong, readonly) UITextField *passwordField;

@end

@implementation NXInstapaperLoginViewController

- (id)initWithResultHandler:(NXInstapaperLoginViewControllerResultHandler)handler;
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        _handler = [handler copy];
    }
    
    return self;
}

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[NXTextInputCell class]
           forCellReuseIdentifier:NXInstapaperLoginViewControllerInputCellIdentifier];
    
    self.navigationItem.title = @"Login";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Login"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(login)];
}

#pragma mark Accessibility

- (UITextField *)usernameField;
{
    NXTextInputCell *cell =  (NXTextInputCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    return cell.inputField;
}

- (UITextField *)passwordField;
{
    NXTextInputCell *cell =  (NXTextInputCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    return cell.inputField;    
}


#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 2;
}

#pragma mark UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NXTextInputCell *cell = [tableView dequeueReusableCellWithIdentifier:NXInstapaperLoginViewControllerInputCellIdentifier
                                                            forIndexPath:indexPath];
    
    cell.inputField.delegate = self;
    
    if (indexPath.row == 0) {
        cell.inputField.placeholder = @"Username";
        cell.inputField.secureTextEntry = NO;
        cell.inputField.returnKeyType = UIReturnKeyNext;
    } else {
        cell.inputField.placeholder = @"Password";
        cell.inputField.secureTextEntry = YES;
        cell.inputField.returnKeyType = UIReturnKeyDone;
    }
    
    return cell;
}


#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    if (textField == self.usernameField) {
        [self.passwordField becomeFirstResponder];
    } else {
        [self login:textField];
    }
    
    return NO;
}

#pragma mark Actions

- (void)login:(id)sender;
{
    NSLog(@"login with %@ pass %@", self.usernameField.text, self.passwordField.text);
}




@end
