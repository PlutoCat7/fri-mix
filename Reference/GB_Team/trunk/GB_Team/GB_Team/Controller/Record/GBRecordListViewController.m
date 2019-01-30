//
//  GBRecordListViewController.m
//  GB_Team
//
//  Created by Pizza on 16/9/19.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBRecordListViewController.h"
#import "GBHomePageViewController.h"
#import "GBRecordTeamCell.h"
#import "GBRecordPlayerListViewController.h"
#import "GBAlertView.h"
#import "MJRefresh.h"

#import "MatchRequest.h"
#import "MatchRecordPageRequest.h"

@interface GBRecordListViewController()<
UITableViewDataSource,
UITableViewDataSource>
// 表格
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//正常显示
@property (nonatomic, strong) NSArray<MatchRecordInfo *> *showDataList;

@property (nonatomic, strong) MatchRecordPageRequest *recordPageRequest;

@end

@implementation GBRecordListViewController

- (void)dealloc{
    
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if ([self.navigationController.topViewController isMemberOfClass:[GBHomePageViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

#pragma mark - Action

- (void)deleteMatchData:(NSInteger)matchId indexPath:(NSIndexPath *)indexPath {
    
    @weakify(self)
    [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        @strongify(self)
        if (buttonIndex == 1) {

            [self showLoadingToast];
            [MatchRequest delMatch:matchId handler:^(id result, NSError *error) {
                [self dismissToast];
                if (error) {
                    [self showToastWithText:error.domain];
                }else {
                    NSMutableArray *list = [NSMutableArray arrayWithArray:self.showDataList];
                    [list removeObjectAtIndex:indexPath.row];
                    self.showDataList = [list copy];
                    self.isShowEmptyView = self.showDataList.count == 0;
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self.tableView reloadData];
                }
            }];
        }
    } title:LS(@"温馨提示") message:LS(@"您确定要删除该比赛数据吗？") cancelButtonName:LS(@"取消") otherButtonTitle:LS(@"确定")];
}

#pragma mark - Private

-(void)setupUI {
    
    self.title = LS(@"球队记录");
    [self setupBackButtonWithBlock:nil];
    [self setupTableView];
}

-(void)setupTableView {
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"GBRecordTeamCell" bundle:nil] forCellReuseIdentifier:@"GBRecordTeamCell"];
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
            self.showDataList = self.recordPageRequest.responseInfo.items;
            self.isShowEmptyView = self.showDataList.count==0;
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
            self.showDataList = self.recordPageRequest.responseInfo.items;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Delegate

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showDataList == nil ? 0 : self.showDataList.count;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GBRecordTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBRecordTeamCell"];
    
    MatchRecordInfo *info = self.showDataList[indexPath.row];
    [cell refreshWithMatchRecordInfo:info];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![self.recordPageRequest isLoadEnd] &&
        self.showDataList.count-1 == indexPath.row) {
        [self getNextRecordList];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MatchRecordInfo *info = self.showDataList[indexPath.row];
    GBRecordPlayerListViewController *vc = [[GBRecordPlayerListViewController alloc] initWithMatchId:info.matchId];
    [self.navigationController pushViewController:vc animated:YES];
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @weakify(self)
    void(^rowActionHandler)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath)
    {
        
        @strongify(self)
        MatchRecordInfo *info = self.showDataList[indexPath.row];
        [self deleteMatchData:info.matchId indexPath:indexPath];
    };
    
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:LS(@"删除") handler:rowActionHandler];
    
    return @[action];
}

#pragma mark - Setter and Getter

- (MatchRecordPageRequest *)recordPageRequest {
    
    if (!_recordPageRequest) {
        _recordPageRequest = [MatchRecordPageRequest new];
    }
    
    return _recordPageRequest;
}



@end
