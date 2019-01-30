//
//  GBWebBrowserViewController.m
//  GB_Football
//
//  Created by Pizza on 16/8/15.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBWebBrowserViewController.h"
#import "GBHomeViewController.h"
#import <WebKit/WebKit.h>

@interface GBWebBrowserViewController () <
WKNavigationDelegate>

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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if ([self.navigationController.topViewController isMemberOfClass:[GBHomeViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    [self.webView setFrame:CGRectMake(0, kUIScreen_NavigationBarHeight, self.view.width, kUIScreen_AppContentHeight)];
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
    [self setupBackButtonWithBlock:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    // 设置语言头部参数
    
    [self.webView loadRequest:request];
}

-(void)loadData
{
    
}

#pragma mark - Getters & Setters

- (WKWebView *)webView {
    
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero];
        _webView.navigationDelegate = self;
        [self.view addSubview:_webView];
    }
    
    return _webView;
}

@end
