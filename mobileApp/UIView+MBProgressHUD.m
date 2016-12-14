//
//  UIView+MBProgressHUD.m
//  mobileApp
//
//  Created by admin_user on 12/14/16.
//  Copyright © 2016 ServersCheck. All rights reserved.
//

#import "UIView+MBProgressHUD.h"
#import "MBProgressHUD.h"

@implementation UIView (MBProgressHUD)

- (void)showProgressWithMessage:(NSString *)message {
    [self dismissProgress];
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self animated:YES];
    progress.dimBackground = YES;
    progress.labelText = message;
}

- (void)dismissProgress {
    [MBProgressHUD hideHUDForView:self animated:YES];
}

@end
