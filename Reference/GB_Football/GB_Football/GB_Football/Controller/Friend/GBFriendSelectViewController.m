//
//  GBFriendSelectViewController.m
//  GB_Football
//
//  Created by 王时温 on 2017/5/26.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBFriendSelectViewController.h"
#import "GBBaseViewController+Empty.h"
#import "GBFriendAddViewController.h"

#import "GBFriendSelectCell.h"
#import "AIMTableViewIndexBar.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"

#import "FriendRequest.h"
#import "MatchRequest.h"

@interface GBFriendSelectViewController ()<
AIMTableViewIndexBarDelegate,
UITextFieldDelegate>
// 表控件
@property (weak, nonatomic)   IBOutlet UITableView *tableView;
// 搜索输入框
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UILabel *addFriendTitleLabel;
// 索引条
@property (strong, nonatomic) IBOutlet AIMTableViewIndexBar *indexBar;

//接口数据
@property (nonatomic, strong) NSMutableArray<FriendInfo *> *friendList;

@property (nonatomic, strong) UIButton *saveButton;

//显示
@property (nonatomic, strong) NSArray<NSArray<FriendInfo *> *> *sectionFriendList;
@property (nonatomic, strong) NSArray<NSString *> *firstLetterList;

//搜索
@property (nonatomic, strong) NSMutableArray<FriendInfo *> *searchFriendList;
@property (nonatomic, assign, getter=isSearching) BOOL searching;

//删除
@property (nonatomic, strong) NSMutableArray<FriendInfo *> *selectedFriendList;

@end

@implementation GBFriendSelectViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithSelectedFriendList:(NSArray<FriendInfo *> *)friendList {
    
    self = [super init];
    if (self) {
        self.selectedFriendList = [NSMutableArray arrayWithArray:friendList];
    }
    return self;
}

- (void)localizeUI {
    
    self.searchTextField.placeholder = LS(@"friend.searchbox.number");
    self.addFriendTitleLabel.text = LS(@"inivte-add-friend.title");
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

- (void)someOneAcceptFriendNotification {
    
    [self getFriendList];
}

#pragma mark - Action

- (void)actionCancel {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)actionSave {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Friend_Match_Friend_Selected object:[self.selectedFriendList copy]];
    [self actionCancel];
}

- (IBAction)actionSearch:(id)sender {
    
    [self.searchTextField becomeFirstResponder];
}

- (IBAction)actionAddFriend:(id)sender {
    
    [self.navigationController pushViewController:[GBFriendAddViewController new] animated:YES];
}

#pragma mark - Private

- (void)setupNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidEndEdit:) name:UITextFieldTextDidEndEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidBeginEdit:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(someOneAcceptFriendNotification) name:Notification_Friend_SomeOne_add_RightAway object:nil];
}

- (void)loadData {
    
    [self getFriendList];
}

-(void)setupUI
{
    self.title = LS(@"inivte-invite-friend.title");
    [self setupNavigationBarLeft];
    [self setupNavigationBarRight];
    [self checkSaveButtonValid];
    
    self.indexBar.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GBFriendSelectCell" bundle:nil] forCellReuseIdentifier:@"GBFriendSelectCell"];
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

- (void)getFriendList {
    
    [self showLoadingToast];
    @weakify(self)
    [FriendRequest getInviteMatchFriendListHandler:^(id result, NSError *error) {
        
        @strongify(self)
        [self dismissToast];
        [self.tableView.mj_header endRefreshing];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            NSArray *list = result;
            self.friendList = [list mutableCopy];
            self.isShowEmptyView = self.friendList.count==0;
            [self analyseFirstLetter];
            [self.tableView reloadData];
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

- (void)clearSearchResult {
    
    self.searching = NO;
    self.searchFriendList = nil;
    self.searchTextField.text = @"";
    [self hideIndexBar:NO];
    [self.searchTextField resignFirstResponder];
}

- (void)checkSaveButtonValid {
    
    NSString *title = [NSString stringWithFormat:@"%@(%td)", LS(@"invite-friend-nav-right-title"), self.selectedFriendList.count];
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToHeight:24];
    self.saveButton.size = size;
    [self.saveButton setTitle:title forState:UIControlStateNormal];
    [self.saveButton setTitle:title forState:UIControlStateDisabled];
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
    GBFriendSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBFriendSelectCell"];
    // 最后一个cell的分割线需要特殊处理
    FriendInfo *info = self.isSearching?self.searchFriendList[indexPath.row]:[self.sectionFriendList[indexPath.section] objectAtIndex:indexPath.row];
    cell.userNameLabel.text = info.nickName;
    [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:info.imageUrl]
                          placeholderImage:[UIImage imageNamed:@"portrait"]];
    BOOL isContain = NO;
    //是否包含
    {
        for (FriendInfo *tmpInfo in self.selectedFriendList) {
            if (tmpInfo.userId == info.userId) {
                isContain = YES;
                break;
            }
        }
    }
    if (info.inviteStatus == FriendInviteMatchStatus_invited) {
        cell.type = GBFriendSelectCell_NotSelected;
    }else {
        cell.type = isContain?GBFriendSelectCell_Selected:GBFriendSelectCell_UnSelected;
    }
    
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
    
    GBFriendSelectCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    FriendInfo *info = self.isSearching?self.searchFriendList[indexPath.row]:[self.sectionFriendList[indexPath.section] objectAtIndex:indexPath.row];
    if (cell.type == GBFriendSelectCell_Selected) {
        cell.type = GBFriendSelectCell_UnSelected;
        FriendInfo *removeFriendInfo = nil;
        for (FriendInfo *tmpInfo in self.selectedFriendList) {
            if (tmpInfo.userId == info.userId) {
                removeFriendInfo = tmpInfo;
                break;
            }
        }
        if (removeFriendInfo) {
            [self.selectedFriendList removeObject:removeFriendInfo];
        }
    }else if (cell.type == GBFriendSelectCell_UnSelected) {
        cell.type = GBFriendSelectCell_Selected;
        [self.selectedFriendList addObject:info];
    }
    [self checkSaveButtonValid];
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
