//
//  GBTeamListViewController.m
//  GB_Team
//
//  Created by Pizza on 16/9/13.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBTeamListViewController.h"
#import "GBHomePageViewController.h"
#import "GBTeamAddViewController.h"
#import "GBTeamMemberViewController.h"
#import "GBTeamNameCell.h"

#import "GBAlertView.h"
#import "MJRefresh.h"

#import "TeamRequest.h"

@interface GBTeamListViewController ()<UITableViewDataSource,UITableViewDataSource>

// 表格
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//正常显示
@property (nonatomic, strong) NSMutableArray<TeamInfo *> *showDataList;

@end

@implementation GBTeamListViewController


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupRefreshView:) name:Notification_CreateTeamSuccess object:nil];
    
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

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
}

#pragma mark - Notification
- (void)setupRefreshView:(NSNotification *)notification {
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - Action

// 创建球队按钮
- (void)actionAddPress {
    
    [self.navigationController pushViewController:[[GBTeamAddViewController alloc]init] animated:YES];
}

- (void)deleteTeamData:(NSInteger)teamId  indexPath:(NSIndexPath *)indexPath {
    
    @weakify(self)
    [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        @strongify(self)
        
        if (buttonIndex == 1) {
            [self showLoadingToast];
            [TeamRequest deleteTeam:teamId handler:^(id result, NSError *error) {
                
                [self dismissToast];
                if (error) {
                    [self showToastWithText:error.domain];
                }else {
                    [self.showDataList removeObjectAtIndex:indexPath.row];
                    self.isShowEmptyView = self.showDataList.count==0;
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self.tableView reloadData];
                }
            }];
        }
    } title:LS(@"温馨提示") message:LS(@"您确定要删除该球队呢？") cancelButtonName:LS(@"取消") otherButtonTitle:LS(@"确定")];
}

#pragma mark - Private

-(void)setupUI {
    
    self.title = LS(@"球队管理");
    [self setupRightButton];
    [self setupBackButtonWithBlock:nil];
    [self setupTableView];
}

- (void)setupRightButton {
    
    UIButton *addTeamButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addTeamButton.size = CGSizeMake(24, 24);
    [addTeamButton setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    addTeamButton.backgroundColor = [UIColor clearColor];
    [addTeamButton addTarget:self action:@selector(actionAddPress) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:addTeamButton]];
}

- (void)setupTableView {
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"GBTeamNameCell" bundle:nil] forCellReuseIdentifier:@"GBTeamNameCell"];
    
    self.emptyScrollView = self.tableView;
    
    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self getTeamList];
    }];
    mj_header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.tableView.mj_header = mj_header;
}

- (void)getTeamList {
    
    @weakify(self)
    [TeamRequest getTeamListWithHandler:^(id result, NSError *error) {
       
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        if (error) {
            [self showToastWithText:error.domain];
            [self.tableView reloadData];
        }else {
            self.showDataList = [NSMutableArray arrayWithArray:result];
            self.isShowEmptyView = self.showDataList.count==0;
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
    
    GBTeamNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBTeamNameCell"];
    
    TeamInfo *teamInfo = self.showDataList[indexPath.row];
    cell.nameLabel.text = teamInfo.teamName;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.layer.transform = CATransform3DMakeScale(1,0.1,1);
    [UIView animateWithDuration:0.25 animations:^{
        
        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TeamInfo *teamInfo = self.showDataList[indexPath.row];
    GBTeamMemberViewController *vc = [[GBTeamMemberViewController alloc] initWithTeamId:teamInfo.teamId];
    [self.navigationController pushViewController:vc animated:YES];
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @weakify(self)
    void(^rowActionHandler)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        @strongify(self)
        TeamInfo *teamInfo = self.showDataList[indexPath.row];
        [self deleteTeamData:teamInfo.teamId indexPath:indexPath];
    };
    
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:LS(@"删除") handler:rowActionHandler];
    
    return @[action];
}

@end
