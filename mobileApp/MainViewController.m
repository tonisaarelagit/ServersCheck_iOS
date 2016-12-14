//
//  MainViewController.m
//  mobileApp
//
//  Created by admin_user on 12/14/16.
//  Copyright © 2016 ServersCheck. All rights reserved.
//

#import "MainViewController.h"
#import "LocalStorage.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action Methods

- (IBAction)didTapLoginButton:(UIButton *)sender {
    NSString *email = [[LocalStorage shared] defaultForKey:@"email"];
    NSString *password = [[LocalStorage shared] defaultForKey:@"password"];
    if (email.length == 0 || password.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please set up username and password.\n Do you want to set up them now?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *noButton = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *yesButton = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
            [self showAccountSettings];
        }];
        [alert addAction:noButton];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)didTapAccountButton:(UIButton *)sender {
    [self showAccountSettings];
}

- (void)showAccountSettings {
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
