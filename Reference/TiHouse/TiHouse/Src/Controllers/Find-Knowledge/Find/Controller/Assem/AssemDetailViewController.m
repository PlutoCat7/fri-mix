//
//  AssemDetailViewController.m
//  TiHouse
//
//  Created by yahua on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AssemDetailViewController.h"
#import "GBWebBrowserViewController.h"
#import "UIImageView+WebCache.h"
#import "FindPostTool.h"

@interface AssemDetailViewController () <
UIWebViewDelegate,
UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) UIWebView *webView;


@property (nonatomic, strong) FindAssemActivityInfo *assemInfo;

@end

@implementation AssemDetailViewController


- (instancetype)initWithAssemInfo:(FindAssemActivityInfo *)info {
    
    self = [super init];
    if (self) {
        _assemInfo = info;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self refreshWithAssemInfo:_assemInfo];
}

- (void)refreshWithAssemInfo:(FindAssemActivityInfo *)info {
    
    self.assemInfo = info;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_assemInfo.assemurlindex]];
    self.titleLabel.text = _assemInfo.assemtitle?_assemInfo.assemtitle:@"";
    NSString *prizeHtmlString = @"";
    if (_assemInfo.assemlinkprize != nil && _assemInfo.assemlinkprize.length > 0) {
        NSString *prizeString = @"查看本期奖品详情";
        prizeHtmlString = [NSString stringWithFormat:@"<p><a href=\"prize://\" style=\"text-decoration:none;color:#5186aa;\">%@</a></p>", prizeString];
    }
    
    NSString *html = [NSString stringWithFormat:@"%@%@", _assemInfo.assemcontent, prizeHtmlString];
    [self.webView loadHTMLString:html baseURL:nil];
}

#pragma mark - Private

- (void)setupUI {

    [self.view addSubview:self.webView];
}

#pragma mark - Setter and Getter

- (UIWebView *)webView {
    
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kRKBWIDTH(250), kScreen_Width, 100)];
        _webView.delegate = self;
        _webView.scrollView.bounces = NO;
        _webView.scrollView.scrollEnabled = NO;
        _webView.opaque = NO;
        _webView.backgroundColor = [UIColor whiteColor];
    }
    
    return _webView;
}

#pragma mark - Delegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    
    if ([[URL scheme] isEqualToString:@"prize"]) {
        GBWebBrowserViewController *vc = [[GBWebBrowserViewController alloc] initWithTitle:@"查看本期奖品详情" url:_assemInfo.assemlinkprize];
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    return YES;
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *scheme = request.URL.scheme;
    if ([scheme isEqualToString:@"prize"]) {
        GBWebBrowserViewController *vc = [[GBWebBrowserViewController alloc] initWithTitle:@"查看本期奖品详情" url:_assemInfo.assemlinkprize];
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
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
        CGRect webFrame = CGRectMake(webView.left,  webView.top, webView.width, height+30);
        webView.frame = webFrame;
        
        CGFloat padding = kRKBWIDTH(15);
        self.viewHeight = self.webView.bottom + padding;
    });
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    NSLog(@"webview didFailLoadWithError:%@", error);
}

@end
