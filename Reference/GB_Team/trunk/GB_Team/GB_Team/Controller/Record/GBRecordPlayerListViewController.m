//
//  GBRecordPlayerListViewController.m
//  GB_Team
//
//  Created by Pizza on 16/9/19.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBRecordPlayerListViewController.h"
#import "GBRecordPlayerCell.h"
#import "GBRecordPlayerDetailViewController.h"
#import "GBHomePageViewController.h"
#import "GBSortPan.h"
#import "MatchRequest.h"

@interface GBRecordPlayerListViewController ()<
GBSortPanDelegate,
UITableViewDataSource,
UITableViewDataSource>

// 表格
@property (weak, nonatomic) IBOutlet UITableView *tableView;
// 排序控件
@property (nonatomic, strong) IBOutlet GBSortPan *sortPan;

// 短信发送按钮
@property (nonatomic, strong) UIButton *sendButton;
// 获取的比赛详细信息
@property (nonatomic, strong) MatchDetailInfo *matchInfo;

@end

@implementation GBRecordPlayerListViewController

- (instancetype)initWithMatchId:(NSInteger)matchId {
    
    if (self = [super init]) {
        _matchId = matchId;
    }
    return self;
}

- (void)dealloc{
    
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

- (void)setMatchId:(NSInteger)matchId {
    
    _matchId = matchId;
    [self loadData];
}

#pragma mark - Life Cycle


#pragma mark - Action
- (void)actionSendPress {
    [self showLoadingToast];
    @weakify(self)
    [MatchRequest sendMatchShortMessage:self.matchId playerId:0 handler:^(id result, NSError *error) {
        @strongify(self)
        [self dismissToast];
        
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            [self showToastWithText:LS(@"短信已经发送成功")];
        }
    }];
}

#pragma mark - Notification

#pragma mark - Private

- (void)setupUI {
    
    self.title = LS(@"球员信息");
    [self setupBackButtonWithBlock:nil];
    [self setupRightButton];
    [self setupTableView];
    [self setupSortPan];
}

- (void)setupRightButton {
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendButton setSize:CGSizeMake(100, 44)];
    [self.sendButton.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    [self.sendButton setTitle:LS(@"短信分享") forState:UIControlStateNormal];
    [self.sendButton setTitle:LS(@"短信分享") forState:UIControlStateHighlighted];
    [self.sendButton setTitleColor:[ColorManager textColor] forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[ColorManager disableColor] forState:UIControlStateDisabled];
    self.sendButton.backgroundColor = [UIColor clearColor];
    self.sendButton.hidden = YES;
    [self.sendButton addTarget:self action:@selector(actionSendPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:self.sendButton];
    [self.navigationItem setRightBarButtonItem:rightButton];
}

- (void)loadData {

    [self showLoadingToast];
    @weakify(self)
    [MatchRequest getMatchInfo:self.matchId handler:^(id result, NSError *error) {
        @strongify(self)
        [self dismissToast];
        
        if (error) {
            [self showToastWithText:error.domain];
            [self.tableView reloadData];
        }else {
            self.matchInfo = result;
            self.isShowEmptyView = self.matchInfo.playerList.count == 0;
            [self checkSendValid];
            [self sortWithDistance];
            [self.tableView reloadData];
        }
    }];
}

- (void)setupTableView {
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"GBRecordPlayerCell" bundle:nil] forCellReuseIdentifier:@"GBRecordPlayerCell"];
    
    self.emptyScrollView = self.tableView;
}

- (void)setupSortPan {
    
    [self.sortPan setIndex:0];
    self.sortPan.delegate = self;
}

- (void)sortWithDistance {
    
    self.matchInfo.playerList = [self.matchInfo.playerList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        MatchPlayerInfo *info1 = obj1;
        MatchPlayerInfo *info2 = obj2;
        if (info1.move_distance > info2.move_distance) {
            return NSOrderedAscending;
        }else if (info1.move_distance < info2.move_distance){
            return NSOrderedDescending;
        }else {
            return NSOrderedSame;
        }
    }];
    
    [self.tableView reloadData];
}

- (void)sortWithSpeed {
    
    self.matchInfo.playerList = [self.matchInfo.playerList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        MatchPlayerInfo *info1 = obj1;
        MatchPlayerInfo *info2 = obj2;
        if (info1.max_speed > info2.max_speed) {
            return NSOrderedAscending;
        }else if (info1.max_speed < info2.max_speed){
            return NSOrderedDescending;
        }else {
            return NSOrderedSame;
        }
    }];
    
    [self.tableView reloadData];
}

- (void)sortWithPhysical {
    
    self.matchInfo.playerList = [self.matchInfo.playerList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        MatchPlayerInfo *info1 = obj1;
        MatchPlayerInfo *info2 = obj2;
        if (info1.pc > info2.pc) {
            return NSOrderedAscending;
        }else if (info1.pc < info2.pc){
            return NSOrderedDescending;
        }else {
            return NSOrderedSame;
        }
    }];
    
    [self.tableView reloadData];
}

- (void)checkSendValid {
    Boolean isValid = YES;
    // 只要有一个有电话号码才可以使用
    if (self.matchInfo != nil) {
        for (MatchPlayerInfo *playerInfo in self.matchInfo.playerList) {
            if (![NSString stringIsNullOrEmpty:playerInfo.phone]) {
                isValid = NO;
                break;
            }
        }
    }
    
    self.sendButton.hidden = isValid;
}

#pragma mark - Delegate

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.matchInfo == nil ? 0 : [self.matchInfo.playerList count];
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GBRecordPlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBRecordPlayerCell"];
    
    MatchPlayerInfo *playerInfo = self.matchInfo.playerList[indexPath.row];
    [cell refreshWithMatchPlayerInfo:playerInfo];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MatchPlayerInfo *playerInfo = self.matchInfo.playerList[indexPath.row];
    [self.navigationController pushViewController:[[GBRecordPlayerDetailViewController alloc] initWithMatchPlayer:playerInfo matchInfo:self.matchInfo.matchMess] animated:YES];
}

#pragma mark GBSortPanDelegate

- (void)GBSortPan:(GBSortPan *)sorPan index:(NSInteger)index {
    
    // 排序控件
    switch (index) {
        case 0:
            [self sortWithDistance];
            break;
        case 1:
            [self sortWithSpeed];
            break;
        case 2:
            [self sortWithPhysical];
            break;
            
        default:
            break;
    }
}

@end
