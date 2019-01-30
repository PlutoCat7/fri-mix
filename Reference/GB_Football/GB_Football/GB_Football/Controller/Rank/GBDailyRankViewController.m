//
//  GBDailyRankViewController.m
//  GB_Football
//
//  Created by Pizza on 16/8/31.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBDailyRankViewController.h"
#import "GBSegmentView.h"
#import "GBDetialRankViewController.h"

@interface GBDailyRankViewController ()<GBSegmentViewDelegate>
@property (nonatomic,strong) GBSegmentView *segmentView;
// 本周排行
@property (nonatomic,strong) GBDetialRankViewController   *weekViewController;
// 本月排行
@property (nonatomic,strong) GBDetialRankViewController   *monthViewController;
//今日排行
@property (nonatomic,strong) GBDetialRankViewController   *dayViewController;
@end

@implementation GBDailyRankViewController

#pragma mark -
#pragma mark Memory

- (void)dealloc{
    
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark - Notification

#pragma mark - Delegate

#pragma mark - Action

#pragma mark - Private


- (void)GBSegmentView:(GBSegmentView*)segment toIndex:(NSInteger)index
{
    
}

- (void)GBSegmentView:(GBSegmentView*)segment toViewController:(PageViewController*)viewController
{
    [viewController initLoadData];
}

-(void)setupUI
{
    [self setupBackButtonWithBlock:nil];
    [self setupSegmentUI];
}

- (void)setupSegmentUI
{
    self.weekViewController              = [[GBDetialRankViewController alloc]initWithType:DailyRank_Week];
    self.monthViewController             = [[GBDetialRankViewController alloc]initWithType:DailyRank_Month];
    self.dayViewController             = [[GBDetialRankViewController alloc]initWithType:DailyRank_Day];
    CGRect rect = [UIScreen mainScreen].bounds;
    self.segmentView = [[GBSegmentView alloc]initWithFrame:CGRectMake(0,kUIScreen_NavigationBarHeight, rect.size.width,kUIScreen_AppContentHeight)
                                                 topHeight:54.f
                                           viewControllers:@[self.dayViewController,self.weekViewController,
                                                             self.monthViewController]
                                                    titles:@[LS(@"rank.tab.day"),LS(@"rank.tab.week"),LS(@"rank.tab.month")]
                                                  delegate:self];
    [self.view addSubview:self.segmentView];
    [self addChildViewController:self.weekViewController];
    [self addChildViewController:self.monthViewController];
    
    [self.segmentView goCurrentController:0];
}

-(void)loadData
{
    
}

#pragma mark - Getters & Setters

@end
