//
//  GBGamesStatisticsViewController.m
//  GB_Football
//
//  Created by 王时温 on 2017/8/7.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBGamesStatisticsViewController.h"
#import "GBBar1ChartViewController.h"
#import "GBPie2ChartViewController.h"
#import "GBPie3ChartViewController.h"
#import "GBLine2ChartsViewController.h"
#import "GBBar2ChartViewController.h"
#import "GBCircleChartViewController.h"
#import "GBTeamRecordDetailViewController.h"

#import "GBGameStatistucsViewModel.h"

@interface GBGamesStatisticsViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@property (nonatomic, strong) GBBar1ChartViewController *sprintVC;   //冲刺次数
@property (nonatomic, strong) GBPie2ChartViewController *explosiveForceVC;   //爆发力

@property (nonatomic, strong) GBLine2ChartsViewController *enduranceVC;  //耐力

@property (nonatomic, strong) GBPie3ChartViewController *areaVC;  //覆盖面积
@property (nonatomic, strong) GBBar2ChartViewController *maxSpeedVC;

@property (nonatomic, strong) GBCircleChartViewController *distanceVC; //跑到距离

@property (nonatomic, strong) GBGameStatistucsViewModel *viewModel;

@end

@implementation GBGamesStatisticsViewController

- (instancetype)initWithMatchId:(NSInteger)matchId {
    
    self = [super init];
    if (self) {
        _viewModel = [[GBGameStatistucsViewModel alloc] initWithMatchId:matchId];
    }
    
    return self;
}

- (void)initPageData {
    
    [self showLoadingToast];
    [self.viewModel getDataWithHandler:^(NSError *error) {
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            [self refreshUI];
        }
    }];
}

- (UIImage *)getViewShareImage {
    
    UIScrollView *scrollView =  self.contentScrollView;
    if (!scrollView) {
        return nil;
    }
    scrollView.autoresizesSubviews = NO;
    CGFloat oldheight = scrollView.height;
    CGPoint oldContentOffset = scrollView.contentOffset;
    
    scrollView.height = fmaxf(scrollView.contentSize.height, oldheight);
    scrollView.contentOffset = CGPointMake(0, 0);
    UIImage *shareImage = [LogicManager getImageWithHeadImage:nil subviews:@[scrollView] backgroundImage:[UIImage imageWithColor:[UIColor blackColor]]];
    
    scrollView.height = oldheight;
    scrollView.contentOffset = oldContentOffset;
    scrollView.autoresizesSubviews = YES;
    
    return shareImage;
}

- (void)refreshUI {
    
    CGFloat width = kUIScreen_Width;
    CGFloat spacing = 0;
    CGFloat top = 20*kAppScale;
    CGFloat height = 250*kAppScale;
    self.sprintVC = [[GBBar1ChartViewController alloc] initWithChartModelList:[self.viewModel getSprintRankList]];
    self.sprintVC.view.frame = CGRectMake(0, top, width, height);
    [self.sprintVC.topView refreshUIWith:1 text:LS(@"team.data.label.sprint")  detailText:[self.viewModel sprintRankDesc]];
    [self.contentScrollView addSubview:self.sprintVC.view];
    [self addChildViewController:self.sprintVC];
    @weakify(self)
    self.sprintVC.actionMoreBlock = ^{
        @strongify(self)
        [self pushDetailVCWithRankType:GameRankType_Sprint];
    };
    
    spacing = 30*kAppScale;
    top += height + spacing;
    height = 265*kAppScale;
    self.explosiveForceVC = [[GBPie2ChartViewController alloc] initWithChartModelList:[self.viewModel getEruptRankList]];
    self.explosiveForceVC.view.frame = CGRectMake(0, top, width, height);
    [self.explosiveForceVC.topView refreshUIWith:2 text:LS(@"team.data.label.erupt")  detailText:[self.viewModel eruptRankDesc]];
    [self.contentScrollView addSubview:self.explosiveForceVC.view];
    [self addChildViewController:self.explosiveForceVC];
    self.explosiveForceVC.actionMoreBlock = ^{
        @strongify(self)
        [self pushDetailVCWithRankType:GameRankType_Erupt];
    };
    
    spacing = 30*kAppScale;
    top += height + spacing;
    height = 250*kAppScale;
    self.enduranceVC = [[GBLine2ChartsViewController alloc] initWithChartModelList:[self.viewModel getEndurRankList]];
    self.enduranceVC.view.frame = CGRectMake(0, top, width, height);
    [self.enduranceVC.topView refreshUIWith:3 text:LS(@"team.data.label.endur")  detailText:[self.viewModel endurRankDesc]];
    [self.contentScrollView addSubview:self.enduranceVC.view];
    [self addChildViewController:self.enduranceVC];
    self.enduranceVC.actionMoreBlock = ^{
        @strongify(self)
        [self pushDetailVCWithRankType:GameRankType_Endur];
    };
    
    spacing = 20*kAppScale;
    top += height + spacing;
    height = 260*kAppScale;
    self.areaVC = [[GBPie3ChartViewController alloc] initWithChartModelList:[self.viewModel getAreaRankList]];
    self.areaVC.view.frame = CGRectMake(0, top, width, height);
    [self.areaVC.topView refreshUIWith:4 text:LS(@"team.data.label.area") detailText:[self.viewModel coverAreaRankDesc]];
    [self.contentScrollView addSubview:self.areaVC.view];
    [self addChildViewController:self.areaVC];
    self.areaVC.actionMoreBlock = ^{
        @strongify(self)
        [self pushDetailVCWithRankType:GameRankType_Area];
    };
    
    spacing = 20*kAppScale;
    top += height + spacing;
    height = 265*kAppScale;
    self.maxSpeedVC = [[GBBar2ChartViewController alloc] initWithChartModelList:[self.viewModel getMaxSpeedRankList]];
    self.maxSpeedVC.view.frame = CGRectMake(0, top, width, height);
    [self.maxSpeedVC.topView refreshUIWith:5 text:LS(@"team.data.label.maxspeed") detailText:[self.viewModel maxSpeedRankDesc]];
    [self.contentScrollView addSubview:self.maxSpeedVC.view];
    [self addChildViewController:self.maxSpeedVC];
    self.maxSpeedVC.actionMoreBlock = ^{
        @strongify(self)
        [self pushDetailVCWithRankType:GameRankType_MaxSpeed];
    };
    
    spacing = 5*kAppScale;
    top += height + spacing;
    height = 325*kAppScale;
    self.distanceVC = [[GBCircleChartViewController alloc] initWithChartModelList:[self.viewModel getDisTanceRankList]];
    self.distanceVC.view.frame = CGRectMake(0, top, width, height);
    
    [self.distanceVC.topView refreshUIWith:6 text:LS(@"team.data.label.distance")  detailText:[self.viewModel distanceRankDesc]];
    [self.contentScrollView addSubview:self.distanceVC.view];
    [self addChildViewController:self.distanceVC];
    self.distanceVC.actionMoreBlock = ^{
        @strongify(self)
        [self pushDetailVCWithRankType:GameRankType_Distance];
    };
    
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.width, top+height+spacing);
}

- (void)pushDetailVCWithRankType:(GBGameRankType)type {
    
    GBTeamRecordDetailViewController *vc = [[GBTeamRecordDetailViewController alloc] initWithPlayerList:self.viewModel.team_data type:type matchId:self.viewModel.matchId];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
