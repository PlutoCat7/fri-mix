//
//  COSBaseViewController.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/7/31.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "COSBaseViewController.h"
#import "IQKeyboardManager.h"

@interface COSBaseViewController ()

@property (nonatomic, copy) void(^backBlock)();

@end

@implementation COSBaseViewController

- (void)dealloc
{
    GBLog(@"dealloc %@", [self description]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    // 兼容ios8后ScrollViewInsets
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 点击背景收回键盘
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [self loadData];
    [self setupUI];
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

- (UIButton *)setupBackButtonWithBlock:(void(^)())backBlock {
    self.backBlock = backBlock;
    UIButton *tmpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tmpBtn setSize:CGSizeMake(24, 24)];
    [tmpBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
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

#pragma mark - Action

- (void)onReturnBtnPress {
    
    if (self.backBlock) {
        self.backBlock();
    }
    
    [self.navigationController yh_popViewController:self animated:YES];
    
}

@end
