//
//  UIView+MBProgressHUD.h
//  mobileApp
//
//  Created by admin_user on 12/14/16.
//  Copyright © 2016 ServersCheck. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MBProgressHUD)

- (void)showProgressWithMessage:(NSString *)message;

- (void)dismissProgress;

@end
