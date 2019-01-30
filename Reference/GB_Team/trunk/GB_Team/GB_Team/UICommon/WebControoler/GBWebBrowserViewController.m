//
//  GBWebBrowserViewController.m
//  GB_Football
//
//  Created by Pizza on 16/8/15.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBWebBrowserViewController.h"
#import "GBLoginViewController.h"

@interface GBWebBrowserViewController () <
UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) NSString *url;

@end

@implementation GBWebBrowserViewController

#pragma mark -
#pragma mark Memory

- (instancetype)initWithTitle:(NSString *)title url:(NSString *)url {
    
    if(self=[super init]){
        self.titleString = title;
        self.url = url;
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if ([self.navigationController.topViewController isMemberOfClass:[GBLoginViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

#pragma mark - Notification

#pragma mark - Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [self showLoadingToast];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self dismissToast];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [self dismissToast];
}

#pragma mark - Action


#pragma mark - Private

- (void)setupUI {
    
    self.title = self.titleString;
    [self setupBackButtonWithBlock:nil];
    
    self.webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webView loadRequest:request];
}

@end
