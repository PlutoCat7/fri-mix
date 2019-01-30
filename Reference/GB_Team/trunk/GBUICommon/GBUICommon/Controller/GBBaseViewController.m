//
//  GBBaseViewController.m
//  GBUICommon
//
//  Created by weilai on 16/9/8.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBBaseViewController.h"

@interface GBBaseViewController ()

@property (nonatomic, copy) void(^backBlock)();

@end

@implementation GBBaseViewController

- (void)dealloc {
    
    NSLog(@"dealloc %@", [self description]);
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // xib起点参考坐标为0
    self.navigationController.navigationBar.translucent = YES;
    // 兼容ios8后ScrollViewInsets
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupUI];
    
    if ([self isAutoLoadData]) {
        [self loadData];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    
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
- (void)setupBackButtonWithBlock:(void(^)())backBlock {
    
    self.backBlock = backBlock;
    UIButton *tmpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = tmpBtn.frame;
    frame.size = CGSizeMake(24, 24);
    tmpBtn.frame = frame;
    
    [tmpBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    tmpBtn.backgroundColor = [UIColor clearColor];
    [tmpBtn addTarget:self action:@selector(onReturnBtnPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:tmpBtn];
    [self.navigationItem setLeftBarButtonItem:backBtn];
}

#pragma mark - Protected
- (void)setupUI {
}

- (void)loadData {
}

-(void)setTitle:(NSString *)title {
    
    [super setTitle:title];
    UIFont* font = [UIFont systemFontOfSize:20.0];
    NSDictionary* textAttributes = @{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes= textAttributes;
}

- (BOOL) isAutoLoadData {
    return YES;
}

#pragma mark - Action

- (void)onReturnBtnPress {
    
    if (self.backBlock) {
        self.backBlock();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
