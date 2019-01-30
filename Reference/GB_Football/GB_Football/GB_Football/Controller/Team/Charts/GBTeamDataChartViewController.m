//
//  GBTeamDataChartViewController.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/21.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBTeamDataChartViewController.h"
#import "GBLine1ChartsViewController.h"
#import "GBPie1ChartViewController.h"
#import "GBBar1ChartViewController.h"
#import "GBPie2ChartViewController.h"
#import "GBPie3ChartViewController.h"
#import "GBLine2ChartsViewController.h"
#import "GBBar2ChartViewController.h"
#import "GBCircleChartViewController.h"
#import "GBTeamDataViewController.h"

#import "TeamDataShareHeaderView.h"
#import "TeamDataNoDataView.h"
#import "MJRefresh.h"

#import "GBTeamDataChartViewModel.h"

@interface GBTeamDataChartViewController ()

@property (nonatomic, strong) TeamDataShareHeaderView *shareHeaderView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, strong) GBLine1ChartsViewController *line1ChartViewController;
@property (nonatomic, strong) GBPie1ChartViewController *screeningsVC;   //场次
@property (nonatomic, strong) GBPie3ChartViewController *areaVC;   //覆盖面积
@property (nonatomic, strong) GBBar1ChartViewController *sprintVC;   //场次
@property (nonatomic, strong) GBPie2ChartViewController *explosiveForceVC;   //爆发力

@property (nonatomic, strong) GBLine2ChartsViewController *enduranceVC;  //耐力
@property (nonatomic, strong) GBBar2ChartViewController *maxSpeedVC;

@property (nonatomic, strong) GBCircleChartViewController *distanceVC; //跑到距离

@property (nonatomic, strong) GBTeamDataChartViewModel *viewModel;

@end

@implementation GBTeamDataChartViewController

- (instancetype)initWithTeamInfo:(TeamInfo *)teamInfo {

    self = [super init];
    if (self) {
        _viewModel = [[GBTeamDataChartViewModel alloc] initWithTeamInfo:teamInfo];
    }
    return self;
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    self.shareHeaderView.frame = CGRectMake(0, kUIScreen_NavigationBarHeight, self.view.width, 103*kAppScale);
}

#pragma mark - Analytics

- (NSString *)pageName {
    return Analy_Page_Team_Data;
}

- (void)shareSuccess {
    [UMShareManager event:Analy_Click_Share_TeamData];
}

#pragma mark - OverWrite

- (BOOL)showShareItem {
    
    return self.viewModel.isHasTeamData;
}

- (BOOL)shareWithNavigationBarImage {
    
    return NO;
}

- (UIImage *)shareImage {
    
    UIScrollView *scrollView =  self.contentScrollView;
    scrollView.autoresizesSubviews = NO;
    CGFloat oldheight = scrollView.height;
    CGPoint oldContentOffset = scrollView.contentOffset;
    
    scrollView.height = scrollView.contentSize.height>oldheight?scrollView.contentSize.height:oldheight;
    scrollView.contentOffset = CGPointMake(0, 0);
    UIImage *shareImage = [LogicManager getImageWithHeadImage:nil subviews:@[self.shareHeaderView, scrollView] backgroundImage:[UIImage imageWithColor:[UIColor blackColor]]];
    
    scrollView.height = oldheight;
    scrollView.contentOffset = oldContentOffset;
    scrollView.autoresizesSubviews = YES;
    
    return shareImage;
}

- (void)shareViewWillShow {
    
    self.contentScrollView.contentOffset = CGPointMake(0, 0);
    [UIView animateWithDuration:0.25 animations:^{
        self.contentScrollView.top = self.shareHeaderView.height;
        self.shareHeaderView.alpha = 1.0f;
    }];
}

- (void)shareViewWillHide {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.contentScrollView.top = 0;
        self.shareHeaderView.alpha = 0.0f;
    }];
}

#pragma mark - Private

- (void)loadData {
    
    [self showLoadingToast];
    [self.viewModel getTeamDataWithHandler:^(NSError *error) {
        
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            [self refreshUI];
            [self resetShareItem];
        }
    }];
    
}

- (void)setupUI {
    
    [super setupUI];
    self.title = LS(@"team.data.team.data");
    [self setupBackButtonWithBlock:nil];
    
    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self.viewModel getTeamDataWithHandler:^(NSError *error) {
            [self.contentScrollView.mj_header endRefreshing];
            if (error) {
                [self showToastWithText:error.domain];
            }else {
                [self refreshUI];
                [self resetShareItem];
            }
        }];
    }];
    mj_header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.contentScrollView.mj_header = mj_header;
    [self.shareHeaderView refreshUI:self.viewModel.teamInfo];
}

- (void)refreshUI {
    
    CGFloat top = 0;
    CGFloat width = kUIScreen_Width;
    CGFloat height = 178*kAppScale;
    self.line1ChartViewController = [[GBLine1ChartsViewController alloc] initWithScoreList:[self.viewModel getScoreList]];
    self.line1ChartViewController.view.frame = CGRectMake(0, top, width, height);
    [self.contentScrollView addSubview:self.line1ChartViewController.view];
    [self addChildViewController:self.line1ChartViewController];
    
    if (!self.viewModel.isHasTeamData) {//添加空视图
        top += height;
        height = 40*kAppScale;
        TeamDataNoDataView *tipsView =  [[NSBundle mainBundle]loadNibNamed:@"TeamDataNoDataView" owner:nil options:nil].firstObject;
        tipsView.frame = CGRectMake(0, top, width, height);
        [self.contentScrollView addSubview:tipsView];
    }
    
    CGFloat spacing = 30*kAppScale;
    top += height + spacing;
    height = 240*kAppScale;
    self.screeningsVC = [[GBPie1ChartViewController alloc] initWithChartModelList:[self.viewModel getGameCountRankList]];
    @weakify(self)
    self.screeningsVC.actionMoreBlock = ^{
        @strongify(self)
        [self pushDetailVCWithRankType:GameRankType_Count];
    };
    self.screeningsVC.view.frame = CGRectMake(0, top, width, height);
    [self.screeningsVC.topView refreshUIWith:1 text:LS(@"team.data.team.label.count") detailText:[self.viewModel gameCountRankDesc]];
    [self.contentScrollView addSubview:self.screeningsVC.view];
    [self addChildViewController:self.screeningsVC];
    
    spacing = 10*kAppScale;
    top += height + spacing;
    height = 250*kAppScale;
    self.sprintVC = [[GBBar1ChartViewController alloc] initWithChartModelList:[self.viewModel getSprintRankList]];
    self.sprintVC.view.frame = CGRectMake(0, top, width, height);
    [self.sprintVC.topView refreshUIWith:2 text:LS(@"team.data.team.label.sprint") detailText:[self.viewModel sprintRankDesc]];
    [self.contentScrollView addSubview:self.sprintVC.view];
    [self addChildViewController:self.sprintVC];
    self.sprintVC.actionMoreBlock = ^{
        @strongify(self)
        [self pushDetailVCWithRankType:GameRankType_Sprint];
    };
    
    spacing = 30*kAppScale;
    top += height + spacing;
    height = 265*kAppScale;
    self.explosiveForceVC = [[GBPie2ChartViewController alloc] initWithChartModelList:[self.viewModel getEruptRankList]];
    self.explosiveForceVC.view.frame = CGRectMake(0, top, width, height);
    [self.explosiveForceVC.topView refreshUIWith:3 text:LS(@"team.data.team.label.erupt") detailText:[self.viewModel eruptRankDesc]];
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
    [self.enduranceVC.topView refreshUIWith:4 text:LS(@"team.data.team.label.endur") detailText:[self.viewModel endurRankDesc]];
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
    [self.areaVC.topView refreshUIWith:5 text:LS(@"team.data.team.label.area") detailText:[self.viewModel coverAreaRankDesc]];
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
    [self.maxSpeedVC.topView refreshUIWith:6 text:LS(@"team.data.team.label.maxspeed") detailText:[self.viewModel maxSpeedRankDesc]];
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
    [self.distanceVC.topView refreshUIWith:7 text:LS(@"team.data.team.label.distance") detailText:[self.viewModel distanceRankDesc]];
    [self.contentScrollView addSubview:self.distanceVC.view];
    [self addChildViewController:self.distanceVC];
    self.distanceVC.actionMoreBlock = ^{
        @strongify(self)
        [self pushDetailVCWithRankType:GameRankType_Distance];
    };
    
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.width, top+height+20);
    
    
    if (!self.viewModel.isHasTeamData) { //隐藏更多按钮
        [self.screeningsVC.topView hideMoreButton];
        [self.sprintVC.topView hideMoreButton];
        [self.explosiveForceVC.topView hideMoreButton];
        [self.enduranceVC.topView hideMoreButton];
        [self.maxSpeedVC.topView hideMoreButton];
        [self.distanceVC.topView hideMoreButton];
        [self.areaVC.topView hideMoreButton];
    }
}

- (void)pushDetailVCWithRankType:(GBGameRankType)type {
    
    GBTeamDataViewController *vc = [[GBTeamDataViewController alloc] initWithPlayerList:self.viewModel.playersInfo type:type];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Setter and Getter  

- (TeamDataShareHeaderView *)shareHeaderView {
    
    if (!_shareHeaderView) {
        _shareHeaderView =  [[NSBundle mainBundle]loadNibNamed:@"TeamDataShareHeaderView" owner:nil options:nil].firstObject;
        _shareHeaderView.alpha = 0;
        [self.view insertSubview:_shareHeaderView belowSubview:self.contentScrollView];
    }

    return _shareHeaderView;
}

@end
