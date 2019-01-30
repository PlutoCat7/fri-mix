//
//  GBRecordDetailViewController.m
//  GB_Football
//
//  Created by Pizza on 16/8/23.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBRecordDetailViewController.h"
#import "GBFullGameViewController.h"
#import "GBHalfGameViewController.h"
#import "GBMenuViewController.h"
#import "GBEvaluationBoardViewController.h"
#import "GBAchievementViewController.h"
#import "GBTimeDivisionViewController.h"
#import "GBGamesStatisticsViewController.h"
#import "GBGameTracticsViewController.h"
#import "GBGamePhotosViewController.h"

#import "GBGameDetailHeaderView.h"
#import "GBSegmentView.h"

#import "MatchRequest.h"
#import "UMShareManager.h"


@interface GBRecordDetailViewController ()<GBSegmentViewDelegate>

// 分段栏控件
@property (nonatomic,strong) GBSegmentView *segmentView;
@property (weak, nonatomic) IBOutlet GBGameDetailHeaderView *headerView;
// segement图容器
@property (weak, nonatomic) IBOutlet UIView *segmentContentView;
// 全场比赛
@property (nonatomic,strong) GBFullGameViewController           *fullGameViewController;
// 半场比赛
@property (nonatomic,strong) GBHalfGameViewController           *halfGameViewController;
// 比赛评价
@property (nonatomic,strong) GBEvaluationBoardViewController    *evaluationViewController;
//多节数据
@property (nonatomic, strong) GBTimeDivisionViewController *timeDivisionViewController;
//统计界面
@property (nonatomic, strong) GBGamesStatisticsViewController *statisticsViewController;
//战术界面
@property (nonatomic, strong) GBGameTracticsViewController *tracticesViewController;
@property (nonatomic, strong) GBGamePhotosViewController *photosViewController;

@property (nonatomic, weak) GBBaseViewController *currentViewController;

@property (nonatomic, strong) MatchInfo *matchInfo;
// 如果没有设置球员默认是用户id
@property (nonatomic, assign) NSInteger playerId;

@end

@implementation GBRecordDetailViewController

#pragma mark -
#pragma mark Memory

- (void)dealloc{
    
}

- (instancetype)initWithMatchId:(NSInteger)matchId
{
    self = [super init];
    if (self) {
        _matchId = matchId;
    }
    return self;
}

- (instancetype)initWithMatchId:(NSInteger)matchId playerId:(NSInteger)playerId
{
    self = [super init];
    if (self) {
        _matchId = matchId;
        _playerId = playerId;
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMatchData];
}

- (void)viewWillAppear:(BOOL)animated{
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

#pragma mark - Analytics

- (NSString *)pageName {
    return Analy_Page_Record_Detail;
}

- (void)shareSuccess {
    [UMShareManager event:Analy_Click_Share_Record];
}

#pragma mark - Public

- (void)setMatchId:(NSInteger)matchId {
    
    _matchId = matchId;
}

- (void)reloadData {
    
    [self loadMatchData];
}

#pragma mark - Notification

#pragma mark - Delegate

- (void)GBSegmentView:(GBSegmentView*)segment toIndex:(NSInteger)index
{
    
}

- (void)GBSegmentView:(GBSegmentView*)segment toViewController:(PageViewController*)viewController
{
    if (viewController  == self.fullGameViewController) {
        [UMShareManager event:Analy_Click_Record_Full];
        
    } else if (viewController  == self.halfGameViewController) {
        [UMShareManager event:Analy_Click_Record_Half];
        
    } else if (viewController  == self.evaluationViewController) {
        [UMShareManager event:Analy_Click_Record_Analy];
        
    } else if (viewController  == self.timeDivisionViewController) {
        [UMShareManager event:Analy_Click_Record_Quart];
        
    } else if (viewController  == self.statisticsViewController) {
        [UMShareManager event:Analy_Click_Record_Stati];
        
    } else if (viewController  == self.tracticesViewController) {
        [UMShareManager event:Analy_Click_Record_Tactic];
        
    } else if (viewController  == self.photosViewController) {
        [UMShareManager event:Analy_Click_Record_Photo];
        
    }
    

    self.currentViewController = viewController;
    [viewController initLoadData];
    
    [self resetShareItem];
}

#pragma mark - Action

#pragma mark - Getter & Setter
- (NSInteger)playerId {
    return _playerId == 0 ? [RawCacheManager sharedRawCacheManager].userInfo.userId : _playerId;
}

#pragma mark - Private

- (void)setupUI
{
    [super setupUI];
    self.title = LS(@"gamedata.nav.title");
}

- (void)setupSegmentUI:(BOOL)showPhoto
{
    if (self.segmentView) {
        [self.segmentView removeFromSuperview];
    }
    NSMutableArray *vcList = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *titleList = [NSMutableArray arrayWithCapacity:1];
    if (self.matchInfo.gameType == GameType_Team || self.matchInfo.gameType == GameType_Standard){
        @weakify(self)
        self.fullGameViewController.didChangeHeatMapDirection = ^(BOOL direction) {
            @strongify(self)
            self.halfGameViewController.direction = direction;
        };
        self.fullGameViewController.didShowMapTimeRate = ^(BOOL show) {
            @strongify(self)
            self.halfGameViewController.showTimeRate = show;
        };
        [vcList addObject:self.fullGameViewController];
        [vcList addObject:self.halfGameViewController];
        [vcList addObject:self.evaluationViewController];
        
        [titleList addObject:LS(@"gamedata.tab.whole")];
        [titleList addObject:LS(@"gamedata.tab.half")];
        [titleList addObject:LS(@"gamedata.tab.analysis")];
        
        if (self.playerId == [RawCacheManager sharedRawCacheManager].userInfo.userId) {
            if (self.matchInfo.inviteUserCount>1) {
                [vcList addObject:self.statisticsViewController];
                [titleList addObject:LS(@"gamedata.tab.statistics")];
            }
            if (self.matchInfo.tracticsPlayers){
                [vcList addObject:self.tracticesViewController];
                [titleList addObject:LS(@".team.tractics.tractics")];
            }
        }
    }else {
        @weakify(self)
        self.fullGameViewController.didShowMapTimeRate = ^(BOOL show) {
            @strongify(self)
            self.timeDivisionViewController.showTimeRate = show;
        };
        
        [vcList addObject:self.fullGameViewController];
        [vcList addObject:self.timeDivisionViewController];
        
        [titleList addObject:LS(@"gamedata.tab.whole")];
        [titleList addObject:LS(@"multi-section.section.data")];
    }
    if (showPhoto) {
        [vcList addObject:self.photosViewController];
        [titleList addObject:LS(@"game.record.photos")];
    }
    
    GBSegmentStyle *segmentStyle = [[GBSegmentStyle alloc] init];
    segmentStyle.scrollTitle = YES;
    segmentStyle.highlightSelectTitle = YES;
    segmentStyle.titleFont = [UIFont systemFontOfSize:14.f];
    segmentStyle.highlightTitleFont = [UIFont systemFontOfSize:15.f];
    
    self.segmentView = [[GBSegmentView alloc]initWithFrame:self.segmentContentView.bounds
                                                 topHeight:40.f
                                           viewControllers:vcList
                                                    titles:titleList
                                              segmentStyle:segmentStyle
                                                  delegate:self];
    self.segmentView.backgroundColor = [UIColor blackColor];
    [self.segmentContentView addSubview:self.segmentView];
    
}

- (void)loadMatchData {
    
    [self showLoadingToast];
    @weakify(self)
    [MatchRequest getMatchData:self.matchId playerId:self.playerId handler:^(id result, NSError *error) {
        
        @strongify(self)
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            self.matchInfo = result;
            //查看是否有图片
            [MatchRequest getMatchData:self.matchId handler:^(id result, NSError *error) {
                [self dismissToast];
                NSArray *list = result;
                if (list.count>0) {
                    [self setupSegmentUI:YES];
                }else {
                    [self setupSegmentUI:NO];
                }
                [self refreshUI];
                [self requestTimedivisionData];
                if ([self.matchInfo shouldShowAchieveView] && self.playerId == [RawCacheManager sharedRawCacheManager].userInfo.userId) {
                    [self showArchieveView];
                }
            }];
            
        }
    }];
}

// 请求分时数据
-(void)requestTimedivisionData{
    @weakify(self);
    [MatchRequest getMatchTimeDivesionWithMatchId:self.matchId playerId:self.playerId handler:^(id result, NSError *error) {
        @strongify(self);
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            if (!result) {
                return;
            }
            MatchTimeDivisionResponseInfo  *div = result;
            [self.evaluationViewController drawWithChart:[div parse] matchInfo:self.matchInfo playerId:self.playerId];
        }
    }];
}

- (void)refreshUI {
    
    [self.headerView refreshWithMatchInfo:self.matchInfo];
    
    [_fullGameViewController refreshWithMatchInfo:self.matchInfo];
    [_halfGameViewController refreshWithMatchInfo:self.matchInfo];
    [_timeDivisionViewController refreshWithMatchInfo:self.matchInfo];
}

-(CGFloat)timePercent:(NSInteger)gameTime
{
    return gameTime>=90 ? 1.f : gameTime*1.0f/90;
}

- (void)showArchieveView {
    
    UserInfo *userInfo = [RawCacheManager sharedRawCacheManager].userInfo;
    GBAchievementViewController *vc = [[GBAchievementViewController alloc] initWithAchieve:self.matchInfo.achieve isShowShare:(self.playerId == userInfo.userId)];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Getters & Setters

- (GBFullGameViewController *)fullGameViewController {
    
    if (!_fullGameViewController) {
        _fullGameViewController    = [[GBFullGameViewController alloc]init];
        [self addChildViewController:_fullGameViewController];
    }
    
    return _fullGameViewController;
}

- (GBHalfGameViewController *)halfGameViewController {
    
    if (!_halfGameViewController) {
        _halfGameViewController    = [[GBHalfGameViewController alloc]init];
        [self addChildViewController:_halfGameViewController];
    }
    
    return _halfGameViewController;
}

- (GBEvaluationBoardViewController *)evaluationViewController {
    
    if (!_evaluationViewController) {
        _evaluationViewController    = [[GBEvaluationBoardViewController alloc]init];
        [self addChildViewController:_evaluationViewController];
    }
    
    return _evaluationViewController;
}

- (GBTimeDivisionViewController *)timeDivisionViewController {
    
    if (!_timeDivisionViewController) {
        _timeDivisionViewController    = [[GBTimeDivisionViewController alloc]init];
        [self addChildViewController:_timeDivisionViewController];
    }
    
    return _timeDivisionViewController;
}

- (GBGamesStatisticsViewController *)statisticsViewController {
    
    if (!_statisticsViewController) {
        _statisticsViewController = [[GBGamesStatisticsViewController alloc] initWithMatchId:self.matchId];
        [self addChildViewController:_statisticsViewController];
    }
    
    return _statisticsViewController;
}

- (GBGameTracticsViewController *)tracticesViewController {
    
    if (!_tracticesViewController) {
        _tracticesViewController = [[GBGameTracticsViewController alloc] initWithTracticsType:self.matchInfo.tracticsType players:self.matchInfo.tracticsPlayers];
    }
    
    return _tracticesViewController;
}

- (GBGamePhotosViewController *)photosViewController {
    
    if (!_photosViewController) {
        _photosViewController = [[GBGamePhotosViewController alloc] initWithMatchId:self.matchId];
        [self addChildViewController:_photosViewController];
    }
    return _photosViewController;
}

#pragma mark - 分享功能

- (BOOL)showShareItem {
    
    if (self.playerId != [RawCacheManager sharedRawCacheManager].userInfo.userId) {
        return NO;
    }
    if (_currentViewController == self.photosViewController) {
        return NO;
    }
    return YES;
}

- (UIImage *)shareImage {
    
    return [_currentViewController getViewShareImage];
}

- (CGRect)preScreenShotRect {
    
    return CGRectMake(0, 0, self.view.width, 64+48+40);
}

@end
