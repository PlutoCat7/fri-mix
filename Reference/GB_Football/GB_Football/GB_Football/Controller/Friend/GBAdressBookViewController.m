//
//  GBAdressBookViewController.m
//  GB_Football
//
//  Created by Pizza on 16/8/15.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBAdressBookViewController.h"
#import "GBFriendInviteCell.h"
#import "GBAddressCell.h"
#import "FriendRequest.h"
#import "FriendSearchRequest.h"
#import "UITableViewRowAction+JZExtension.h"
#import "MJRefresh.h"
#import "AddressBookObject.h"

#import "GBBaseViewController+Empty.h"

@interface GBAdressBookViewController ()<
GBFriendInviteCellDelegate,
GBAddressCellDelegate,
UITextFieldDelegate>

// 表头视图
@property (strong, nonatomic) IBOutlet UIView *tableHeader;
// 表控件
@property (weak, nonatomic)   IBOutlet UITableView *tableView;
// 搜索输入框
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

//接口数据
@property (nonatomic, strong) NSArray<FriendInfo *> *friendApplyList;
@property (nonatomic, strong) NSArray<FriendInfo *> *addressBookList;

//显示
@property (nonatomic, strong) NSArray<NSString *> *phoneList;
@property (nonatomic, strong) NSMutableArray<NSString *> *sectionTitles;
@property (nonatomic, strong) NSMutableArray<NSArray<FriendInfo *> *> *showFriendList;

//搜索
@property (nonatomic, strong) NSArray<FriendInfo *> *searchFriendList;
@property (nonatomic, assign, getter=isSearching) BOOL searching;
@property (nonatomic, strong) FriendSearchRequest *friendSearchRequest;

@end

@implementation GBAdressBookViewController

#pragma mark -
#pragma mark Memory

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)localizeUI {
    self.searchTextField.placeholder = LS(@"friend.searchbox.number");
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(someOneAddFriednNotification) name:Notification_Friend_SomeOne_add object:nil];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tableHeader.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,(208.f/1334)*[UIScreen mainScreen].bounds.size.height);
    [self.tableView setTableHeaderView:self.tableHeader];
}

#pragma mark - PageViewController Method

- (void)initPageData {
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - Public

- (void)clearSearchResult {
    [self.searchTextField resignFirstResponder];
}

#pragma mark - Notification

- (void)someOneAddFriednNotification {
    
    [self getFriendList];
}

#pragma mark - Action
// 点击按下搜索按钮
- (IBAction)actionPressSearch:(id)sender {
    
    self.searching = self.searchTextField.text.length>0;
    [self searchFriend];
}

#pragma mark - Private

-(void)setupUI
{
    self.searchTextField.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"GBFriendInviteCell" bundle:nil] forCellReuseIdentifier:@"GBFriendInviteCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GBAddressCell" bundle:nil] forCellReuseIdentifier:@"GBAddressCell"];
    self.tableView.tableHeaderView = self.tableHeader;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.emptyScrollView = self.tableView;
    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        if (self.searching) {
            [self searchFriend];
        }else {
            [self getFriendList];
        }
    }];
    mj_header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.tableView.mj_header = mj_header;
}

- (void)loadData {
    
    self.phoneList = [AddressBookObject getAddrBookPhoneList];
}

- (void)getFriendList {
    
    @weakify(self)
    [FriendRequest getAddressBookFriendList:self.phoneList handler:^(id result, NSError *error) {
        
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
            self.friendApplyList = nil;
            self.addressBookList = nil;
        }else {
            FriendListDataInfo *data = result;
            self.friendApplyList = data.friendApplyList;
            self.addressBookList = data.addressBookList;
        }
    }];
}

- (void)searchFriend {
    
    [self.searchTextField resignFirstResponder];
    NSString *search = [self.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([NSString stringIsNullOrEmpty:search]) {
//        [self showToastWithText:LS(@"friend.searchbox.number")];
//        [self.tableView.mj_header endRefreshing];
        // 搜索内容为空的情况重新获取列表
        [self showLoadingToast];
        [self getFriendList];
        return;
    }
    self.friendSearchRequest.searchPhone = search;
    [self showLoadingToast];
    @weakify(self)
    [self.friendSearchRequest reloadPageWithHandle:^(id result, NSError *error) {
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
            [self.tableView reloadData];
        }else {
            self.searchFriendList = self.friendSearchRequest.responseInfo.items;
            self.isShowEmptyView = self.searchFriendList.count == 0;
            [self.tableView reloadData];
        }
    }];
}

- (void)getNextFriendList {
    
    @weakify(self)
    [self.friendSearchRequest loadNextPageWithHandle:^(id result, NSError *error) {
        @strongify(self)
        if (!error) {
            self.searchFriendList = self.friendSearchRequest.responseInfo.items;
            [self.tableView reloadData];
        } else {
            [self.tableView reloadData];
        }
    }];
}

- (void)disposeFriendInvite:(FriendInfo *)friendInfo agree:(BOOL)agree {
    
    [self showLoadingToast];
    @weakify(self)
    [FriendRequest disposeFriendInvite:friendInfo.userId agree:agree handler:^(id result, NSError *error) {
        @strongify(self)
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            if (self.isSearching) {
                if (agree) {
                    NSMutableArray *list = [NSMutableArray arrayWithArray:self.searchFriendList];
                    [list removeObject:friendInfo];
                    self.searchFriendList = [list copy];
                }else {
                    friendInfo.status = FriendStatus_Addable;
                }
                self.isShowEmptyView = (self.friendApplyList.count+self.addressBookList.count==0);
                [self.tableView reloadData];
            }else {
                [self getFriendList];
            }
            if (agree) {
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Friend_Accept object:nil];
            }
        }
    }];
}

- (FriendInfo *)friendInfoWithIndexPath:(NSIndexPath *)indexPath {
    
    @try {
        FriendInfo *info = self.isSearching?self.searchFriendList[indexPath.row]:self.showFriendList[indexPath.section][indexPath.row];
        
        return info;
    } @catch (NSException *exception) {
        return nil;
    }
    
}

#pragma mark - Getters & Setters

- (void)setAddressBookList:(NSArray<FriendInfo *> *)addressBookList {
    
    _addressBookList = addressBookList;
    _showFriendList = [NSMutableArray arrayWithCapacity:1];
    _sectionTitles = [NSMutableArray arrayWithCapacity:1];
    if (_addressBookList.count>0 && _friendApplyList.count>0) {
        [_showFriendList addObject:_friendApplyList];
        [_showFriendList addObject:_addressBookList];
        [_sectionTitles addObject:LS(@"frient.label.invitation")];
        [_sectionTitles addObject:LS(@"frient.label.address")];
    }else if(_friendApplyList.count>0){
        [_showFriendList addObject:_friendApplyList];
        [_sectionTitles addObject:LS(@"frient.label.invitation")];
    }else if (_addressBookList.count>0) {
        [_showFriendList addObject:_addressBookList];
        [_sectionTitles addObject:LS(@"frient.label.address")];
    }
    
    self.isShowEmptyView = (_showFriendList.count==0);
    [self.tableView reloadData];
}

- (FriendSearchRequest *)friendSearchRequest {
    
    if (!_friendSearchRequest) {
        _friendSearchRequest = [[FriendSearchRequest alloc] init];
    }
    
    return _friendSearchRequest;
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
    return self.isSearching?self.searchFriendList.count:self.showFriendList[section].count;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendInfo *info = [self friendInfoWithIndexPath:indexPath];
    
    if (info.status == FriendStatus_Invited) {
        GBFriendInviteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBFriendInviteCell"];
        cell.delegate = self;
        [cell refreshWithName:info.nickName imageUrl:info.imageUrl];
        return cell;
    }else {
        GBAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBAddressCell"];
        cell.delegate = self;
        [cell refreshWithName:info.nickName imageUrl:info.imageUrl];
        
        return cell;
    }
    
    return nil;
    
}
// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.f;
}

// section头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.isSearching?0.1:17.f;
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
    header.contentView.backgroundColor= [UIColor blackColor];
    header.textLabel.font = [UIFont fontWithName:header.textLabel.font.fontName size:10.f];
    [header.textLabel setTextColor:[UIColor whiteColor]];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSearching && ![self.friendSearchRequest isLoadEnd] &&
        self.friendSearchRequest.responseInfo.items.count-1 == indexPath.row) {
        [self getNextFriendList];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FriendInfo *info = [self friendInfoWithIndexPath:indexPath];
    if (info.status == FriendStatus_Invited) {
        return YES;
    }else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self setEditing:false animated:true];

}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FriendInfo *info = [self friendInfoWithIndexPath:indexPath];
    if (info.status == FriendStatus_Invited) {
        @weakify(self)
        void(^rowActionHandler)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            @strongify(self)
            FriendInfo *info = [self friendInfoWithIndexPath:indexPath];
            [self disposeFriendInvite:info agree:NO];
            [self setEditing:false animated:true];
        };
        UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:LS(@"common.btn.delete") handler:rowActionHandler];
        return @[action2];
    }else {
        return nil;
    }
}

#pragma mark - Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    self.searching = textField.text.length>0;
    if ([string isEqualToString:@"\n"]) {
        //搜索好友
        [self searchFriend];
        return NO;
    }
    return YES;
}

- (void)GBFriendInviteCell:(GBFriendInviteCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    FriendInfo *info = [self friendInfoWithIndexPath:indexPath];
    [self disposeFriendInvite:info agree:YES];
}

-(void)GBAddressCell:(GBAddressCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    FriendInfo *info = [self friendInfoWithIndexPath:indexPath];
    [self showLoadingToast];
    @weakify(self)
    [FriendRequest addFriend:info.userId handler:^(id result, NSError *error) {
        @strongify(self)
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            [self showToastWithText:LS(@"frient.hint.invitation")];
        }
    }];
}



@end
