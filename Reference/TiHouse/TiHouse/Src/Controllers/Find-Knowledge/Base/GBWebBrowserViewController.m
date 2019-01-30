//
//  GBWebBrowserViewController.m
//  GB_Football
//
//  Created by Pizza on 16/8/15.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBWebBrowserViewController.h"
#import "UIViewController+YHToast.h"
#import <WebKit/WebKit.h>

@interface GBWebBrowserViewController () <
WKNavigationDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) NSString *url;

@end

@implementation GBWebBrowserViewController


#pragma mark -
#pragma mark Memory

- (void)dealloc{
    
}

- (instancetype)initWithTitle:(NSString *)title url:(NSString *)url {
    
    if(self=[super init]){
        self.titleString = title;
        self.url = url;
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.webView.frame = self.contentView.bounds;
    });
}

#pragma mark - Notification

#pragma mark - Delegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [self showLoadingToast];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [self dismissToast];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    [self dismissToast];
}

#pragma mark - Action


#pragma mark - Private

-(void)setupUI
{
    self.title = self.titleString;
    
    NSURL *url = [NSURL URLWithString:self.url];
    if (![url scheme] ||
        [[url scheme] isEmpty]) {
        return;
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark - Getters & Setters

- (WKWebView *)webView {
    
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero];
        _webView.navigationDelegate = self;
        [self.contentView addSubview:_webView];
    }
    
    return _webView;
}

@end
