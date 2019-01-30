//
//  GBWKWebViewController.m
//  GB_Football
//
//  Created by Pizza on 2016/12/2.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBWKWebViewController.h"
#import "GBMenuViewController.h"
#import <WebKit/WebKit.h>
#import "UMShareManager.h"
#import "GBSharePan.h"

@interface GBWKWebViewController ()<
WKNavigationDelegate,
GBSharePanDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) WKWebView *wkWebView;
@property (nonatomic, copy) NSString *contentTitle;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSURL *requestUrl;
// 分享功能
@property (strong, nonatomic) GBSharePan   *sharePan;
@property (strong, nonatomic)  UIButton    *backButton;
@property (strong, nonatomic)  UIImage     *shotImage;

@end

@implementation GBWKWebViewController


#pragma mark -
#pragma mark Memory

- (void)dealloc{
}

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content webUrl:(NSString *)url {
    
    self = [super init];
    if (self) {
        _contentTitle = title;
        _content = content;
        _requestUrl = [NSURL URLWithString:url];
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if ([self.navigationController.topViewController isMemberOfClass:[GBMenuViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

#pragma mark - Private

- (void)setupUI {
    
    self.title = self.contentTitle;
    self.backButton = [self setupBackButtonWithBlock:nil];
    [self showNavItems];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.wkWebView = [[WKWebView alloc] initWithFrame:self.contentView.bounds];
        self.wkWebView.navigationDelegate = self;
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:self.requestUrl]];
        [self.contentView addSubview:self.wkWebView];
    });
}

- (void)onReturnBtnPress {
    if (self.wkWebView.canGoBack==YES) {
        [self.wkWebView goBack];
        return;
    }
    
    [self.navigationController yh_popViewController:self animated:YES];
}


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

#pragma mark - Analytics

- (void)shareSuccess {
    [UMShareManager event:Analy_Click_Share_Url];
}

#pragma mark - 分享功能

-(void)shareItemAction
{
    [self hideNavItems];
    [self.sharePan showSharePanWithDelegate:self];
}

- (GBSharePan*)sharePan
{
    if (!_sharePan)
    {
        _sharePan = [[GBSharePan alloc] init];
        _sharePan.delegate = self;
    }
    return _sharePan;
}

- (void)GBSharePanAction:(GBSharePan*)pan tag:(SHARE_TYPE)tag
{
    [[[UMShareManager alloc]init] webShare:tag
                                    titile:self.contentTitle
                                   content:self.content
                                       url:self.requestUrl.absoluteString
 image:nil complete:^(NSInteger state){
        switch (state)
        {
            case 0:
            {
                [self showToastWithText:LS(@"share.toast.success")];
                [self showNavItems];
                [self shareSuccess];
                [pan hide:^(BOOL ok){}];
            }break;
            case 1:
            {
                [self showToastWithText:LS(@"share.toast.fail")];
                [self showNavItems];
                [pan hide:^(BOOL ok){}];
            }break;
            default:
                break;
        }
    }];
}

- (void)GBSharePanActionCancel:(GBSharePan *)pan
{
    [self showNavItems];
}

-(void)hideNavItems
{
    self.backButton.hidden = YES;
    self.navigationItem.rightBarButtonItem = nil;
}

-(void)showNavItems
{
    self.backButton.hidden = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(shareItemAction)];
}

@end
