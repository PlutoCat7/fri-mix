//
//  GBTeamMatchInviteViewController.m
//  GB_Football
//
//  Created by gxd on 17/8/2.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBTeamMatchInviteViewController.h"
#import "GBBaseViewController+Empty.h"
#import "GBNewTeammateViewController.h"

#import "GBTeamMatchInviteCell.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "TeamRequest.h"
#import "MatchRequest.h"

@interface GBTeamMatchInviteViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *addPlayerStLbl;

@property (nonatomic, strong) UIButton *saveButton;
//接口数据
@property (nonatomic, strong) NSMutableArray<TeamPalyerInfo *> *teamPlayerList;
@property (nonatomic, strong) NSMutableArray<TeamPalyerInfo *> *selectedList;

@end

@implementation GBTeamMatchInviteViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithSelectedList:(NSArray<TeamPalyerInfo *> *)selectedList {
    
    self = [super init];
    if (self) {
        self.selectedList = [NSMutableArray arrayWithArray:selectedList];
    }
    return self;
}

- (void)localizeUI {
    
    self.addPlayerStLbl.text = LS(@"team.match.label.add");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupNotification];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
    });
    
}

#pragma mark - Analytics

- (NSString *)pageName {
    return Analy_Page_Team_GameInvite;
}

#pragma mark - Notification
- (void)someOneAcceptNotification {
    [self getTeamPlayerList];
}

#pragma mark - Action

- (void)actionCancel {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)actionSave {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Team_Player_Select object:[self.selectedList copy]];
    [self actionCancel];
}

- (IBAction)actionAddTeamPlayer:(id)sender {
    [self.navigationController pushViewController:[[GBNewTeammateViewController alloc] init] animated:YES];
}

#pragma mark UITableViewDelegate
// section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// section头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50.f;
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
}


// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.teamPlayerList.count;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GBTeamMatchInviteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBTeamMatchInviteCell"];
    // 最后一个cell的分割线需要特殊处理
    TeamPalyerInfo *info = self.teamPlayerList[indexPath.row];
    cell.playerNameLabel.text = info.nick_name;
    cell.playerNumLabel.text = [NSString stringWithFormat:@"%d", (int) info.team_no];
    [cell.avatorImageView sd_setImageWithURL:[NSURL URLWithString:info.image_url] placeholderImage:[UIImage imageNamed:@"portrait"]];
    NSArray *positionList = [info.position componentsSeparatedByString:@","];
    cell.playerPosLabel.index = [positionList.firstObject integerValue];
    
    BOOL isContain = NO;
    //是否包含
    {
        for (TeamPalyerInfo *tmpInfo in self.selectedList) {
            if (tmpInfo.user_id == info.user_id) {
                isContain = YES;
                break;
            }
        }
    }
    if (info.inviteStatus == FriendInviteMatchStatus_invited) {
        cell.type = TeamGameInviteType_NotSelected;
    }else {
        cell.type = isContain?TeamGameInviteType_Selected:TeamGameInviteType_UnSelected;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GBTeamMatchInviteCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    TeamPalyerInfo *info = self.teamPlayerList[indexPath.row];
    if (cell.type == TeamGameInviteType_Selected) {
        cell.type = TeamGameInviteType_UnSelected;
        TeamPalyerInfo *removeFriendInfo = nil;
        for (TeamPalyerInfo *tmpInfo in self.selectedList) {
            if (tmpInfo.user_id == info.user_id) {
                removeFriendInfo = tmpInfo;
                break;
            }
        }
        if (removeFriendInfo) {
            [self.selectedList removeObject:removeFriendInfo];
        }
        
    }else if (cell.type == TeamGameInviteType_UnSelected) {
        cell.type = TeamGameInviteType_Selected;
        [self.selectedList addObject:info];
    }
    [self checkSaveButtonValid];
}
#pragma mark - Private

- (void)setupNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(someOneAcceptNotification) name:Notification_Team_Need_Refresh object:nil];
}

- (void)loadData {
    [self getTeamPlayerList];
}

-(void)setupUI
{
    self.title = LS(@"team.match.label.invite");
    [self setupNavigationBarLeft];
    [self setupNavigationBarRight];
    [self checkSaveButtonValid];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GBTeamMatchInviteCell" bundle:nil] forCellReuseIdentifier:@"GBTeamMatchInviteCell"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = YES;
    self.emptyScrollView = self.tableView;
    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self getTeamPlayerList];
    }];
    mj_header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.tableView.mj_header = mj_header;
}

- (void)setupNavigationBarLeft {
    
    NSString *title = LS(@"common.btn.cancel");
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:16.f] constrainedToHeight:20];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setSize:size];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(actionCancel) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:leftButton];
}

- (void)setupNavigationBarRight {
    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveButton.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    self.saveButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.saveButton setTitleColor:[ColorManager styleColor] forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[ColorManager styleColor_50] forState:UIControlStateDisabled];
    self.saveButton.backgroundColor = [UIColor clearColor];
    [self.saveButton addTarget:self action:@selector(actionSave) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:self.saveButton];
    [self.navigationItem setRightBarButtonItem:rightButton];
}

- (void)getTeamPlayerList {
    
    [self showLoadingToast];
    @weakify(self)
    [MatchRequest getTeamGameInviteList:^(id result, NSError *error) {
        
        @strongify(self)
        [self dismissToast];
        [self.tableView.mj_header endRefreshing];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            NSArray *list = result;
            self.teamPlayerList = [list mutableCopy];
            self.isShowEmptyView = self.teamPlayerList.count==0;
            [self.tableView reloadData];
        }
    }];
}

- (void)checkSaveButtonValid {
    
    NSString *title = [NSString stringWithFormat:@"%@(%td)", LS(@"invite-friend-nav-right-title"), self.selectedList.count];
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToHeight:24];
    self.saveButton.size = size;
    [self.saveButton setTitle:title forState:UIControlStateNormal];
    [self.saveButton setTitle:title forState:UIControlStateDisabled];
}

@end
