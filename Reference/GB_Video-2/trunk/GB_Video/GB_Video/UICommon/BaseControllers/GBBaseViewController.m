//
//  GBBaseViewController.m
//  GB_Football
//
//  Created by wsw on 16/7/7.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBBaseViewController.h"
#import "IQKeyboardManager.h"

@interface GBBaseViewController ()
@property (nonatomic, copy) void(^backBlock)(void);

@end

@implementation GBBaseViewController

- (void)dealloc
{
    GBLog(@"dealloc %@", [self description]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // xib起点参考坐标为0
    self.navigationController.navigationBar.translucent = YES;
    // 兼容ios8后ScrollViewInsets
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 点击背景收回键盘
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [self localizeUI];
    [self loadData];
    [self setupUI];
    [self setupLayoutConstraint:self.view];
    [self loadNetworkData];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //解决自定义返回按钮  又滑失效问题
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    
}

#pragma mark - Public

- (UIButton *)setupBackButtonWithBlock:(void(^)(void))backBlock {
    self.backBlock = backBlock;
    UIButton *tmpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tmpBtn setSize:CGSizeMake(44, 24)];
    [tmpBtn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [tmpBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    tmpBtn.backgroundColor = [UIColor clearColor];
    [tmpBtn addTarget:self action:@selector(onReturnBtnPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:tmpBtn];
    [self.navigationItem setLeftBarButtonItem:backBtn];
    return tmpBtn;
}

- (void)loadData {
    
    
}

- (void)setupUI {
    
}

- (void)loadNetworkData {
    
    
}

- (void)localizeUI{

}

#pragma mark - Action

- (void)onReturnBtnPress {
    
    if (self.backBlock) {
        self.backBlock();
    }
    
    [self.navigationController yh_popViewController:self animated:YES];
    
}

#pragma mark - Private

- (void)setupLayoutConstraint:(UIView *)view {
    
    //iphoneX 适配
    NSArray<NSLayoutConstraint *> *arr = [view constraints];
    for (NSLayoutConstraint *constraint in arr) {
        if([IPHONEX_Layout_TopConstraint isEqualToString:constraint.identifier]){
            constraint.constant = kUIScreen_NavigationBarHeight;
            return;
        }
    }
    for (UIView *subView in view.subviews) {
        [self setupLayoutConstraint:subView];
    }
}

@end
