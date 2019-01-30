//
//  GBTeamHomePageViewController.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/24.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBTeamHomePageViewController.h"
#import "GBMenuViewController.h"
#import "GBTeamCreateViewController.h"
#import "GBTeamSearchViewController.h"
#import "GBTeamEditViewController.h"
#import "GBTeamDataChartViewController.h"
#import "GBLineUpViewController.h"
#import "GBNewTeammateViewController.h"
#import "GBTeamRecordViewController.h"
#import "GBPersonDefaultCardViewController.h"
#import "GBTeamGameCreateViewController.h"
#import "GBSyncDataViewController.h"
#import "GBFootBallModeViewController.h"
#import "GBTeamRankListViewController.h"
#import "GBTeamActivityViewController.h"
#import "TacticsContainerViewController.h"
#import "GBLineUpViewController.h"

#import "GBTeamGuestHeaderView.h"
#import "GBTeamSectionHeaderView.h"
#import "GBTeamHomeCell.h"
#import "GBAlertTeamHomePageView.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "RTLabel.h"
#import "GBCourseMask.h"
#import "NoRemindManager.h"

#import "UserRequest.h"
#import "AGPSManager.h"


@interface GBTeamHomePageViewController () <GBTeamGuestHeaderViewDelegate, GBTeamSectionHeaderViewDelegate>

@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) GBTeamGuestHeaderView *tableHeader;
@property (nonatomic, strong) GBTeamSectionHeaderView *sectionHeader;
@property (weak, nonatomic)   IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet GBCourseMask *courseMask;

@property (nonatomic, strong) TeamHomeRespone *teamHomeInfo;

@end

@implementation GBTeamHomePageViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _teamHomeInfo = [TeamHomeRespone new];
        _teamHomeInfo.team_mess = [RawCacheManager sharedRawCacheManager].userInfo.team_mess;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createTeamSuccessNotification) name:Notification_Team_CreateSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeTeamSuccessNotification) name:Notification_Team_RemoveSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTeamPageNotification) name:Notification_Team_Need_Refresh object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notAddTeamNotification) name:Notification_Team_NOT_ADDED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasAddTeamNotification) name:Notification_Team_ADDED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserInfoNotifition) name:Notification_User_BaseInfo object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self refreshUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if ([self.navigationController.topViewController isMemberOfClass:[GBMenuViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    AppConfigInfo *configInfo = [RawCacheManager sharedRawCacheManager].appConfigInfo;
    if (configInfo.showTeamActState == TeamActState_Open) {
        self.tableHeaderView.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,(NSInteger)((95 + 180)*kAppScale));
        [self.tableView setTableHeaderView:self.tableHeaderView];
        
    } else {
        self.tableHeaderView.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,(NSInteger)(180*kAppScale));
        [self.tableView setTableHeaderView:self.tableHeaderView];
    }

}

#pragma mark - Analytics

- (NSString *)pageName {
    return Analy_Page_Team;
}

#pragma mark - NSNotification

- (void)acceptOtherJoinTeamNotification {
    
    [self getTeamInfo];
}

- (void)createTeamSuccessNotification {
    
    self.teamHomeInfo.team_mess = [RawCacheManager sharedRawCacheManager].userInfo.team_mess;
    [self getTeamInfo];
}

- (void)removeTeamSuccessNotification {
    
    self.teamHomeInfo = nil;
    [self refreshUI];
    [self.navigationController popToViewController:self animated:YES];
}

- (void)refreshTeamPageNotification {
    
    [self getTeamInfo];
}

- (void)notAddTeamNotification {
    
    self.teamHomeInfo = nil;
    [self.navigationController popToViewController:self animated:YES];
}

- (void)hasAddTeamNotification {
    
    [UserRequest getUserInfoWithHandler:^(id result, NSError *error) {
        
        self.teamHomeInfo = [TeamHomeRespone new];
        self.teamHomeInfo.team_mess = [RawCacheManager sharedRawCacheManager].userInfo.team_mess;
        [self loadData];
        [self.navigationController popToViewController:self animated:YES];
    }];
}

- (void)refreshUserInfoNotifition {
    [self refreshUI];
    [self setupNavigationBarRight];
}

#pragma mark - Action
- (void)actionTeamActivity {
    [UMShareManager event:Analy_Click_Team_Activity];
    
    [self.navigationController pushViewController:[GBTeamActivityViewController new] animated:YES];
}

#pragma mark - Private

- (void)localizeUI {
    
}

- (void)loadData {
    // 每次近界面更新下用户信息
    // 请求球队信息
    [self showLoadingToast];
    [UserRequest getUserInfoWithHandler:^(id result, NSError *error) {
        
        [self dismissToast];
        [self setupNavigationBarRight];
        [self refreshUI];
        
        [self getTeamInfo];
    }];
    
    [self refreshUI];
}

- (void)refreshData {
    // 每次近界面更新下用户信息
    // 请求球队信息
    [UserRequest getUserInfoWithHandler:^(id result, NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        [self dismissToast];
        [self setupNavigationBarRight];
        [self refreshUI];
        
        [self getTeamInfo];
    }];
}

-(void)setupUI
{
    self.title = LS(@"team.home.my.team");
    [self setupBackButtonWithBlock:nil];
    [self setupNavigationBarRight];
    
    [self setupTableView];
    [self setupTeamTutotail];
}

- (void)setupTeamTutotail {
    // 显示教程
    UserInfo *userInfo = [RawCacheManager sharedRawCacheManager].userInfo;
    if (userInfo.team_mess != nil && userInfo.team_mess.teamId != 0 && [NoRemindManager sharedInstance].tutorialMaskTeam == NO) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        [self.courseMask showWithType:COURSE_MASK_TEAM];
        @weakify(self);
        self.courseMask.action = ^{
            @strongify(self)
            [self.navigationController setNavigationBarHidden:NO animated:NO];
        };
    } else {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
}

- (void)setupNavigationBarRight {
    
    // 显示球队比赛按键
    UserInfo *userInfo = [RawCacheManager sharedRawCacheManager].userInfo;
    if (userInfo.team_mess && (userInfo.userId == userInfo.team_mess.leaderId || userInfo.isCaptainOrViceCaptain)) {
        NSString *title = LS(@"team.match.nav.title");
        CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToHeight:24];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setSize:size];
        [button.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[ColorManager styleColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(rightBarAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        [self.navigationItem setRightBarButtonItem:rightButton];
        
    } else {
        [self.navigationItem setRightBarButtonItem:nil];
    }
}

- (void)rightBarAction {
    if ([RawCacheManager sharedRawCacheManager].userInfo.matchInfo) {
        [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                switch ([AGPSManager shareInstance].status) {
                    case iBeaconStatus_Sport: {
                        [self.navigationController pushViewController:[[GBSyncDataViewController alloc]
                                                                       initWithMatchId:[RawCacheManager sharedRawCacheManager].userInfo.matchInfo.match_id
                                                                       showSportCard:NO] animated:YES];
                    }
                        break;
                    default: {
                        [self.navigationController pushViewController:[[GBFootBallModeViewController alloc] init] animated:YES];
                    }
                        break;
                }
            }
        } title:LS(@"common.popbox.title.tip") message:LS(@"team.match.hint.has.match") cancelButtonName:LS(@"common.btn.cancel") otherButtonTitle:LS(@"common.btn.yes") style:GBALERT_STYLE_NOMAL];
        
    } else {
        [self.navigationController pushViewController:[GBTeamGameCreateViewController new] animated:YES];
    }
    
}

- (void)getTeamInfo {
    
    @weakify(self)
    [TeamRequest getTeamInfo:0 handler:^(id result, NSError *error) {
        
        @strongify(self)
        [self dismissToast];
        [self.tableView.mj_header endRefreshing];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            self.teamHomeInfo = result;
            [RawCacheManager sharedRawCacheManager].userInfo.team_mess = self.teamHomeInfo.team_mess;
            [self setupNavigationBarRight];
            [self refreshUI];
        }
    }];
}

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GBTeamHomeCell" bundle:nil] forCellReuseIdentifier:@"GBTeamHomeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GBTeamSectionHeaderView" bundle:nil]forHeaderFooterViewReuseIdentifier:@"GBTeamSectionHeaderView"];
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        //获取球队信息
        [self refreshData];
    }];
    mj_header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.tableView.mj_header = mj_header;
}

- (void)refreshUI {
    
    //刷新头部与简介
    TeamInfo *info = self.teamHomeInfo.team_mess;
    if (info) {
        self.tableHeader.homeTeam = YES;
        self.tableHeader.userNoTeam = NO;
        UserInfo *userInfo = [RawCacheManager sharedRawCacheManager].userInfo;
        [self.sectionHeader hideNewTeammateView:(!info.isMineTeam && !userInfo.isCaptainOrViceCaptain)];
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:info.foundTime];
        AreaInfo *areaInfo = [LogicManager findAreaWithProvinceId:info.provinceId cityId:info.cityId];
        NSInteger playerCount = self.teamHomeInfo.players.count;
        self.tableHeader.teamDescLabel.text = [NSString stringWithFormat:@"%@%@    %@%@    %@%td", LS(@"team.home.set.up.time"), [date stringWithFormat:LS(@"team.data.yyyy-MM-dd日")], LS(@"team.home.city"), areaInfo.areaName, LS(@"team.home.members"), playerCount];
        [self.tableHeader.avatorView.avatorImageView sd_setImageWithURL:[NSURL URLWithString:info.teamIcon] placeholderImage:[UIImage imageNamed:@"portrait"]];
        self.tableHeader.teamNameLabel.text = info.teamName;
        
    }else {
        self.tableHeader.homeTeam = YES;
        self.tableHeader.userNoTeam = YES;
        [self.sectionHeader hideNewTeammateView:NO];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Setter and Getter

- (UIView *)tableHeaderView {
    if (_tableHeaderView) {
        return _tableHeaderView;
    }
    
    AppConfigInfo *configInfo = [RawCacheManager sharedRawCacheManager].appConfigInfo;
    if (configInfo.showTeamActState == TeamActState_Open) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,((NSInteger)(95 + 180)*kAppScale))];
        
        UIImageView *activityView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,(NSInteger)(95*kAppScale))];
        [activityView setImage:[UIImage imageNamed:@"team_banner"]];
        
        GBTeamGuestHeaderView *tableHeader = self.tableHeader;
        tableHeader.frame = CGRectMake(0, (NSInteger)(95*kAppScale),[UIScreen mainScreen].bounds.size.width,(NSInteger)(180*kAppScale));
        
        [_tableHeaderView addSubview:activityView];
        [_tableHeaderView addSubview:tableHeader];
        
        //给图片添加点击手势（也可以添加其他手势）
        activityView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionTeamActivity)];
        [activityView addGestureRecognizer:tap];
        
    } else {
        _tableHeaderView = self.tableHeader;
    }
    
    return _tableHeaderView;
}

- (GBTeamGuestHeaderView *)tableHeader {
    
    if (!_tableHeader) {
        _tableHeader = [[NSBundle mainBundle] loadNibNamed:@"GBTeamGuestHeaderView" owner:nil options:nil].firstObject;
        _tableHeader.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,(NSInteger)(180*kAppScale));
        _tableHeader.delegate = self;
    }
    return _tableHeader;
}

- (GBTeamSectionHeaderView *)sectionHeader {
    
    if (!_sectionHeader) {
        _sectionHeader = [[NSBundle mainBundle] loadNibNamed:@"GBTeamSectionHeaderView" owner:nil options:nil].firstObject;
        _sectionHeader.delegate = self;
    }
    return _sectionHeader;
}

#pragma mark - Table Delegate

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.teamHomeInfo.players.count;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeamPalyerInfo *info = self.teamHomeInfo.players[indexPath.row];
    GBTeamHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBTeamHomeCell"];
    [cell.avatorView.avatorImageView sd_setImageWithURL:[NSURL URLWithString:info.image_url] placeholderImage:[UIImage imageNamed:@"portrait"]];
    cell.nameLabel.text = info.nick_name;
    cell.numberLabel.text = @(info.team_no).stringValue;
    cell.type = info.roleType;
    NSArray *positionList = [info.position componentsSeparatedByString:@","];
    cell.positionLabel.index = [positionList.firstObject integerValue];
    
    return cell;
}
// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 82.f;
}

// section头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 105*kAppScale;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return self.sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.teamHomeInfo.team_mess) {
        return 0.1f;
    } else {
        AppConfigInfo *configInfo = [RawCacheManager sharedRawCacheManager].appConfigInfo;
        return (configInfo.showTeamActState == TeamActState_Open) ? (300-95)*kAppScale : 300*kAppScale;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.teamHomeInfo.team_mess) {
        return nil;
        
    } else {
        AppConfigInfo *configInfo = [RawCacheManager sharedRawCacheManager].appConfigInfo;
        CGFloat height = configInfo.showTeamActState == TeamActState_Open ? (300-95)*kAppScale : 300*kAppScale;
        
        UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, height)];
        RTLabel *hintLabel = [[RTLabel alloc] initWithFrame:CGRectMake(0, (height-80)/2*kAppScale, tableView.bounds.size.width, 80*kAppScale)];

        hintLabel.textAlignment = RTTextAlignmentCenter;
        hintLabel.text = LS(@"team.home.create.hint");
        hintLabel.backgroundColor = [UIColor clearColor];
        
        [sectionView addSubview:hintLabel];
        return sectionView;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TeamPalyerInfo *info = [self.teamHomeInfo.players objectAtIndex:indexPath.row];
    if (self.teamHomeInfo.team_mess.isMineTeam && info.roleType!=TeamPalyerType_Captain) {
        return YES;
    }else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self setEditing:false animated:true];
    
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TeamPalyerInfo *info = [self.teamHomeInfo.players objectAtIndex:indexPath.row];
    if (self.teamHomeInfo.team_mess.isMineTeam && info.roleType!=TeamPalyerType_Captain) {
        
        @weakify(self)
        UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:LS(@"team.home.kicked.out") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
            @strongify(self)
            [tableView setEditing:NO animated:YES];
            [self deleteTeammate:info];
        }];
        UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:LS(@"team.home.appoint") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
            @strongify(self)
            [tableView setEditing:NO animated:YES];
            [self handleTeammate:info];
        }];
        action1.backgroundColor = [UIColor colorWithHex:0xd33232];
        action2.backgroundColor = [UIColor colorWithHex:0xe4a644];
        return @[action1,action2];
    }else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TeamPalyerInfo *info = [self.teamHomeInfo.players objectAtIndex:indexPath.row];
    GBPersonDefaultCardViewController *vc = [[GBPersonDefaultCardViewController alloc] init];
    vc.userId = info.user_id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)deleteTeammate:(TeamPalyerInfo *)playerInfo {
    
    [self showLoadingToast];
    @weakify(self)
    [TeamRequest kickedOutTeammate:playerInfo.user_id handler:^(id result, NSError *error) {
        
        @strongify(self)
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            NSMutableArray *tmpList = [NSMutableArray arrayWithArray:self.teamHomeInfo.players];
            [tmpList removeObject:playerInfo];
            self.teamHomeInfo.players = [tmpList copy];
            
            [self refreshUI];
        }
    }];
}

- (void)handleTeammate:(TeamPalyerInfo *)playerInfo {
    
    NSString *firstName = LS(@"team.home.remove.v-cpt");
    NSString *secondName = LS(@"team.home.remove.cpt");
    if (playerInfo.roleType == TeamPalyerType_Ordinary) {
        firstName = LS(@"team.home.appoint.v-cpt");
        // secondName = nil;
    }
    [GBAlertTeamHomePageView alertWithFirstName:firstName secondName:secondName handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) { //副队长

            [TeamRequest appointViceCaptain:playerInfo.user_id isAppoint:playerInfo.roleType == TeamPalyerType_Ordinary handler:^(id result, NSError *error) {
                if (error) {
                    [self showToastWithText:error.domain];
                }else {
                    playerInfo.roleType = (playerInfo.roleType == TeamPalyerType_Ordinary)?TeamPalyerType_ViceCaptain:TeamPalyerType_Ordinary;
                    [self.tableView reloadData];
                }
            }];
        }else if (buttonIndex == 2) { //移交队长
            NSString *messgae = [NSString stringWithFormat:@"%@\"%@\"%@", LS(@"team.home.您确定要将队长移交给"), playerInfo.nick_name, LS(@"team.home.吗")];
            [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
                if (buttonIndex == 1)
                {
                    [TeamRequest appointCaptain:playerInfo.user_id handler:^(id result, NSError *error) {
                        if (error) {
                            [self showToastWithText:error.domain];
                        }else {
                            [self refreshData];
                        }
                    }];
                }
            } title:LS(@"common.popbox.title.tip") message:messgae cancelButtonName:LS(@"common.btn.cancel") otherButtonTitle:LS(@"common.btn.yes") style:GBALERT_STYLE_NOMAL];
            
            
        }
    }];
}

#pragma mark GBTeamGuestHeaderViewDelegate

- (void)didClickHeaderView:(GBTeamGuestHeaderView *)headerView {
    
    if (self.teamHomeInfo.team_mess) {
        [self.navigationController pushViewController:[[GBTeamEditViewController alloc] initWithLeader:self.teamHomeInfo.team_mess] animated:YES];
    }
}

- (void)didClickCreateTeam:(GBTeamGuestHeaderView *)headerView {
    
    [self.navigationController pushViewController:[GBTeamCreateViewController new] animated:YES];
}

- (void)didClickJoinTeam:(GBTeamGuestHeaderView *)headerView {
    
    [self.navigationController pushViewController:[GBTeamSearchViewController new] animated:YES];
}

#pragma mark GBTeamSectionHeaderViewDelegate

- (void)didClickTeamSectionHeaderView:(GBTeamSectionHeaderView *)headerView itemIndex:(NSInteger)itemIndex {
    
    TeamInfo *teamInfo = self.teamHomeInfo.team_mess;
    if (!teamInfo) {
        return;
    }
    
    switch (itemIndex) {
        case 0: {
            [UMShareManager event:Analy_Click_Team_Data];
            
            [self.navigationController pushViewController:[[GBTeamDataChartViewController alloc] initWithTeamInfo:self.teamHomeInfo.team_mess] animated:YES];
        }
            break;
            
        case 1: {
            [UMShareManager event:Analy_Click_Team_Tactic];
//            GBLineUpViewController *vc = [[GBLineUpViewController alloc] initWithTeamInfo:self.teamHomeInfo useSelect:NO];
//            [vc loadLineUpList];
            TacticsContainerViewController *vc = [[TacticsContainerViewController alloc] init];
            vc.teamResponse = self.teamHomeInfo;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 2: {
            [UMShareManager event:Analy_Click_Team_Record];
            [self.navigationController pushViewController:[[GBTeamRecordViewController alloc] init] animated:YES];
        }
            break;
            
        case 3: {
            [UMShareManager event:Analy_Click_Team_Rank];
            [self.navigationController pushViewController:[[GBTeamRankListViewController alloc] init] animated:YES];
        }
            break;
            
        case 4: {
            [self.navigationController pushViewController:[[GBNewTeammateViewController alloc] init] animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
