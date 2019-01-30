//
//  GBMyFriendViewController.m
//  GB_Football
//
//  Created by Pizza on 16/8/15.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBMyFriendViewController.h"
#import "GBBaseViewController+Empty.h"
#import "GBFriendCell.h"
#import "AIMTableViewIndexBar.h"
#import "GBPersonDefaultCardViewController.h"
#import "MJRefresh.h"
#import <pop/POP.h>

#import "FriendRequest.h"

#define DELETEBAR_HEIGHT 56.f

@interface GBMyFriendViewController ()<
AIMTableViewIndexBarDelegate,
UITextFieldDelegate>
// 表头视图
@property (strong, nonatomic) IBOutlet UIView *tableHeader;
// 表控件
@property (weak, nonatomic)   IBOutlet UITableView *tableView;
// 搜索输入框
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
// 索引条
@property (strong, nonatomic) IBOutlet AIMTableViewIndexBar *indexBar;

//接口数据
@property (nonatomic, strong) NSMutableArray<FriendInfo *> *friendList;

//显示
@property (nonatomic, strong) NSArray<NSArray<FriendInfo *> *> *sectionFriendList;
@property (nonatomic, strong) NSArray<NSString *> *firstLetterList;

//搜索
@property (nonatomic, strong) NSMutableArray<FriendInfo *> *searchFriendList;
@property (nonatomic, assign, getter=isSearching) BOOL searching;

//删除
@property (nonatomic, strong) NSMutableArray<FriendInfo *> *deleteFriendList;


@end

@implementation GBMyFriendViewController

#pragma mark -
#pragma mark Memory

#pragma mark - Life Cycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)localizeUI {
    self.searchTextField.placeholder = LS(@"friend.searchbox.number");
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidEndEdit:) name:UITextFieldTextDidEndEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidBeginEdit:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptFriendNotification) name:Notification_Friend_Accept object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notFriendNotification) name:Notification_Friend_Not_Friend object:nil];
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
    
    self.searching = NO;
    self.searchFriendList = nil;
    self.searchTextField.text = @"";
    [self hideIndexBar:NO];
    [self.searchTextField resignFirstResponder];
}

#pragma mark - Notification

- (void)textFieldTextDidChange:(NSNotification *)notification {
    
    if (notification.object != self.searchTextField) {
        return;
    }
    [self searchFriend:self.searchTextField.text];
}

- (void)textFieldTextDidEndEdit:(NSNotification *)notification {
    
    if (notification.object != self.searchTextField) {
        return;
    }
    [self hideIndexBar:self.isSearching];
}

- (void)textFieldTextDidBeginEdit:(NSNotification *)notification {
    
    if (notification.object != self.searchTextField) {
        return;
    }
    [self hideIndexBar:YES];
}

- (void)acceptFriendNotification {
    
    [self getFriendList];
}

- (void)notFriendNotification {
    
    [self getFriendList];
}

#pragma mark - Action

// 点击按下搜索按钮
- (IBAction)actionPressSearch:(id)sender {
    
    [self.searchTextField resignFirstResponder];
}

#pragma mark - Private

-(void)setupUI
{
    self.indexBar.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GBFriendCell" bundle:nil] forCellReuseIdentifier:@"GBFriendCell"];
    self.tableView.tableHeaderView = self.tableHeader;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = YES;
    self.emptyScrollView = self.tableView;
    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self getFriendList];
    }];
    mj_header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.tableView.mj_header = mj_header;
    
    self.searchTextField.delegate = self;
}


- (void)getFriendList {
    
    if (self.isSearching) {
        [self.tableView.mj_header endRefreshing];
        return;
    }
    
    @weakify(self)
    [FriendRequest getFriendListWithHandler:^(id result, NSError *error) {
        
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            FriendListDataInfo *data = result;
            self.friendList = [data.friendList mutableCopy];
            self.isShowEmptyView = self.friendList.count==0;
            [self analyseFirstLetter];
            [self.tableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:MyFirenCountChangeNotification object:@(self.friendList.count)];
        }
    }];
}

- (void)searchFriend:(NSString *)search {
    
    search = [search stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSMutableArray *searchList = [NSMutableArray arrayWithCapacity:1];
    for (FriendInfo *info in self.friendList) {
        if ([info.nickName containsString:search] || [info.phone hasPrefix:search]) {
            [searchList addObject:info];
        }
    }
    self.searchFriendList = searchList;
    self.searching = (self.searchFriendList.count>0 || self.searchTextField.text.length>0);
    [self.tableView reloadData];
}

- (void)deleteFriendWithIndexPath:(NSIndexPath *)indexPath {
    
    FriendInfo *info = nil;
    if (self.isSearching) {
        info = self.searchFriendList[indexPath.row];
        [self.searchFriendList removeObject:info];
    }else {
        info = [self.sectionFriendList[indexPath.section] objectAtIndex:indexPath.row];
    }
    [self.friendList removeObject:info];
    self.isShowEmptyView = self.friendList.count==0;
    [self analyseFirstLetter];
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MyFirenCountChangeNotification object:@(self.friendList.count)];
}

- (void)analyseFirstLetter {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (FriendInfo *info in self.friendList) {
        
        NSString *firstLetter = [info.nickName firstCharPinyinFirstLetter];
        NSMutableArray *list = [dic objectForKey:firstLetter];
        if (!list) {
            list = [NSMutableArray array];
            [dic setObject:list forKey:firstLetter];
        }
        [list addObject:info];
    }
    
    NSArray *letterList = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#"];
    NSMutableArray *friendList = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *firstCharList = [NSMutableArray array];
    for (NSString *string in letterList) {
        id obj = dic[string];
        if (obj) {
            [friendList addObject:obj];
            [firstCharList addObject:string];
        }
    }
    self.sectionFriendList = friendList;
    self.firstLetterList = firstCharList;
    
    [self.indexBar setIndexes:self.firstLetterList];
}

- (void)hideIndexBar:(BOOL)hide {
    
    self.indexBar.hidden = hide;
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.width = hide?self.view.width:self.view.width-self.indexBar.width;
    }];
}

#pragma mark - Delegate
#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"]) {
        //收起键盘
        [self.searchTextField resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark UITableViewDelegate

// section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.isSearching?1:self.firstLetterList.count;
}

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.isSearching?self.searchFriendList.count:self.sectionFriendList[section].count;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GBFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBFriendCell"];
    // 最后一个cell的分割线需要特殊处理
    FriendInfo *info = self.isSearching?self.searchFriendList[indexPath.row]:[self.sectionFriendList[indexPath.section] objectAtIndex:indexPath.row];
    [cell refreshWithName:info.nickName imageUrl:info.imageUrl];
    cell.isLastCell = (indexPath.row == self.isSearching?self.searchFriendList.count-1:self.sectionFriendList[indexPath.section].count-1?YES:NO);
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
    return self.isSearching?0.1f:17.f;
}

// section的title
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.isSearching?@"":self.firstLetterList[section];
}

// 设置SectionHeader风格与样式
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor= [UIColor blackColor];
    header.textLabel.font = [UIFont fontWithName:header.textLabel.font.fontName size:10.f];
    [header.textLabel setTextColor:[UIColor whiteColor]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GBPersonDefaultCardViewController *vc = [[GBPersonDefaultCardViewController alloc] init];
    FriendInfo *info = self.isSearching?self.searchFriendList[indexPath.row]:[self.sectionFriendList[indexPath.section] objectAtIndex:indexPath.row];
    vc.userId = info.userId;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

//ios 8必须重写否则无法左滑删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
//TODO: 可删除？
    [self setEditing:false animated:true];
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @weakify(self)
    void(^rowActionHandler)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        @strongify(self)
        FriendInfo *info = [self.sectionFriendList[indexPath.section] objectAtIndex:indexPath.row];
        [self showLoadingToast];
        [FriendRequest deleteFriend:info.userId handler:^(id result, NSError *error) {
            
            [self dismissToast];
            if (error) {
                [self showToastWithText:error.domain];
            }else {
                [self deleteFriendWithIndexPath:indexPath];
            }
        }];
    };
    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:LS(@"common.btn.delete") handler:rowActionHandler];
    return @[action2];
    
}

#pragma mark  AIMTableViewIndexBarDelegate

- (void)tableViewIndexBar:(AIMTableViewIndexBar *)indexBar didSelectSectionAtIndex:(NSInteger)index
{
    if ([self.tableView numberOfSections] > index && index > -1){   // for safety, should always be YES
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
    }
}


@end
