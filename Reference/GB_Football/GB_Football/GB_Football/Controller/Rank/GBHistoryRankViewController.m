//
//  GBHistoryRankViewController.m
//  GB_Football
//
//  Created by Pizza on 16/8/31.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBHistoryRankViewController.h"
#import "GBSegmentView.h"
#import "GBDetialRankViewController.h"

@interface GBHistoryRankViewController ()<GBSegmentViewDelegate>
@property (nonatomic,strong) GBSegmentView *segmentView;
@property (nonatomic,strong) GBDetialRankViewController   *moveDistanceViewController;
@property (nonatomic,strong) GBDetialRankViewController   *avarageSpeedViewController;
@property (nonatomic,strong) GBDetialRankViewController   *highestSpeedViewController;
@end

@implementation GBHistoryRankViewController

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
    if (viewController  == self.moveDistanceViewController) {
        [UMShareManager event:Analy_Click_Rank_Dist];
        
    } else if (viewController  == self.avarageSpeedViewController) {
        [UMShareManager event:Analy_Click_Rank_Avge];
        
    } else if (viewController  == self.highestSpeedViewController) {
        [UMShareManager event:Analy_Click_Rank_Max];
        
    }
    
    [viewController initLoadData];
}

-(void)setupUI
{
    [self setupBackButtonWithBlock:nil];
    [self setupSegmentUI];
}

- (void)setupSegmentUI
{
    self.moveDistanceViewController             = [[GBDetialRankViewController alloc]initWithType:DailyRank_History_Distance];
    self.avarageSpeedViewController             = [[GBDetialRankViewController alloc]initWithType:DailyRank_History_AvgSpeed];
    self.highestSpeedViewController             = [[GBDetialRankViewController alloc]initWithType:DailyRank_History_MaxSpeed];
    CGRect rect = [UIScreen mainScreen].bounds;
    self.segmentView = [[GBSegmentView alloc]initWithFrame:CGRectMake(0,kUIScreen_NavigationBarHeight, rect.size.width,kUIScreen_AppContentHeight)
                                                 topHeight:54.f
                                           viewControllers:@[self.moveDistanceViewController,
                                                             self.avarageSpeedViewController,
                                                             self.highestSpeedViewController]
                                                    titles:@[LS(@"rank.tab.moving"),LS(@"rank.tab.average"),LS(@"rank.tab.fastest")]
                                                  delegate:self];
    [self.view addSubview:self.segmentView];
    [self addChildViewController:self.moveDistanceViewController];
    [self addChildViewController:self.avarageSpeedViewController];
    [self addChildViewController:self.highestSpeedViewController];
    
}

-(void)loadData
{
    
}


#pragma mark - Getters & Setters

@end
