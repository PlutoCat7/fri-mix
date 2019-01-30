//
//  FindArticlePreViewController.m
//  TiHouse
//
//  Created by yahua on 2018/2/3.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindArticlePreViewController.h"
#import "FindDraftSaveModel.h"
#import "ArticlePreHeadherView.h"
#import "UIViewController+YHToast.h"
#import "FindPostTool.h"
#import "BaseNavigationController.h"

@interface FindArticlePreViewController ()<
UIWebViewDelegate,
UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) ArticlePreHeadherView *headerView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) FindDraftSaveModel *saveModel;

@end

@implementation FindArticlePreViewController

- (instancetype)initWithSaveDraftInfo:(FindDraftSaveModel *)saveModel {
    
    self = [super init];
    if (self) {
        _saveModel = saveModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [(BaseNavigationController *)self.navigationController  hideNavBottomLine];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [(BaseNavigationController *)self.navigationController  showNavBottomLine];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
}

#pragma mark - Action


#pragma mark - Private

- (void)setupUI {
    
    //[self wr_setNavBarBackgroundAlpha:0];
    [self wr_setNavBarShadowImageHidden:YES];
    [self wr_setNavBarBarTintColor:[UIColor clearColor]];
    
    self.scrollView.delegate = self;
    [self.scrollView addSubview:self.headerView];
    [self.scrollView addSubview:self.webView];
    //self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.webView.bottom);
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.automaticallyAdjustsScrollViewInsets = YES;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark - Getters & Setters

- (ArticlePreHeadherView *)headerView {
    
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle] loadNibNamed:@"ArticlePreHeadherView" owner:self options:nil].firstObject;
        NSInteger headHeight = [ArticlePreHeadherView defaultHeight:self.saveModel.title];
        _headerView.frame = CGRectMake(0, 0, kScreen_Width, headHeight);
        _headerView.autoresizingMask = UIViewAutoresizingNone;
        [_headerView refreshWithDraftModel:self.saveModel];
    }
    return _headerView;
}

- (UIWebView *)webView {
    
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(kRKBWIDTH(18),  self.headerView.bottom, kScreen_Width-2*kRKBWIDTH(18), 400)];
        _webView.delegate = self;
        _webView.scrollView.bounces = NO;
        _webView.scrollView.scrollEnabled = NO;
        _webView.opaque = NO;
        _webView.backgroundColor = [UIColor clearColor];
        
        [self.webView loadHTMLString:_saveModel.htmlString baseURL:nil];
    }
    
    return _webView;
}

- (UITextView *)textView {
    
    if(!_textView) {
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, kScreen_Width, 0)];
        //_textView.attributedText = _saveModel.contentAttributedString;
        [_textView sizeToFit];
        _textView.editable = NO;
        _textView.scrollEnabled = NO;
        
        NSString *htmlStr = _saveModel.htmlString;
//        NSString *limitImageWidthHtmlStr = [NSString stringWithFormat:@"%@%@%@",@"<head><style>img{max-width:",[NSString stringWithFormat:@"%f%@",kScreen_Width - 50,@" !important;}</style></head>"],htmlStr];
        _textView.attributedText = [FindPostTool htmlToAttribute:htmlStr];
    }
    return _textView;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int contentOffsety = scrollView.contentOffset.y;

    //NavBar背景色渐变
    [self wr_setNavBarBarTintColor:XWColorFromHexAlpha(0xffffff,contentOffsety/10.0)];
    
}

#pragma mark - UIWebViewDelegate

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self dismissToast];
    
    NSString *js = @"function imgAutoFit() { \
    var imgs = document.getElementsByTagName('img'); \
    for (var i = 0; i < imgs.length; ++i) {\
    var img = imgs[i];   \
    img.style.maxWidth = %f;   \
    } \
    }";
    js = [NSString stringWithFormat:js, [UIScreen mainScreen].bounds.size.width - 20];
    
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
        //ps:js可以是上面所写，也可以是document.body.scrollHeight;个人觉得两者在UIWebView中都可以，但是在WKWebView中就不同了，后面会有介绍
        CGRect webFrame = CGRectMake(webView.left,  self.headerView.bottom, webView.width, height+100);
        webView.frame = webFrame;
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.webView.bottom);
    });
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
 
    [self showLoadingToast];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [self dismissToast];
}


@end
