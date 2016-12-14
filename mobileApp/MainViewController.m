//
//  MainViewController.m
//  mobileApp
//
//  Created by admin_user on 12/14/16.
//  Copyright © 2016 ServersCheck. All rights reserved.
//

#import "MainViewController.h"
#import "LocalStorage.h"
#import "UIView+MBProgressHUD.h"
#import "UIViewController+Alert.h"

#define BASE_URL    @"https://my.infrastructuremonitoring.com/%@"
#define LOGOUT_URL  @"https://my.infrastructuremonitoring.com/logout.php"
#define MAP_URL     @"https://my.infrastructuremonitoring.com/m/map.php"
#define DEVICE_URL  @"https://my.infrastructuremonitoring.com/m/device.php"
#define ALERTS_URL  @"https://my.infrastructuremonitoring.com/m/alerts.php"

@interface MainViewController () <UIWebViewDelegate>
{
    IBOutlet UIView *webViewContainer;
    IBOutlet UIWebView *webViewMap;
    IBOutlet UIWebView *webViewDevices;
    IBOutlet UIWebView *webViewAlerts;
    IBOutlet UILabel *lblLastRefresh;
}

@end

@implementation MainViewController
{
    BOOL isLogining;
    BOOL isLogined;
    NSDate *dateMap;
    NSDate *dateDevices;
    NSDate *dateAlerts;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action Methods

- (IBAction)didTapLoginButton:(id)sender {
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
    } else {
        // Perform login.
        [self showProgress];
        
        isLogining = YES;
        NSString *loginURL = [NSString stringWithFormat:BASE_URL, @"login.php"];
        NSMutableURLRequest *loginRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:loginURL]];
        [loginRequest setHTTPMethod:@"POST"];
        [loginRequest setTimeoutInterval:7];
        NSString *body = [NSString stringWithFormat:@"email=%@&pass=%@", email, password];
        [loginRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
        [webViewDevices loadRequest:loginRequest];
    }
}

- (IBAction)didTapAccountButton:(id)sender {
    [self showAccountSettings];
}

- (IBAction)didTapMapButton:(id)sender {
    webViewMap.hidden = NO;
    webViewDevices.hidden = YES;
    webViewAlerts.hidden = YES;
    lblLastRefresh.text = [self convertDateToString:dateMap];
    [webViewMap loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:MAP_URL]]];
}

- (IBAction)didTapDeviceButton:(id)sender {
    webViewMap.hidden = YES;
    webViewDevices.hidden = NO;
    webViewAlerts.hidden = YES;
    lblLastRefresh.text = [self convertDateToString:dateDevices];
    [webViewDevices loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:DEVICE_URL]]];
}

- (IBAction)didTapAlertsButton:(id)sender {
    webViewMap.hidden = YES;
    webViewDevices.hidden = YES;
    webViewAlerts.hidden = NO;
    lblLastRefresh.text = [self convertDateToString:dateAlerts];
    [webViewAlerts loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:ALERTS_URL]]];
}

- (IBAction)didTapLogoutButton:(id)sender {
    [self shouldPerformLogout];
}

- (void)showAccountSettings {
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UIWebViewDelegate Methods

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if (!isLogining) {
        [self showProgress];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.view dismissProgress];
    NSString *requestString = webView.request.URL.absoluteString;
    NSLog(@"response: %@", requestString);
    if (!isLogined) {
        if (isLogining) {
            isLogining = false;
            if ([requestString isEqualToString:[NSString stringWithFormat:BASE_URL, @"device.php"]] && webView == webViewDevices) {
                isLogined = YES;
                webViewContainer.hidden = NO;
                [webViewDevices loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:DEVICE_URL]]];
                dateMap = dateDevices = dateAlerts = [NSDate date];
            } else {
                [self showOkAlertWithTitle:@"Error" message:@"Login failed. Please verify your network settings, username & password"];
            }
        }
    } else {
        if ([requestString isEqualToString:[NSString stringWithFormat:BASE_URL, @"login.php"]] && isLogined) {
            [self shouldPerformLogout];
        } else {
            NSDate *now = [NSDate date];
            if (webView == webViewMap) {
                dateMap = now;
            } else if (webView == webViewDevices) {
                dateDevices = now;
            } else if (webView == webViewAlerts) {
                dateAlerts = now;
            }
            lblLastRefresh.text = [self convertDateToString:now];
        }
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.view dismissProgress];
}

#pragma mark - Show/Dismiss Progress

- (void)showProgress {
    [self.view showProgressWithMessage:@""];
}

- (void)dismissProgress {
    [self.view dismissProgress];
}

- (void)shouldPerformLogout {
    isLogined = NO;
    webViewContainer.hidden = YES;
    [webViewMap stopLoading];
    [webViewDevices stopLoading];
    [webViewAlerts stopLoading];
    
    [webViewDevices loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:LOGOUT_URL]]];
}

- (NSString *)convertDateToString:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EE MMM dd, yyyy - HH:mm"];
    return [dateFormatter stringFromDate:date];
}

@end

