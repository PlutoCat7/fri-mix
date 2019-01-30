//
//  GBBasePageViewController.m
//  GBUICommon
//
//  Created by 王时温 on 2016/11/17.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBBasePageViewController.h"
#import "GBEmptyView.h"

@interface GBBasePageViewController ()

@property (nonatomic, strong) GBEmptyView *emptyView;

@end

@implementation GBBasePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    [self.emptyView clip:self.emptyView.roundView.width/2];
}

#pragma mark - Private

- (NSString *)emptyTitle {
    
    return LS(@"暂无数据");
}

#pragma mark - EmptyDataSet delegate

- (UIView*)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    
    if (!self.emptyScrollView) {
        return nil;
    }
    self.emptyView = [[[NSBundle mainBundle] loadNibNamed:@"GBEmptyView" owner:nil options:nil] lastObject];
    self.emptyView.frame = self.emptyScrollView.bounds;
    self.emptyView.title = [self emptyTitle];;
    return self.emptyView;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    
    return self.isShowEmptyView;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    
    return YES;
}

#pragma mark - Setter and Getter

- (void)setEmptyScrollView:(__kindof UIScrollView *)emptyScrollView {
    
    _emptyScrollView = emptyScrollView;
    _emptyScrollView.emptyDataSetSource = self;
    _emptyScrollView.emptyDataSetDelegate = self;
}

@end
