//
//  GBNewTeammateViewController.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/19.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBNewTeammateViewController.h"
#import "GBBaseViewController+Empty.h"

#import "MJRefresh.h"
#import "GBNewTeammateCell.h"

#import "TeamRequest.h"
#import "TeammateSearchRequest.h"

@interface GBNewTeammateViewController ()< GBNewTeammateCellDelegate,
UITextFieldDelegate>

// 表控件
@property (weak, nonatomic)   IBOutlet UITableView *tableView;
// 搜索输入框
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

//接口数据
@property (nonatomic, strong) NSArray<TeamNewTeammateInfo *> *userApplyList;
@property (nonatomic, strong) NSArray<TeamNewTeammateInfo *> *myFriendList;

//显示
@property (nonatomic, strong) NSMutableArray<NSString *> *sectionTitles;
@property (nonatomic, strong) NSMutableArray<NSArray<TeamNewTeammateInfo *> *> *showNewTeammateList;

//搜索
@property (nonatomic, strong) NSArray<TeamNewTeammateInfo *> *searchTeammateList;
@property (nonatomic, assign, getter=isSearching) BOOL searching;
@property (nonatomic, strong) TeammateSearchRequest *teammateSearchRequest;

@end

@implementation GBNewTeammateViewController

- (void)dealloc{
    
   
}

- (void)localizeUI {
    self.searchTextField.placeholder = LS(@"friend.searchbox.number");
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - Analytics

- (NSString *)pageName {
    return Analy_Page_Team_Add;
}

#pragma mark - Action
// 点击按下搜索按钮
- (IBAction)actionPressSearch:(id)sender {
    
    self.searching = self.searchTextField.text.length>0;
    [self getFirstPageDataList];
}

#pragma mark - Private

-(void)setupUI
{
    self.title = LS(@"team..teammate.new.teammate");
    [self setupBackButtonWithBlock:nil];
    
    self.searchTextField.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"GBNewTeammateCell" bundle:nil] forCellReuseIdentifier:@"GBNewTeammateCell"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.emptyScrollView = self.tableView;
    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        if (self.searching) {
            [self getFirstPageDataList];
        }else {
            [self getTeamNewTeammateInfo];
        }
    }];
    mj_header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.tableView.mj_header = mj_header;
}

- (void)getTeamNewTeammateInfo {
    
    @weakify(self)
    [TeamRequest getTeamNewTeammateInfoWithHandler:^(id result, NSError *error) {
        
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
            self.userApplyList = nil;
            self.myFriendList = nil;
        }else {
            TeamNewTeammateResponse *data = result;
            self.userApplyList = data.apply_list;
            self.myFriendList = data.friend_List;
        }
    }];
}

- (void)getNextPageDataList {
    
    @weakify(self)
    [self.teammateSearchRequest loadNextPageWithHandle:^(id result, NSError *error) {
        @strongify(self)
        if (!error) {
            self.searchTeammateList = self.teammateSearchRequest.responseInfo.items;
            [self.tableView reloadData];
        } else {
            [self.tableView reloadData];
        }
    }];
}

- (void)getFirstPageDataList {
    
    [self.searchTextField resignFirstResponder];
    NSString *search = [self.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([NSString stringIsNullOrEmpty:search]) {
        //        [self showToastWithText:LS(@"friend.searchbox.number")];
        //        [self.tableView.mj_header endRefreshing];
        // 搜索内容为空的情况重新获取列表
        [self showLoadingToast];
        [self getTeamNewTeammateInfo];
        return;
    }
    self.teammateSearchRequest.searchPhone = search;
    [self showLoadingToast];
    @weakify(self)
    [self.teammateSearchRequest reloadPageWithHandle:^(id result, NSError *error) {
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
            [self.tableView reloadData];
        }else {
            self.searchTeammateList = self.teammateSearchRequest.responseInfo.items;
            self.isShowEmptyView = self.searchTeammateList.count == 0;
            [self.tableView reloadData];
        }
    }];
}

- (void)disposeFriendInvite:(TeamNewTeammateInfo *)friendInfo agree:(BOOL)agree {
    
    [self showLoadingToast];
    @weakify(self)
    [TeamRequest disposeUserInvite:friendInfo.user_id agree:agree handler:^(id result, NSError *error) {
        @strongify(self)
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            if (self.isSearching) {
                if (agree) {
                    NSMutableArray *list = [NSMutableArray arrayWithArray:self.searchTeammateList];
                    [list removeObject:friendInfo];
                    self.searchTeammateList = [list copy];
                }else {
                    friendInfo.state = TeamNewTeammateState_Normal;
                }
                self.isShowEmptyView = (self.userApplyList.count+self.myFriendList.count==0);
                [self.tableView reloadData];
            }else {
                [self getTeamNewTeammateInfo];
            }
            if (agree) {
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Team_Need_Refresh object:nil];
            }
        }
    }];
}

- (TeamNewTeammateInfo *)friendInfoWithIndexPath:(NSIndexPath *)indexPath {
    
    @try {
        TeamNewTeammateInfo *info = self.isSearching?self.searchTeammateList[indexPath.row]:self.showNewTeammateList[indexPath.section][indexPath.row];
        
        return info;
    } @catch (NSException *exception) {
        return nil;
    }
    
}

#pragma mark - Getters & Setters

- (void)setMyFriendList:(NSArray<TeamNewTeammateInfo *> *)myFriendList {
    
    _myFriendList = myFriendList;
    _showNewTeammateList = [NSMutableArray arrayWithCapacity:1];
    _sectionTitles = [NSMutableArray arrayWithCapacity:1];
    if (_myFriendList.count>0 && _userApplyList.count>0) {
        [_showNewTeammateList addObject:_userApplyList];
        [_showNewTeammateList addObject:_myFriendList];
        [_sectionTitles addObject:LS(@"team.teammate.apply")];
        [_sectionTitles addObject:LS(@"team.teammate.my.friend")];
    }else if(_userApplyList.count>0){
        [_showNewTeammateList addObject:_userApplyList];
        [_sectionTitles addObject:LS(@"team.teammate.apply")];
    }else if (_myFriendList.count>0) {
        [_showNewTeammateList addObject:_myFriendList];
        [_sectionTitles addObject:LS(@"team.teammate.my.friend")];
    }
    
    self.isShowEmptyView = (_showNewTeammateList.count==0);
    [self.tableView reloadData];
}

- (TeammateSearchRequest *)teammateSearchRequest {
    
    if (!_teammateSearchRequest) {
        _teammateSearchRequest = [[TeammateSearchRequest alloc] init];
    }
    
    return _teammateSearchRequest;
}

#pragma mark - Table Delegate

// section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.isSearching?1:self.sectionTitles.count;
}

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.isSearching?self.searchTeammateList.count:self.showNewTeammateList[section].count;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeamNewTeammateInfo *info = [self friendInfoWithIndexPath:indexPath];
    
    GBNewTeammateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBNewTeammateCell"];
    cell.delegate = self;
    [cell refreshWithName:info.nick_name imageUrl:info.image_url];
    if (info.state == TeamNewTeammateState_Invited) {
        cell.joinedLabel.hidden = YES;
        cell.refuseBtn.hidden = NO;
        cell.acceptBtn.hidden = NO;
        [cell.acceptBtn setTitle:LS(@"common.btn.agree") forState:UIControlStateNormal];
    }else if(info.state == TeamNewTeammateState_Normal) {
        cell.joinedLabel.hidden = YES;
        cell.refuseBtn.hidden = YES;
        cell.acceptBtn.hidden = NO;
        [cell.acceptBtn setTitle:LS(@"team.teammate.invite") forState:UIControlStateNormal];
    }else {
        cell.refuseBtn.hidden = YES;
        cell.acceptBtn.hidden = YES;
        cell.joinedLabel.hidden = NO;
        NSString *title = [NSString stringWithFormat:@"%@%@", LS(@"inivte-joined.title"), info.team_name];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x5b5b5b] range:[title rangeOfString:LS(@"inivte-joined.title")]];
        cell.joinedLabel.attributedText = [attributedString copy];
    }

    return cell;
    
}
// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 63.f;
}

// section头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.isSearching?0.1:36.f;
}

// section的title
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.isSearching?@"":self.sectionTitles[section];
}

// 设置SectionHeader风格与样式
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor= [UIColor colorWithHex:0x171717];
    header.textLabel.font = [UIFont fontWithName:header.textLabel.font.fontName size:14.f];
    [header.textLabel setTextColor:[UIColor colorWithHex:0x909090]];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSearching && ![self.teammateSearchRequest isLoadEnd] &&
        self.teammateSearchRequest.responseInfo.items.count-1 == indexPath.row) {
        [self getNextPageDataList];
    }
}

#pragma mark - Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    self.searching = textField.text.length>0;
    if ([string isEqualToString:@"\n"]) {
        //搜索好友
        [self getFirstPageDataList];
        return NO;
    }
    return YES;
}

- (void)didAcceptCell:(GBNewTeammateCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    TeamNewTeammateInfo *info = [self friendInfoWithIndexPath:indexPath];
    if (info.state == TeamNewTeammateState_Invited) {
        [self disposeFriendInvite:info agree:YES];
    }else {
        [self showLoadingToast];
        @weakify(self)
        [TeamRequest inviteNewTeammate:info.user_id handler:^(id result, NSError *error) {
            @strongify(self)
            [self dismissToast];
            if (error) {
                [self showToastWithText:error.domain];
            }else {
                [self showToastWithText:LS(@"team.teammate.has.invite.tips")];
            }
        }];
    }
    
}

-(void)didRefuseCell:(GBNewTeammateCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    TeamNewTeammateInfo *info = [self friendInfoWithIndexPath:indexPath];
    [self disposeFriendInvite:info agree:NO];
}


@end
