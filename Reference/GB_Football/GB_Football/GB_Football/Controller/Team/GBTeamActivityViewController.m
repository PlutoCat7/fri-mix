//
//  GBTeamActivityViewController.m
//  GB_Football
//
//  Created by gxd on 2017/10/13.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBTeamActivityViewController.h"
#import "GBBaseViewController+Empty.h"
#import "GBMenuViewController.h"
#import "GBWKWebViewController.h"

#import "MJRefresh.h"
#import "GBTeamActivityCell.h"

#import "TeamActivityListRequest.h"

@interface GBTeamActivityViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray<TeamActivityInfo *> *recordList;
@property (nonatomic, strong) TeamActivityListRequest *recordPageRequest;

@end

@implementation GBTeamActivityViewController

#pragma mark -
#pragma mark Memory

- (void)dealloc{
    
}

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
    if ([self.navigationController.topViewController isMemberOfClass:[GBMenuViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

#pragma mark - Analytics

- (NSString *)pageName {
    return Analy_Page_Team_Activity;
}

#pragma mark - Delegate
// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recordList.count;
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TeamActivityInfo *info = self.recordList[indexPath.row];
    
    GBTeamActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBTeamActivityCell"];
    [cell refreshWithTeamActivityInfo:info];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TeamActivityInfo *info = self.recordList[indexPath.row];
    
    if (info.operateType == TeamOptType_InsideWeb) {
        GBWKWebViewController *vc = [[GBWKWebViewController alloc]initWithTitle:info.title content:info.content webUrl:info.paramUrl];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![self.recordPageRequest isLoadEnd] &&
        self.recordList.count-1 == indexPath.row) {
        [self getNextRecordList];
    }
}

#pragma mark - Private

-(void)setupUI
{
    self.title = LS(@"team.activity.nav.title");
    [self setupBackButtonWithBlock:nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GBTeamActivityCell" bundle:nil] forCellReuseIdentifier:@"GBTeamActivityCell"];
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

#pragma mark - Getters & Setters

- (TeamActivityListRequest *)recordPageRequest {
    
    if (!_recordPageRequest) {
        _recordPageRequest = [[TeamActivityListRequest alloc] init];
        
    }
    
    return _recordPageRequest;
}
@end
