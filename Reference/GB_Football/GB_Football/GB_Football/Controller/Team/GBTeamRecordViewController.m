//
//  GBTeamRecordViewController.m
//  GB_Football
//
//  Created by gxd on 17/7/27.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBTeamRecordViewController.h"
#import "GBBaseViewController+Empty.h"
#import "GBMenuViewController.h"
#import "GBTeamRecordDetailViewController.h"

#import "GBTeamRecordCell.h"
#import "MJRefresh.h"
#import "TeamMatchRecordRequest.h"
#import "LineUpModel.h"
#import "TeamRequest.h"

@interface GBTeamRecordViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray<TeamMatchInfo *> *recordList;
@property (nonatomic, strong) TeamMatchRecordRequest *recordPageRequest;

@end

@implementation GBTeamRecordViewController

#pragma mark -
#pragma mark Memory

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView.mj_header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(matchCompleteNotification) name:Notification_Match_Handle_Complete object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if ([self.navigationController.topViewController isMemberOfClass:[GBMenuViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

#pragma mark - Analytics

- (NSString *)pageName {
    return Analy_Page_Team_Record;
}

#pragma mark - Notification

- (void)matchCompleteNotification {
    [self getFirstRecordList];
}
#pragma mark - Delegate
// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recordList.count;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GBTeamRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBTeamRecordCell"];
    TeamMatchInfo *matchInfo = self.recordList[indexPath.row];
    
    cell.teamNameLabel.text = matchInfo.matchName;
    cell.homeNameLabel.text = matchInfo.homeTeam;
    cell.guestNameLabel.text = matchInfo.guestTeam;
    cell.homeScoreLabel.text = [NSString stringWithFormat:@"%02d" , (int)matchInfo.homeScore];
    cell.guestScoreLabel.text = [NSString stringWithFormat:@"%02d" , (int)matchInfo.guestScore];
    if (matchInfo.homeScore > matchInfo.guestScore) {
        cell.homeScoreLabel.textColor = [UIColor colorWithHex:0xffb31f];
        cell.guestScoreLabel.textColor = [UIColor colorWithHex:0xffffff];
        
    } else if (matchInfo.homeScore < matchInfo.guestScore) {
        cell.homeScoreLabel.textColor = [UIColor colorWithHex:0xffffff];
        cell.guestScoreLabel.textColor = [UIColor colorWithHex:0xffb31f];
        
    } else {
        cell.homeScoreLabel.textColor = [UIColor colorWithHex:0xffffff];
        cell.guestScoreLabel.textColor = [UIColor colorWithHex:0xffffff];
    }
    
    LineUpModel *model = [[LineUpModel alloc] init];
    model.tracticsType = matchInfo.tracticsType;
    cell.teamTracticsLabel.text = model.name;
    
    NSString *matchInterval = [NSString stringWithFormat:@"%dMIN", (int)(matchInfo.matchInterval / 60)];
    cell.matchIntervalLabel.text = matchInterval;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:matchInfo.matchDate];
    NSString *descString = [NSString stringWithFormat:@"%@ %@   %@ %04d-%02d-%02d", LS(@"team.record.label.court"), matchInfo.courtName, LS(@"team.record.label.date"), (int)date.year, (int)date.month, (int)date.day];
    cell.descLabel.text = descString;
    
    return cell;
    
}
// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (NSInteger)(132.f*kAppScale);
}

// section头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TeamMatchInfo *matchInfo = self.recordList[indexPath.row];

    GBTeamRecordDetailViewController *vc = [[GBTeamRecordDetailViewController alloc] initWithMatchId:matchInfo.matchId];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (![self.recordPageRequest isLoadEnd] &&
        self.recordList.count-1 == indexPath.row) {
        [self getNextRecordList];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setEditing:false animated:true];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserInfo *userInfo = [RawCacheManager sharedRawCacheManager].userInfo;
    if (userInfo.userId == userInfo.team_mess.leaderId) {
        return YES;
    }else {
        return NO;
    }
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserInfo *userInfo = [RawCacheManager sharedRawCacheManager].userInfo;
    if (userInfo.userId == userInfo.team_mess.leaderId) {
        TeamMatchInfo *matchInfo = self.recordList[indexPath.row];
        @weakify(self)
        UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:LS(@"common.btn.delete") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
            @strongify(self)
            [tableView setEditing:NO animated:YES];
            [self deleteMatchRecord:matchInfo];
        }];
        
        action1.backgroundColor = [UIColor colorWithHex:0xd33232];
        return @[action1];
    }else {
        return nil;
    }

}

#pragma mark - Private

-(void)setupUI
{
    self.title = LS(@"record.nav.tile");
    [self setupBackButtonWithBlock:nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GBTeamRecordCell" bundle:nil] forCellReuseIdentifier:@"GBTeamRecordCell"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor blackColor];
    self.emptyScrollView = self.tableView;
    
    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self getFirstRecordList];
    }];
    mj_header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.tableView.mj_header = mj_header;
}

- (void)getFirstRecordList {
    
    @weakify(self)
    [self.recordPageRequest reloadPageWithHandle:^(id result, NSError *error) {
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        if (error) {
            [self showToastWithText:error.domain];
            [self.tableView reloadData];
        }else {
            self.recordList = self.recordPageRequest.responseInfo.items;
            self.isShowEmptyView = self.recordList.count==0;
            [self.tableView reloadData];
        }
    }];
}

- (void)getNextRecordList {
    
    @weakify(self)
    [self.recordPageRequest loadNextPageWithHandle:^(id result, NSError *error) {
        @strongify(self)
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            self.recordList = self.recordPageRequest.responseInfo.items;
            [self.tableView reloadData];
        }
    }];
}

- (void)deleteMatchRecord:(TeamMatchInfo *)matchInfo {
    
    @weakify(self)
    [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        @strongify(self)
        if (buttonIndex == 1) {
            [self showLoadingToast];
            [TeamRequest deleteTeamMatchWithId:matchInfo.matchId handler:^(id result, NSError *error) {
                
                [self dismissToast];
                if (error) {
                    [self showToastWithText:error.domain];
                }else {
                    NSMutableArray *tmpList = [NSMutableArray arrayWithArray:self.recordList];
                    [tmpList removeObject:matchInfo];
                    self.recordList = [tmpList copy];
                    
                    [self.tableView reloadData];
                }
            }];
        }
    } title:LS(@"common.popbox.title.tip") message:LS(@"record.hint.delete.message") cancelButtonName:LS(@"common.btn.cancel") otherButtonTitle:LS(@"common.btn.yes") style:GBALERT_STYLE_NOMAL];
    
}

#pragma mark - Getters & Setters

- (TeamMatchRecordRequest *)recordPageRequest {
    
    if (!_recordPageRequest) {
        _recordPageRequest = [[TeamMatchRecordRequest alloc] init];
        
        TeamInfo *teamInfo = [RawCacheManager sharedRawCacheManager].userInfo.team_mess;
        _recordPageRequest.teamId = teamInfo.teamId;
    }
    
    return _recordPageRequest;
}


@end
