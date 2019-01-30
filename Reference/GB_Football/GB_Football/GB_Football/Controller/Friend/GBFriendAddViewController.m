//
//  GBFriendAddViewController.m
//  GB_Football
//
//  Created by 王时温 on 2017/5/26.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBFriendAddViewController.h"
#import "GBBaseViewController+Empty.h"

#import "GBAddressCell.h"
#import "UITableViewRowAction+JZExtension.h"
#import "MJRefresh.h"

#import "AddressBookObject.h"
#import "FriendRequest.h"
#import "FriendSearchRequest.h"

@interface GBFriendAddViewController ()<
GBAddressCellDelegate,
UITextFieldDelegate>

// 表头视图
@property (strong, nonatomic) IBOutlet UIView *tableHeader;
// 表控件
@property (weak, nonatomic)   IBOutlet UITableView *tableView;
// 搜索输入框
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

//通讯录
@property (nonatomic, strong) NSArray<NSString *> *phoneList;
@property (nonatomic, strong) NSArray<FriendInfo *> *addressBookList;

//搜索
@property (nonatomic, assign, getter=isSearching) BOOL searching;
@property (nonatomic, strong) NSArray<FriendInfo *> *searchFriendList;
@property (nonatomic, strong) FriendSearchRequest *friendSearchRequest;

@end

@implementation GBFriendAddViewController

- (void)localizeUI {
    self.searchTextField.placeholder = LS(@"friend.searchbox.number");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.tableHeader.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,(208.f/1334)*[UIScreen mainScreen].bounds.size.height);
        [self.tableView setTableHeaderView:self.tableHeader];
    });
}

#pragma mark - Action
// 点击按下搜索按钮
- (IBAction)actionPressSearch:(id)sender {
    
    [self searchFriend];
}

#pragma mark - Private

- (void)setupUI {
    
    self.title = LS(@"inivte-add-friend.title");
    [self setupBackButtonWithBlock:nil];
    
    self.searchTextField.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"GBAddressCell" bundle:nil] forCellReuseIdentifier:@"GBAddressCell"];
    self.tableView.tableHeaderView = self.tableHeader;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.emptyScrollView = self.tableView;
}

- (void)loadData {
    
    self.phoneList = [AddressBookObject getAddrBookPhoneList];
    [self getAddressBookFriendList];
}

- (void)getAddressBookFriendList {
    
    [self showLoadingToast];
    @weakify(self)
    [FriendRequest getAddressBookFriendList:self.phoneList handler:^(id result, NSError *error) {
        
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
            self.addressBookList = nil;
        }else {
            FriendListDataInfo *data = result;
            self.addressBookList = data.addressBookList;
        }
    }];
}

- (void)searchFriend {
    
    [self.searchTextField resignFirstResponder];
    NSString *search = [self.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([NSString stringIsNullOrEmpty:search]) {
        
        [self showLoadingToast];
        [self getAddressBookFriendList];
        return;
    }
    self.friendSearchRequest.searchPhone = search;
    [self showLoadingToast];
    @weakify(self)
    [self.friendSearchRequest reloadPageWithHandle:^(id result, NSError *error) {
        @strongify(self)
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

- (FriendInfo *)friendInfoWithIndexPath:(NSIndexPath *)indexPath {
    
    @try {
        FriendInfo *info = self.isSearching?self.searchFriendList[indexPath.row]:self.addressBookList[indexPath.row];
        
        return info;
    } @catch (NSException *exception) {
        return nil;
    }
    
}

#pragma mark - Getters & Setters


- (void)setAddressBookList:(NSArray<FriendInfo *> *)addressBookList {
    
    _addressBookList = addressBookList;
    self.isShowEmptyView = (_addressBookList.count==0);
    [self.tableView reloadData];
}
- (FriendSearchRequest *)friendSearchRequest {
    
    if (!_friendSearchRequest) {
        _friendSearchRequest = [[FriendSearchRequest alloc] init];
    }
    
    return _friendSearchRequest;
}

#pragma mark - Table Delegate

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.isSearching?self.searchFriendList.count:self.addressBookList.count;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendInfo *info = [self friendInfoWithIndexPath:indexPath];
    GBAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBAddressCell"];
    cell.delegate = self;
    [cell refreshWithName:info.nickName imageUrl:info.imageUrl];

    return cell;
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
    return self.isSearching?@"":LS(@"frient.label.address");
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
    if (![self.friendSearchRequest isLoadEnd] &&
        self.friendSearchRequest.responseInfo.items.count-1 == indexPath.row) {
        [self getNextFriendList];
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

- (void)GBAddressCell:(GBAddressCell *)cell {
    
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
