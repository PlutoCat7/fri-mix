//
//  MyOrderViewController.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/8.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "MyOrderViewController.h"
#import "OrderListViewController.h"

#import "MyOrderHeaderMenuView.h"

@interface MyOrderViewController () <MyOrderHeaderMenuViewDelegate>

@property (weak, nonatomic) IBOutlet MyOrderHeaderMenuView *menuView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) NSArray<OrderListViewController *> *vcList;

@end

@implementation MyOrderViewController

- (instancetype)initWithIndex:(NSInteger)index {
    
    self = [super init];
    if (self) {
        _selectIndex = index;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.scrollView.contentOffset = CGPointMake(self.scrollView.width*self.selectIndex, 0);
        CGFloat posX = 0;
        for (OrderListViewController *vc in self.vcList) {
            vc.view.frame = CGRectMake(posX, 0, self.scrollView.width, self.scrollView.height);
            posX += self.scrollView.width;
        }
    });
    
}
#pragma mark - Private

- (void)setupUI {
    
    self.title = @"我的订单";
    [self setupBackButtonWithBlock:nil];
    
    self.menuView.delegate = self;
    self.menuView.titles = @[@"待付款", @"待发货", @"待收货", @"已完成"]
    ;
    self.menuView.selectIndex = 0;
    
    //self.scrollView.scr
    [self setupVC];
}

- (void)setupVC {
    
    OrderListViewController *vc1 = [[OrderListViewController alloc] initWithType:OrderType_PendingPayment];
    OrderListViewController *vc2 = [[OrderListViewController alloc] initWithType:OrderType_Delivered];
    OrderListViewController *vc3 = [[OrderListViewController alloc] initWithType:OrderType_Received];
    OrderListViewController *vc4 = [[OrderListViewController alloc] initWithType:OrderType_Completed];
    self.vcList = @[vc1, vc2, vc3, vc4];
    for (OrderListViewController *vc in self.vcList) {
        [self addChildViewController:vc];
    }
    
    [self.scrollView addSubview:vc1.view];
    [self.scrollView addSubview:vc2.view];
    [self.scrollView addSubview:vc3.view];
    [self.scrollView addSubview:vc4.view];
    
    [self.vcList[self.selectIndex] loadPageData];
    self.menuView.selectIndex = self.selectIndex;
}

#pragma mark - MyOrderHeaderMenuViewDelegate

- (void)menuDidSelectWithIndex:(NSInteger)index {
    
    if (index == self.selectIndex) {
        return;
    }
    self.selectIndex = index;
    [self.vcList[index] loadPageData];
    [self.scrollView setContentOffset:CGPointMake(index*self.scrollView.width, 0) animated:YES];
}

@end
