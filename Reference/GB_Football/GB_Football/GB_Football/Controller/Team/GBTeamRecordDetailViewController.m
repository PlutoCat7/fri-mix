//
//  GBTeamRecordDetailViewController.m
//  GB_Football
//
//  Created by gxd on 17/8/4.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBTeamRecordDetailViewController.h"
#import "GBTeamDataListViewController.h"
#import "GBMenuViewController.h"

#import "GBSegmentView.h"

#import "GBTeamRecordDetailViewModel.h"

@interface GBTeamRecordDetailViewController ()<GBSegmentViewDelegate>

@property (nonatomic, assign) NSInteger matchId;
@property (nonatomic, strong) NSArray<TeamDataPlayerInfo *> *recordList;
@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic,strong) GBSegmentView *segmentView;
@property (nonatomic,strong) GBTeamDataListViewController *currentViewController;

@property (nonatomic, strong) GBTeamRecordDetailViewModel *viewModel;

@end

@implementation GBTeamRecordDetailViewController

- (instancetype)initWithMatchId:(NSInteger)matchId {
    if (self = [super init]) {
        _pageIndex = 0;
        _viewModel = [[GBTeamRecordDetailViewModel alloc] initWithPlayerList:nil];
        _viewModel.matchId = matchId;
    }
    
    return self;
}

- (instancetype)initWithPlayerList:(NSArray<TeamDataPlayerInfo *> *)playerList type:(GBGameRankType)rankType  matchId:(NSInteger)matchId {
    if (self = [super init]) {
        _recordList = playerList;
        switch (rankType) {
            case GameRankType_Sprint:
                _pageIndex = 0;
                break;
                
            case GameRankType_Erupt:
                _pageIndex = 1;
                break;
                
            case GameRankType_Endur:
                _pageIndex = 2;
                break;
            case GameRankType_Area:
                _pageIndex = 3;
                break;
                
            case GameRankType_MaxSpeed:
                _pageIndex = 4;
                break;
                
            case GameRankType_Distance:
                _pageIndex = 5;
                break;
                
            default:
                break;
        }
        _viewModel = [[GBTeamRecordDetailViewModel alloc] initWithPlayerList:playerList];
        _viewModel.matchId = matchId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if ([self.navigationController.topViewController isMemberOfClass:[GBMenuViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
}

#pragma mark - Delegate
- (void)GBSegmentView:(GBSegmentView*)segment toIndex:(NSInteger)index
{
    
}

- (void)GBSegmentView:(GBSegmentView*)segment toViewController:(PageViewController*)viewController
{
    self.currentViewController = (GBTeamDataListViewController *) viewController;
    [viewController initLoadData];
    
    if (!self.currentViewController.model) {
        self.currentViewController.model = [self.viewModel teamDataListModelWithType:self.currentViewController.rankType];
    }
}

#pragma mark - Private
-(void)setupUI {
    self.title = LS(@"team.record.detail.nav.title");
    [self setupBackButtonWithBlock:nil];
    [self setupSegmentUI];
}

- (void)setupSegmentUI {
    
    NSArray *titles = @[LS(@"team.data.label.sprint"),
                        LS(@"team.data.label.erupt"),
                        LS(@"team.data.label.endur"),
                        LS(@"team.data.label.area"),
                        LS(@"team.data.label.maxspeed"),
                        LS(@"team.data.label.distance")];
    NSArray *controllers = @[[[GBTeamDataListViewController alloc] initWithType:GameRankType_Sprint],
                             [[GBTeamDataListViewController alloc] initWithType:GameRankType_Erupt],
                             [[GBTeamDataListViewController alloc] initWithType:GameRankType_Endur],
                             [[GBTeamDataListViewController alloc] initWithType:GameRankType_Area],
                             [[GBTeamDataListViewController alloc] initWithType:GameRankType_MaxSpeed],
                             [[GBTeamDataListViewController alloc] initWithType:GameRankType_Distance]];
    
    CGRect rect = [UIScreen mainScreen].bounds;
    GBSegmentStyle *segmentStyle = [[GBSegmentStyle alloc] init];
    segmentStyle.scrollTitle = YES;
    segmentStyle.highlightSelectTitle = YES;
    segmentStyle.titleFont = [UIFont systemFontOfSize:14.f];
    segmentStyle.highlightTitleFont = [UIFont systemFontOfSize:15.f];
    
    self.segmentView = [[GBSegmentView alloc]initWithFrame:CGRectMake(0,kUIScreen_NavigationBarHeight, rect.size.width,kUIScreen_AppContentHeight)
                                                 topHeight:68.f
                                           viewControllers:controllers
                                                    titles:titles
                                              segmentStyle:segmentStyle
                                                  delegate:self];
    
    [self.view addSubview:self.segmentView];
    for (GBTeamDataListViewController *viewController in controllers) {
        viewController.model = [self.viewModel teamDataListModelWithType:viewController.rankType];
        [self addChildViewController:viewController];
    }
    
    [self.segmentView goCurrentController:self.pageIndex];
}

- (void)loadNetworkData {
    
    if (self.viewModel.isNeedLoadNetWorkData) {
        [self showLoadingToast];
        [self.viewModel getRankInfo:^(NSError *error) {
            [self dismissToast];
            if (error) {
                [self showToastWithText:error.domain];
            }else {
                if (self.currentViewController) {
                    self.currentViewController.model = [self.viewModel teamDataListModelWithType:self.currentViewController.rankType];
                }
            }
        }];
    }
}


@end
