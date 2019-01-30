//
//  HelpCenterViewController.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/3/13.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "HelpCenterViewController.h"
#import <WebKit/WKWebView.h>

@interface HelpCenterViewController ()

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation HelpCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"帮助中心";
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://wap.usure.com.cn/static/html/outer/help/inios.html"]]];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

#pragma mark - lazy
- (WKWebView *)webView
{
    if(!_webView)
    {
        _webView = [[WKWebView alloc] init];
//        _webView.navigationDelegate = self;
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [self.view insertSubview:_webView belowSubview:self.progressView];
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 11) {
                make.edges.equalTo(self.view);
            } else {
                make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kNavigationBarHeight, 0, 0, 0));
            }
        }];
    }
    return _webView;
}

- (UIProgressView *)progressView
{
    if(!_progressView)
    {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreen_Width, 0)];
        self.progressView.tintColor = [UIColor colorWithHexString:@"12B7F5"];
        self.progressView.trackTintColor = [UIColor whiteColor];
        [self.view addSubview:self.progressView];
    }
    return _progressView;
}

// 记得取消监听
- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
