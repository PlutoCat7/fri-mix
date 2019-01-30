//
//  GBTeamGuestHomePageViewController.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/24.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBTeamGuestHomePageViewController.h"
#import "GBPersonDefaultCardViewController.h"

#import "GBTeamGuestHeaderView.h"
#import "GBTeamGuestSectionHeaderView.h"
#import "GBTeamHomeCell.h"
#import "UIImageView+WebCache.h"

#import "TeamRequest.h"

@interface GBTeamGuestHomePageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *joinButton;
@property (nonatomic, strong) GBTeamGuestHeaderView *tableHeader;
@property (nonatomic, strong) GBTeamGuestSectionHeaderView *sectionHeader;
@property (weak, nonatomic)   IBOutlet UITableView *tableView;

@property (nonatomic, assign) NSInteger teamId;
@property (nonatomic, strong) TeamHomeRespone *teamHomeInfo;

@end

@implementation GBTeamGuestHomePageViewController

- (instancetype)initWithTeamId:(NSInteger)teamId {
    
    self = [super init];
    if (self) {
        _teamId = teamId;
    }
    return self;
}

- (instancetype)initWithTeamInfo:(TeamInfo *)teamInfo {
    
    self = [super init];
    if (self) {
        _teamId = teamInfo.teamId;
        _teamHomeInfo = [TeamHomeRespone new];
        _teamHomeInfo.team_mess = teamInfo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tableHeader.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,(NSInteger)(180*kAppScale));
    [self.tableView setTableHeaderView:self.tableHeader];
}

#pragma mark - Analytics

- (NSString *)pageName {
    return Analy_Page_Team_Guest;
}

#pragma mark - Action

- (void)actionJoin {
    
    [self showLoadingToast];
    @weakify(self)
    [TeamRequest applyTeamJoinWithTeamId:self.teamId handler:^(id result, NSError *error) {
        
        @strongify(self)
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            [self showToastWithText:LS(@"team.home.join.has.send")];
        }
    }];
}

#pragma mark - Private

- (void)loadData {
    
    //请求球队信息
    [self showLoadingToast];
    [self getTeamInfo];
    
    [self refreshUI];
}

- (void)getTeamInfo {
    
    @weakify(self)
    [TeamRequest getTeamInfo:self.teamId handler:^(id result, NSError *error) {
        
        @strongify(self)
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            self.teamHomeInfo = result;
            [self refreshUI];
        }
    }];
}

-(void)setupUI
{
    self.title = LS(@"team.home.introduction");
    [self setupBackButtonWithBlock:nil];
    
    TeamInfo *teamInfo = [RawCacheManager sharedRawCacheManager].userInfo.team_mess;
    if (teamInfo == nil || teamInfo.teamId == 0) {
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.joinButton]];
    }
    
    [self setupTableView];
}

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GBTeamHomeCell" bundle:nil] forCellReuseIdentifier:@"GBTeamHomeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GBTeamGuestSectionHeaderView" bundle:nil]forHeaderFooterViewReuseIdentifier:@"GBTeamGuestSectionHeaderView"];
    self.tableView.tableHeaderView = self.tableHeader;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)refreshUI {
    
    //刷新头部与简介
    if (self.teamHomeInfo.team_mess) {
        
        TeamInfo *info = self.teamHomeInfo.team_mess;
        [self.tableHeader.avatorView.avatorImageView
         sd_setImageWithURL:[NSURL URLWithString:info.teamIcon] placeholderImage:[UIImage imageNamed:@"portrait"]];
        self.tableHeader.teamNameLabel.text = info.teamName;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:info.foundTime];
        AreaInfo *areaInfo = [LogicManager findAreaWithProvinceId:info.provinceId cityId:info.cityId];
        NSInteger playerCount = self.teamHomeInfo.players.count;
        self.tableHeader.teamDescLabel.text = [NSString stringWithFormat:@"%@%@    %@%@    %@%td", LS(@"team.home.set.up.time"), [date stringWithFormat:LS(@"team.data.yyyy-MM-dd日")], LS(@"team.home.city"), areaInfo.areaName, LS(@"team.home.members"), playerCount];
        self.sectionHeader.teamDescLabel.text = info.teamInstr;
        [self.sectionHeader.teamDescLabel sizeToFit];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Setter and Getter

- (GBTeamGuestHeaderView *)tableHeader {
    
    if (!_tableHeader) {
        _tableHeader = [[NSBundle mainBundle] loadNibNamed:@"GBTeamGuestHeaderView" owner:nil options:nil].firstObject;
    }
    return _tableHeader;
}

- (GBTeamGuestSectionHeaderView *)sectionHeader {
    
    if (!_sectionHeader) {
        _sectionHeader = [[NSBundle mainBundle] loadNibNamed:@"GBTeamGuestSectionHeaderView" owner:nil options:nil].firstObject;
    }
    return _sectionHeader;
}

- (UIButton *)joinButton {
    
    if (!_joinButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(actionJoin) forControlEvents:UIControlEventTouchUpInside];
        NSString *title = LS(@"team.teammate.apply");
        CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToHeight:24];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[ColorManager styleColor] forState:UIControlStateNormal];
        button.size = size;
        
        _joinButton = button;
    }
    
    return _joinButton;
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
    
    CGFloat height = 48;
    height += self.sectionHeader.teamDescLabel.height;
    height += 35;
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return self.sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TeamPalyerInfo *info = [self.teamHomeInfo.players objectAtIndex:indexPath.row];
    GBPersonDefaultCardViewController *vc = [[GBPersonDefaultCardViewController alloc] init];
    vc.userId = info.user_id;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
