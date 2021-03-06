//
//  NXInstapaperLoginViewController.m
//  NXActivities
//
//  Created by Thomas Kollbach on 12.10.12.
//  Copyright (c) 2012 nxtbgthng. All rights reserved.
//

#import "NSBundle+NXActivities.h"

#import "NXReadLaterTextInputCell.h"
#import "NXInstapaperActivity.h"

#import "NXReadLaterLoginViewController.h"

NSString * const NXReadLaterLoginViewControllerInputCellIdentifier = @"InputCell";


@interface NXReadLaterLoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong, readonly) UITextField *usernameField;
@property (nonatomic, strong, readonly) UITextField *passwordField;

@end

@implementation NXReadLaterLoginViewController

- (id)initWithActivity:(NXReadLaterActivity *)activity resultHandler:(NXReadLaterLoginViewControllerResultHandler)handler;
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        _handler = [handler copy];
        _activity = activity;
        self.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    return self;
}

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[NXReadLaterTextInputCell class]
           forCellReuseIdentifier:NXReadLaterLoginViewControllerInputCellIdentifier];
    
    self.navigationItem.title = self.activity.activityTitle;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[[NSBundle nxactivitiesBundle] localizedStringForKey:@"keyLoginButton"
                                                                                                                                   value:@"Login"
                                                                                                                                   table:nil]
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(login:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(cancel:)];
}

- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
    
    self.usernameField.text = [[self.activity class] username];
    [self.usernameField becomeFirstResponder];
}

#pragma mark Accessibility

- (UITextField *)usernameField;
{
    NXReadLaterTextInputCell *cell =  (NXReadLaterTextInputCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    return cell.inputField;
}

- (UITextField *)passwordField;
{
    NXReadLaterTextInputCell *cell =  (NXReadLaterTextInputCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
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
    NXReadLaterTextInputCell *cell = [tableView dequeueReusableCellWithIdentifier:NXReadLaterLoginViewControllerInputCellIdentifier
                                                            forIndexPath:indexPath];
    
    cell.inputField.delegate = self;
    
    if (indexPath.row == 0) {
        cell.inputField.placeholder = [[NSBundle nxactivitiesBundle] localizedStringForKey:@"keyEmailOrUsernamePlaceholder"
                                                                                     value:@"Email or Username"
                                                                                     table:nil];
        cell.inputField.secureTextEntry = NO;
        cell.inputField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        cell.inputField.keyboardType = UIKeyboardTypeEmailAddress;
        cell.inputField.returnKeyType = UIReturnKeyNext;
        cell.inputField.enablesReturnKeyAutomatically = YES;
    } else {
        cell.inputField.placeholder = [[NSBundle nxactivitiesBundle] localizedStringForKey:@"keyPasswordPlaceholder"
                                                                                     value:@"Password"
                                                                                     table:nil];
        cell.inputField.secureTextEntry = YES;
        cell.inputField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        cell.inputField.keyboardType = UIKeyboardTypeDefault;
        cell.inputField.returnKeyType = UIReturnKeyDone;
        cell.inputField.enablesReturnKeyAutomatically = YES;
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

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    [self updateUI];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    [self updateUI];
    
    return YES;
}


#pragma mark Actions

- (void)login:(id)sender;
{
    if ([self fieldsValid]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.navigationItem.leftBarButtonItem.enabled = NO;
        self.passwordField.enabled = NO;
        self.usernameField.enabled = NO;
        
        [self.passwordField resignFirstResponder];
        [self.usernameField resignFirstResponder];
        
        NSURLRequest *request = [self.activity loginRequestWithUsername:self.usernameField.text password:self.passwordField.text];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                       self.navigationItem.rightBarButtonItem.enabled = YES;
                                       self.navigationItem.leftBarButtonItem.enabled = YES;
                                       self.passwordField.enabled = YES;
                                       self.usernameField.enabled = YES;
                                       
                                       if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                           NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                           if (httpResponse.statusCode == 200) {
                                               
                                               [[self.activity class] storeAccountWithUsername:self.usernameField.text
                                                                                      password:self.passwordField.text];
                                               
                                               if (_handler) _handler(self, YES);
                                               
                                               return;
                                           } else {
                                               NSLog(@"Readlater login for activity %@ failed with HTTP Status %d", self.activity, httpResponse.statusCode);
                                           }
                                       }
                                       
                                       NSLog(@"Readlater login for activity %@  failed with error %@", self.activity, error);
                                       
                                       [[self.activity class] removeAccount];
                                       
                                       if (_handler) _handler(self, NO);
                                   }];
        }];
    }
}

- (IBAction)cancel:(id)sender;
{
    if (_handler) _handler(self, NO);
}

- (void)updateUI;
{
    self.navigationItem.rightBarButtonItem.enabled = [self fieldsValid];
}

- (BOOL)fieldsValid;
{
    return self.usernameField.text != nil &&
           [self.usernameField.text isEqual:@""] == NO &&
            self.passwordField.text != nil &&
           [self.passwordField.text isEqual:@""] == NO;
}


@end
