//
//  GBDetialRankViewController.m
//  GB_Football
//
//  Created by Pizza on 16/8/31.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBDetialRankViewController.h"
#import "GBPersonDefaultCardViewController.h"
#import "GBRankCell.h"
#import "GBPositionLabel.h"
#import "UIImageView+WebCache.h"
#import "GBBaseViewController+Empty.h"

#import "UserRequest.h"

@interface GBDetialRankViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerVIew;
// 左侧栏标题：移动距离，平均距离
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
// 左侧栏单位 km m/s
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
// 左侧栏 值
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
// 右侧排行名次
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
// 用户的名称
@property (weak, nonatomic) IBOutlet UILabel *playerName;
// 用户头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
// 位置1
@property (weak, nonatomic) IBOutlet GBPositionLabel *positionLabel1;
// 本轮排行
@property (weak, nonatomic) IBOutlet UILabel *turnStLabel;
@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, assign) GBDetialRankType rankType;
@property (nonatomic, strong) NSArray<MatchRankInfo *> *matchRankInfoList;
@property (nonatomic, strong) NSArray<HistoryRankInfo *> *historyRankInfoList;
@property (nonatomic, strong) NSArray<DailyRankInfo *> *dailyRankInfoList;
@property (nonatomic, assign) NSInteger controllerType;     //0 本轮  1历史   2日常
@property (weak, nonatomic) IBOutlet UILabel *rankStLabel;

@end

@implementation GBDetialRankViewController

#pragma mark -
#pragma mark Memory

- (instancetype)initWithType:(GBDetialRankType)type
{
    self = [super init];
    if (self) {
        _rankType = type;
        switch (type) {
            case DailyRank_This_Distance:
            case DailyRank_This_AvgSpeed:
            case DailyRank_This_MaxSpeed:
                _controllerType = 0;
                break;
            case DailyRank_History_Distance:
            case DailyRank_History_AvgSpeed:
            case DailyRank_History_MaxSpeed:
                _controllerType = 1;
                break;
            case DailyRank_Week:
            case DailyRank_Month:
            case DailyRank_Day:
                _controllerType = 2;
                break;
            default:
                break;
        }
    }
    return self;
}

- (void)dealloc{
    
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    self.headImageView.clipsToBounds = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.headImageView.layer setCornerRadius:self.headImageView.width/2];
        [self.headImageView.layer setMasksToBounds:YES];
    });
    self.headerVIew.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,
                                       (182.0f*2/1334)*[UIScreen mainScreen].bounds.size.height);
    [self.tableView setTableHeaderView:self.headerVIew];
}


#pragma mark - Notification

#pragma mark - Delegate

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.controllerType) {
        case 0:
            return self.matchRankInfoList.count;
            break;
        case 1:
            return self.historyRankInfoList.count;
            break;
        case 2:
            return self.dailyRankInfoList.count;
            break;
            
        default:
            return 0;
            break;
    }
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *playerImageUrl = @"";
    NSString *playerName = @"";
    NSString *unitName = [self unitName];
    NSString *valueName = @"";
    NSInteger userId = 0;
    switch (self.controllerType) {
        case 0:
        {
            MatchRankInfo *rankInfo = self.matchRankInfoList[indexPath.row];
            playerImageUrl = rankInfo.photoImageUrl;
            playerName = rankInfo.nickName;
            userId = rankInfo.userId;
            if (self.rankType == DailyRank_This_Distance) {
                valueName = [Utility float2NSString:rankInfo.distance/1000];
            }else if (self.rankType == DailyRank_This_AvgSpeed) {
                valueName = [NSString stringWithFormat:@"%.1f", rankInfo.avgSpeed];
            }else {
                valueName = [NSString stringWithFormat:@"%.1f", rankInfo.maxSpeed];
            }
        }
            break;
        case 1:
        {
            HistoryRankInfo *rankInfo = self.historyRankInfoList[indexPath.row];
            playerImageUrl = rankInfo.photoImageUrl;
            playerName = rankInfo.nickName;
            userId = rankInfo.userId;
            if (self.rankType == DailyRank_History_Distance) {
                valueName = [Utility float2NSString:rankInfo.distance/1000];
            }else if (self.rankType == DailyRank_History_AvgSpeed) {
                valueName = [NSString stringWithFormat:@"%.1f", rankInfo.avgSpeed];
            }else {
                valueName = [NSString stringWithFormat:@"%.1f", rankInfo.maxSpeed];
            }
        }
            break;
        case 2:
        {
            DailyRankInfo *rankInfo = self.dailyRankInfoList[indexPath.row];
            playerImageUrl = rankInfo.photoImageUrl;
            playerName = rankInfo.nickName;
            userId = rankInfo.userId;
            valueName = @(rankInfo.stepNumber).stringValue;
        }
            break;
            
        default:
            break;
    }
    
    GBRankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBRankCell"];
    cell.rankLabel.text = @(indexPath.row+1).stringValue;
    cell.playerNameLabel.text = playerName;
    cell.unitLabel.text = unitName;
    cell.valueLabel.text = valueName;
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:playerImageUrl] placeholderImage:[UIImage imageNamed:@"portrait"]];
    
    cell.rankStyle = RANK_NORMAL;
    if (self.userInfo.userId == userId) {
        cell.rankStyle = RANK_SELF;
        cell.isSelf    = YES;
    }
    else
    {
        cell.isSelf    = NO;
    }
    switch (indexPath.row)
    {
        // 前三名
        case 0:
            cell.rankStyle = RANK_1;
            break;
        case 1:
            cell.rankStyle = RANK_2;
            break;
        case 2:
            cell.rankStyle = RANK_3;
            break;
        default:
            
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GBPersonDefaultCardViewController *vc = [[GBPersonDefaultCardViewController alloc] init];
    NSInteger userId = 0;
    switch (self.controllerType) {
        case 0:
        {
            MatchRankInfo *rankInfo = self.matchRankInfoList[indexPath.row];
            userId = rankInfo.userId;
        }
            break;
        case 1:
        {
            HistoryRankInfo *rankInfo = self.historyRankInfoList[indexPath.row];
            userId = rankInfo.userId;
        }
            break;
        case 2:
        {
            DailyRankInfo *rankInfo = self.dailyRankInfoList[indexPath.row];
            userId = rankInfo.userId;
        }
            break;
            
        default:
            break;
    }

    vc.userId = userId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark EmptyView Delegate

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    return 50.0f;
}

#pragma mark - Action

#pragma mark - Private

-(void)setupUI
{
    self.userInfo = [RawCacheManager sharedRawCacheManager].userInfo;
    [self setupTableView];
    [self setupLabel];
}

-(void)localizeUI
{
    self.rankStLabel.text = LS(@"rank.sub.rank");
}

-(void)setupLabel
{
    self.titleLabel.text = [self titleName];
    self.unitLabel.text = [self unitName];
    self.turnStLabel.text = [self rankTitleName];
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.userInfo.imageUrl] placeholderImage:[UIImage imageNamed:@"portrait"]];
    self.playerName.text = self.userInfo.nick;
    NSArray *positionList = [self.userInfo.position componentsSeparatedByString:@","];
    self.positionLabel1.index = [positionList.firstObject integerValue];
}

-(void)setupTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"GBRankCell" bundle:nil] forCellReuseIdentifier:@"GBRankCell"];
    self.tableView.tableHeaderView = self.headerVIew;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.emptyScrollView = self.tableView;
    self.tableView.emptyDataSetDelegate = self;
}

- (void)refreshUI {
    
    [self.tableView reloadData];
    NSString *valueName = @"0";
    NSInteger rankIndex = 0;
    switch (self.controllerType) {
        case 0:
        {
            for (NSInteger index=0; index<self.matchRankInfoList.count; index++) {
                 MatchRankInfo *rankInfo = self.matchRankInfoList[index];
                if (rankInfo.userId == self.userInfo.userId) {
                    if (self.rankType == DailyRank_This_Distance) {
                        valueName = [Utility float2NSString:rankInfo.distance/1000];
                    }else if (self.rankType == DailyRank_This_AvgSpeed) {
                        valueName = [NSString stringWithFormat:@"%.1f", rankInfo.avgSpeed];
                    }else {
                        valueName = [NSString stringWithFormat:@"%.1f", rankInfo.maxSpeed];
                    }
                    rankIndex = index+1;
                    break;
                }
            }
        }
            break;
        case 1:
        {
            for (NSInteger index=0; index<self.historyRankInfoList.count; index++) {
                HistoryRankInfo *rankInfo = self.historyRankInfoList[index];
                if (rankInfo.userId == self.userInfo.userId) {
                    if (self.rankType == DailyRank_History_Distance) {
                        valueName = [Utility float2NSString:rankInfo.distance/1000];
                    }else if (self.rankType == DailyRank_History_AvgSpeed) {
                        valueName = [NSString stringWithFormat:@"%.1f", rankInfo.avgSpeed];
                    }else {
                        valueName = [NSString stringWithFormat:@"%.1f", rankInfo.maxSpeed];
                    }
                    rankIndex = index+1;
                    break;
                }
            }
        }
            break;
        case 2:
        {
            for (NSInteger index=0; index<self.dailyRankInfoList.count; index++) {
                DailyRankInfo *rankInfo = self.dailyRankInfoList[index];
                if (rankInfo.userId == self.userInfo.userId) {
                    valueName = @(rankInfo.stepNumber).stringValue;
                    rankIndex = index+1;
                    break;
                }
            }
        }
            break;
            
        default:
            break;
    }

    self.valueLabel.text = valueName;
    self.rankLabel.text = @(rankIndex).stringValue;
    UIColor *rankColor = [UIColor colorWithHex:0xfd000f];
    switch (rankIndex)
    {
            // 前三名
        case 1:
            rankColor = [UIColor colorWithHex:0x01ff00];
            break;
        case 2:
            rankColor = [UIColor colorWithHex:0xffec00];
            break;
        case 3:
            rankColor = [UIColor colorWithHex:0x00ffe8];
            break;
        default:
            
            break;
    }
    self.rankLabel.textColor = rankColor;
    
}

- (void)initPageData {
    
    [self showLoadingToast];
    
    switch (self.controllerType) {
        case 0:
        {
            @weakify(self)
            [UserRequest getMatchChartObj:(MatchRank)[self requestRankType] handle:^(id result, NSError *error) {
                @strongify(self)
                [self dismissToast];
                if (error) {
                    [self.tableView reloadData];
                    [self showToastWithText:error.domain];
                }else {
                    self.matchRankInfoList = result;
                    self.isShowEmptyView = self.matchRankInfoList.count==0;
                    [self refreshUI];
                }
            }];
        }
            break;
        case 1:
        {
            @weakify(self)
            [UserRequest getHistoryChartObj:(MatchRank)[self requestRankType] handle:^(id result, NSError *error) {
                @strongify(self)
                
                [self dismissToast];
                if (error) {
                    [self.tableView reloadData];
                    [self showToastWithText:error.domain];
                }else {
                    self.historyRankInfoList = result;
                    self.isShowEmptyView = self.historyRankInfoList.count==0;
                    [self refreshUI];
                }
            }];
        }
            break;
        case 2:
        {
            @weakify(self)
            [UserRequest getDailyChartObj:DailyRank_Step gtype:(DailyGroup)[self requestRankType] handle:^(id result, NSError *error) {
                
                @strongify(self)
                [self dismissToast];
                if (error) {
                    [self.tableView reloadData];
                    [self showToastWithText:error.domain];
                }else {
                    self.dailyRankInfoList = result;
                    self.isShowEmptyView = self.dailyRankInfoList.count==0;
                    [self refreshUI];
                }
            }];
        }
            break;
            
        default:
            break;
    }
    
}

- (NSString *)titleName {
    
    switch (self.rankType) {
        case DailyRank_This_Distance:
            return LS(@"rank.left.moving");
            break;
        case DailyRank_This_AvgSpeed:
            return LS(@"rank.left.average");
            break;
        case DailyRank_This_MaxSpeed:
            return LS(@"rank.left.fastest");
            break;
        case DailyRank_History_Distance:
            return LS(@"rank.left.moving");
            break;
        case DailyRank_History_AvgSpeed:
            return LS(@"rank.left.average");
            break;
        case DailyRank_History_MaxSpeed:
            return LS(@"rank.left.fastest");
            break;
        case DailyRank_Week:
            return LS(@"rank.left.week");
            break;
        case DailyRank_Month:
            return LS(@"rank.left.month");
            break;
        case DailyRank_Day:
            return LS(@"rank.left.day");
            break;
            
        default:
                return @"";
            break;
    }
}

- (NSString *)unitName {
    
    switch (self.rankType) {
        case DailyRank_This_Distance:
            return @"KM";
            break;
        case DailyRank_This_AvgSpeed:
            return @"M/S";
            break;
        case DailyRank_This_MaxSpeed:
            return @"M/S";
            break;
        case DailyRank_History_Distance:
            return @"KM";
            break;
        case DailyRank_History_AvgSpeed:
            return @"M/S";
            break;
        case DailyRank_History_MaxSpeed:
            return @"M/S";
            break;
        case DailyRank_Week:
        case DailyRank_Month:
        case DailyRank_Day:
            return LS(@"rank.sub.step");
            break;
        default:
            return @"";
            break;
    }
}

- (NSString *)rankTitleName {
    
    switch (self.rankType) {
        case DailyRank_This_Distance:
        case DailyRank_This_AvgSpeed:
        case DailyRank_This_MaxSpeed:
            return LS(@"rank.right.latest");
            break;
        case DailyRank_History_Distance:
        case DailyRank_History_AvgSpeed:
        case DailyRank_History_MaxSpeed:
            return LS(@"rank.right.history");
            break;
        case DailyRank_Week:
        case DailyRank_Month:
        case DailyRank_Day:
            return LS(@"rank.right.daily");
            break;
            
        default:
            return @"";
            break;
    }
}

- (NSInteger)requestRankType {
    
    switch (self.rankType) {
        case DailyRank_This_Distance:
            return MatchRank_Distance;
            break;
        case DailyRank_This_AvgSpeed:
            return MatchRank_AveSpeed;
            break;
        case DailyRank_This_MaxSpeed:
            return MatchRank_MaxSpeed;
            break;
        case DailyRank_History_Distance:
            return MatchRank_Distance;
            break;
        case DailyRank_History_AvgSpeed:
            return MatchRank_AveSpeed;
            break;
        case DailyRank_History_MaxSpeed:
            return MatchRank_MaxSpeed;
            break;
        case DailyRank_Week:
            return DailyGroup_Week;
            break;
        case DailyRank_Month:
            return DailyGroup_Month;
            break;
        case DailyRank_Day:
            return DailyGroup_Days;
            break;
            
        default:
            return 0;
            break;
    }
}

@end
