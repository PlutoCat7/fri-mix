//
//  GBTeamRankListViewController.m
//  GB_Football
//
//  Created by gxd on 17/9/19.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBTeamRankListViewController.h"
#import "GBTeamHomePageViewController.h"
#import "GBTeamGuestHomePageViewController.h"

#import "GBTeamRankCell.h"
#import "GBTeamRandHeaderView.h"
#import "TeamRequest.h"
#import "MJRefresh.h"

@interface GBTeamRankListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet GBTeamRandHeaderView *firstView;
@property (weak, nonatomic) IBOutlet GBTeamRandHeaderView *secondView;
@property (weak, nonatomic) IBOutlet GBTeamRandHeaderView *thirdView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *userRankView;
@property (weak, nonatomic) IBOutlet UILabel *userNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *userTeamNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankHintLabel;

@property (nonatomic, strong) TeamRankRespone *teamRankData;

@end

@implementation GBTeamRankListViewController

#pragma mark -
#pragma mark Memory

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.headerView.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,(258.f*kAppScale));
    [self.tableView setTableHeaderView:self.headerView];
    
}

#pragma mark - Analytics

- (NSString *)pageName {
    return Analy_Page_Team_Rank;
}

#pragma mark - Delegate
// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = self.teamRankData ? self.teamRankData.team_list.count : 0;
    return (count < 3) ? 0 : (count - 3);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 53.f*kAppScale;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeamRankInfo *info = self.teamRankData.team_list[indexPath.row + 3];
    
    GBTeamRankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBTeamRankCell"];
    cell.numberLabel.text = [NSString stringWithFormat:@"%d", (int) (indexPath.row + 3 + 1)];
    cell.teamNameLabel.text = info.teamName;
    cell.scoreLabel.text= [NSString stringWithFormat:@"%d", (int) info.score];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TeamRankInfo *info = self.teamRankData.team_list[indexPath.row + 3];
    
    GBTeamGuestHomePageViewController *vc = [[GBTeamGuestHomePageViewController alloc] initWithTeamId:info.teamId];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - Private
-(void)localizeUI {
    self.rankHintLabel.text = LS(@"team.rank.no.match.hint");
}

-(void)setupUI {
    self.title = LS(@"team.rank.nav.title");
    [self setupBackButtonWithBlock:nil];
    
    [self setupTableView];
    [self setupTableViewHeader];
}

-(void)setupTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"GBTeamRankCell" bundle:nil] forCellReuseIdentifier:@"GBTeamRankCell"];
    self.tableView.tableHeaderView = self.headerView;
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

-(void)setupTableViewHeader {
    [self.firstView setRankType:GBTeamRankType_Glod];
    [self.secondView setRankType:GBTeamRankType_Silver];
    [self.thirdView setRankType:GBTeamRankType_Copper];
    
    void(^block)(GBTeamRankType rankType) = ^(GBTeamRankType rankType) {
        [self lookupTeamInfo:rankType];
    };
    
    self.firstView.didLookUpTeam = block;
    self.secondView.didLookUpTeam = block;
    self.thirdView.didLookUpTeam = block;
}

-(void)lookupTeamInfo:(NSInteger)index {
    if (self.teamRankData.team_list.count > index) {
        TeamRankInfo *info = self.teamRankData.team_list[index];
        
        GBTeamGuestHomePageViewController *vc = [[GBTeamGuestHomePageViewController alloc] initWithTeamId:info.teamId];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (void)refreshData {
    @weakify(self)
    [TeamRequest getTeamRankList:^(id result, NSError *error) {
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        
        if (error) {
            [self showToastWithText:error.domain];
        } else {
            self.teamRankData = result;
            [self updateHeadAndBottom];
            
            [self.tableView reloadData];
        }
    }];
}

- (void)updateHeadAndBottom {
    if (self.teamRankData == nil) {
        self.bottomView.hidden = YES;
        return;
    }
    
    self.headerView.hidden = NO;
    NSInteger count = self.teamRankData.team_list.count;
    if (count >= 1) {
        [self.firstView refreshWithTeamRankInfo:self.teamRankData.team_list[0]];
    }
    if (count >= 2) {
        [self.secondView refreshWithTeamRankInfo:self.teamRankData.team_list[1]];
    }
    if (count >= 3) {
        [self.thirdView refreshWithTeamRankInfo:self.teamRankData.team_list[2]];
    }
    
    self.bottomView.hidden = NO;
    if (self.teamRankData.my_team.isTeamMatch) {
        self.userRankView.hidden = NO;
        self.rankHintLabel.hidden = YES;
        
        UIColor *textColor = [UIColor whiteColor];
        NSInteger index = [self findIndexFromRankList:self.teamRankData.my_team.teamId];
        if (index == 0) {
            textColor = [UIColor colorWithHex:0xffc343];
        } else if (index == 1) {
            textColor = [UIColor colorWithHex:0xb7d5e3];
        } else if (index == 2) {
            textColor = [UIColor colorWithHex:0xe3a785];
        }
        
        if (index == NSNotFound) {
            self.userNumberLabel.text = LS(@"team.rank.no.list");
            self.userNumberLabel.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:14];
        } else {
            self.userNumberLabel.text = [NSString stringWithFormat:@"%d", (int) (index + 1)];
            self.userNumberLabel.font = [UIFont fontWithName:@"BEBAS" size:20];
        }
        self.userTeamNameLabel.text = self.teamRankData.my_team.teamName;
        self.userScoreLabel.text= [NSString stringWithFormat:@"%d", (int) self.teamRankData.my_team.score];
        
        self.userNumberLabel.textColor = textColor;
        self.userTeamNameLabel.textColor = textColor;
        self.userScoreLabel.textColor = textColor;
        
    } else {
        self.userRankView.hidden = YES;
        self.rankHintLabel.hidden = NO;
    }
}

- (NSInteger)findIndexFromRankList:(NSInteger)teamId {
    for (int i = 0; i < self.teamRankData.team_list.count; i++) {
        TeamRankInfo *teamRankInfo = self.teamRankData.team_list[i];
        if (teamRankInfo.teamId == teamId) {
            return i;
        }
    }
    return NSNotFound;
}

@end
