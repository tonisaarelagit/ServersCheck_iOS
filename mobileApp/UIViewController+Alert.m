//
//  UIViewController+Alert.m
//  mobileApp
//
//  Created by admin_user on 12/14/16.
//  Copyright © 2016 ServersCheck. All rights reserved.
//

#import "UIViewController+Alert.h"

@implementation UIViewController (Alert)

- (void)showOkAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
