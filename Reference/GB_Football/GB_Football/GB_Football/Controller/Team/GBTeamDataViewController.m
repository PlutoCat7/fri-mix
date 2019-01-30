//
//  GBTeamDataViewController.m
//  GB_Football
//
//  Created by gxd on 17/7/20.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBTeamDataViewController.h"
#import "GBTeamDataListViewController.h"

#import "GBSegmentView.h"
#import "GBTeamDataListViewModel.h"

@interface GBTeamDataViewController ()<GBSegmentViewDelegate>

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) GBSegmentView *segmentView;
@property (nonatomic, strong) GBTeamDataListViewController *currentViewController;

@property (nonatomic, strong) GBTeamDataListViewModel *viewModel;

@end

@implementation GBTeamDataViewController

- (instancetype)initWithPlayerList:(NSArray<TeamDataPlayerInfo *> *)playerList type:(GBGameRankType)rankType {
    if (self = [super init]) {
        _viewModel = [[GBTeamDataListViewModel alloc] initWithPlayerList:playerList];
        switch (rankType) {
            case GameRankType_Count:
                _pageIndex = 0;
                break;
                
            case GameRankType_Sprint:
                _pageIndex = 1;
                break;
                
            case GameRankType_Erupt:
                _pageIndex = 2;
                break;
                
            case GameRankType_Endur:
                _pageIndex = 3;
                break;
            case GameRankType_Area:
                _pageIndex = 4;
                break;
                
            case GameRankType_MaxSpeed:
                _pageIndex = 5;
                break;
                
            case GameRankType_Distance:
                _pageIndex = 6;
                break;
                
            default:
                break;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - Delegate
- (void)GBSegmentView:(GBSegmentView*)segment toIndex:(NSInteger)index
{
    
}

- (void)GBSegmentView:(GBSegmentView*)segment toViewController:(PageViewController*)viewController
{
    [viewController initLoadData];
}

#pragma mark - Private
-(void)setupUI
{
    self.title = LS(@"team.record.detail.nav.title");
    [self setupBackButtonWithBlock:nil];
    [self setupSegmentUI];
}

- (void)setupSegmentUI {
    
    NSArray *titles = @[LS(@"team.data.team.label.count"),
                        LS(@"team.data.team.label.sprint"),
                        LS(@"team.data.team.label.erupt"),
                        LS(@"team.data.team.label.endur"),
                        LS(@"team.data.team.label.area"),
                        LS(@"team.data.team.label.maxspeed"),
                        LS(@"team.data.team.label.distance")];
    NSArray *controllers = @[[[GBTeamDataListViewController alloc] initWithType:GameRankType_Count],
                             [[GBTeamDataListViewController alloc] initWithType:GameRankType_Sprint],
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
                                                 topHeight:54.f
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

-(void)loadData
{
    
}

@end
