//
//  WebViewController.m
//  YouSuHuoPinPoint
//
//  Created by Teen Ma on 2017/12/15.
//  Copyright © 2017年 Teen Ma. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation WebViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.adverttype = @"";
        self.advertid = @"";
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUIInterface];
    
    [self setupData];
    // Do any additional setup after loading the view.
}

- (void)setupData
{
    if (self.webSite.length > 0)
    {
        NSURL* url = [NSURL URLWithString:[self.webSite stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
}

- (void)setupUIInterface
{
    self.title = @"";
    
    [self.view addSubview:self.webView];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *navigationTitle = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = navigationTitle;
    
    [[TiHouse_NetAPIManager sharedManager] request_advertclickWithAdvId:self.advertid type:self.adverttype completedUsing:^(id data, NSError *error) {
        
    }];
}

- (UIWebView *)webView
{
    if (!_webView)
    {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kNavigationBarHeight)];
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
        _webView.detectsPhoneNumbers = YES;
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _webView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
