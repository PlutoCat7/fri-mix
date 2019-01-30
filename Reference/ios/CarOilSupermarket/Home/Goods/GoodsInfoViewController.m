//
//  GoodsInfoViewController.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/8.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "GoodsInfoViewController.h"
#import "HomeViewController.h"
#import "ShoppingCartViewController.h"
#import "LoginViewController.h"

#import <WebKit/WebKit.h>
#import "GoodsHeaderView.h"

#import "GoodInfoViewModel.h"
#import "GoodsContentModel.h"
#import "GoodsResponse.h"

@interface GoodsInfoViewController ()<
UIWebViewDelegate>

@property (nonatomic, strong) UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) GoodsHeaderView *headerView;
@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) GoodInfoViewModel *viewModel;

@end

@implementation GoodsInfoViewController

- (instancetype)initWithGoodsId:(NSInteger)goodsId {
    
    self = [super init];
    if (self) {
        _viewModel = [[GoodInfoViewModel alloc] initWithGoodsId:goodsId];
        @weakify(self)
        [self.yah_KVOController observe:_viewModel keyPath:@"tipsMsg" block:^(id observer, id object, NSDictionary *change) {
            
            @strongify(self)
            [self showToastWithText:self.viewModel.tipsMsg];
        }];
        [self.yah_KVOController observe:_viewModel keyPath:@"goodsContentModel" block:^(id observer, id object, NSDictionary *change) {
            
            @strongify(self)
            [self refreshContent];
        }];
        [self.yah_KVOController observe:_viewModel keyPath:@"goodsHeaderModel" block:^(id observer, id object, NSDictionary *change) {
            
            @strongify(self)
            [self dismissToast];
            [self refreshHeader];
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self showLoadingToast];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if ([self.navigationController.topViewController isMemberOfClass:[HomeViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    self.headerView.frame = CGRectMake(0, 0, kUIScreen_Width, 543*kAppScale);
}

#pragma mark - Action

- (void)actionSave {
    
    [self.navigationController pushViewController:[ShoppingCartViewController new] animated:YES];
}
- (IBAction)actionToShoppingCart:(id)sender {
    
    if (![LogicManager isUserLogined]) {
        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
        return;
    }
    [self.viewModel addGoodsToShopping:nil];
}

#pragma mark - Private

- (void)setupUI {
    
    self.title = @"产品详情";
    [self setupBackButtonWithBlock:nil];
    
    [self setupNavigationBarRight];
    
    [self.scrollView addSubview:self.headerView];
    [self.scrollView addSubview:self.webView];
}

- (void)setupNavigationBarRight {
    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveButton setSize:CGSizeMake(48, 24)];
    [self.saveButton setImage:[UIImage imageNamed:@"shoping_detail"] forState:UIControlStateNormal];
    self.saveButton.backgroundColor = [UIColor clearColor];
    [self.saveButton addTarget:self action:@selector(actionSave) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:self.saveButton];
    [self.navigationItem setRightBarButtonItem:rightButton];
}

- (void)refreshHeader {
    
    [self.headerView refreshWithModel:self.viewModel.goodsHeaderModel];
}

- (void)refreshContent {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.viewModel.goodsContentModel.contentUrl]];
    [self.webView loadRequest:request];
}

#pragma mark - Getters & Setters

- (GoodsHeaderView *)headerView {
    
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle] loadNibNamed:@"GoodsHeaderView" owner:self options:nil].firstObject;
        
    }
    return _headerView;
}

- (UIWebView *)webView {
    
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,  self.headerView.bottom, kUIScreen_Width, 400)];
        _webView.delegate = self;
        _webView.scrollView.bounces = NO;
        _webView.scrollView.scrollEnabled = NO;
    }
    
    return _webView;
}

#pragma mark - Delegate

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
        //ps:js可以是上面所写，也可以是document.body.scrollHeight;个人觉得两者在UIWebView中都可以，但是在WKWebView中就不同了，后面会有介绍
        CGRect webFrame = CGRectMake(0,  self.headerView.bottom, kUIScreen_Width, height);
        webView.frame = webFrame;
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.webView.bottom);
    });
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    /* 可取的js:
     1、@"document.body.scrollHeight" (为主)
     2、@"window.screen.height" 要求高度不能超过屏幕高度。
     */
    /* 我们使用js 来获取网页的高度*/
    NSString * JsString = @"document.body.scrollHeight";

    [webView evaluateJavaScript:JsString completionHandler:^(id _Nullable value, NSError * _Nullable error) {
        CGRect WebViewRect = webView.frame;
        /* 改版WebView的高度*/
        WebViewRect.size.height = [value doubleValue];
        /* 重新设置网页的frame*/
        webView.frame = WebViewRect;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.webView.bottom);
    }];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    [self showToastWithText:@"请求失败！"];
}

@end
