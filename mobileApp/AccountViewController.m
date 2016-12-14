//
//  AccountViewController.m
//  mobileApp
//
//  Created by admin_user on 12/14/16.
//  Copyright © 2016 ServersCheck. All rights reserved.
//

#import "AccountViewController.h"
#import "NSString+EmailValidation.h"
#import "UIViewController+Alert.h"
#import "LocalStorage.h"

@interface AccountViewController () <UITextFieldDelegate>
{
    IBOutlet UITextField *tfEmail;
    IBOutlet UITextField *tfPassword;
}

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tfEmail.text = [[LocalStorage shared] defaultForKey:@"email"];
    tfPassword.text = [[LocalStorage shared] defaultForKey:@"password"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action Methods

- (IBAction)didTapCloseButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didTapSaveButton:(UIButton *)sender {
    // Save and exit.
    NSString *email = tfEmail.text;
    NSString *password = tfPassword.text;
    if (email.length == 0 || ![email isValidEmail]) {
        [self showOkAlertWithTitle:@"Validation" message:@"Please insert valid e-mail"];
    } else if (password.length == 0) {
        [self showOkAlertWithTitle:@"Validation" message:@"Password can not be empty"];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
        [[LocalStorage shared] setDefault:email forKey:@"email"];
        [[LocalStorage shared] setDefault:password forKey:@"password"];
    }
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == tfEmail) {
        [tfPassword becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

@end
