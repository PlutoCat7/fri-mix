//
//  GBMessageInvitedViewController.m
//  GB_Football
//
//  Created by 王时温 on 2017/6/1.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBMessageInvitedViewController.h"
#import "GBBaseViewController+Empty.h"

#import "MJRefresh.h"
#import "GBMessageInvitedCell.h"

#import "MatchLogic.h"

@interface GBMessageInvitedViewController () <
GBMessageInvitedCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *recordTable;

@property (nonatomic, strong) NSArray<MessageMatchInviteInfo *> *messageList;
@property (nonatomic, strong) MessageMatchInvitePageRequest *messagePageRequest;

@property (nonatomic, strong) NSMutableArray<MessageMatchInviteInfo *> *willDeleteMessageList;

@end

@implementation GBMessageInvitedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)setIsEdit:(BOOL)isEdit {
    
    _isEdit = isEdit;
    self.willDeleteMessageList = [NSMutableArray arrayWithCapacity:1];
    [self.recordTable reloadData];
}

- (void)removeMessageWithList:(NSArray *)list {
    
    _isEdit = NO;
    [self.willDeleteMessageList removeAllObjects];
    NSMutableArray *tmpList = [NSMutableArray arrayWithArray:self.messageList];
    [tmpList removeObjectsInArray:list];
    self.messageList = [tmpList copy];
    self.isShowEmptyView = self.messageList.count == 0;
    
    [self.recordTable reloadData];
}

#pragma mark - PageViewController Method

- (void)initPageData {
    
    [self.recordTable.mj_header beginRefreshing];
}

#pragma mark - Delegate

#pragma mark GBMessageInvitedCellDelegate

- (void)didClickJoinButton:(GBMessageInvitedCell *)cell {
    
    NSIndexPath *indexPath = [self.recordTable indexPathForCell:cell];
    MessageMatchInviteInfo *info = self.messageList[indexPath.row];
    
    [self showLoadingToast];
    @weakify(self)
    [MatchLogic joinMatchGameWithMatchId:info.match_id creatorId:info.creator_id handler:^(NSError *error) {
        
        @strongify(self)
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            info.matchMyState = MessageMatchInviteMyState_Join;
            [self.recordTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

#pragma mark UITableViewDelegate
// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageList.count;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GBMessageInvitedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBMessageInvitedCell"];
    cell.delegate = self;
    MessageMatchInviteInfo *info = self.messageList[indexPath.row];
    cell.matchNameLabel.text = info.match_name;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:info.create_time];
    NSString *dateString = [NSString stringWithFormat:@"%td-%02td-%02td", date.year, date.month, date.day];
    if ([date isToday]) {
        dateString = [NSString stringWithFormat:@"%02td:%02td", date.hour, date.minute];
    }
    cell.matchDateLabel.text = dateString;
    cell.createNameLabel.text = info.nick_name;
    cell.matchAddressLabel.text = info.court_address;
    cell.contentView.backgroundColor = (indexPath.row%2 == 0)?[UIColor colorWithHex:0x2c2f34]:[UIColor colorWithHex:0x41444d];
    if (info.matchState == MessageMatchInviteState_Completed) {
        cell.overLabel.hidden = NO;
        cell.joinButton.hidden = YES;
    }else {
        cell.overLabel.hidden = YES;
        cell.joinButton.hidden = NO;
        if (info.matchMyState == MessageMatchInviteMyState_Invited) {
            cell.joinButton.enabled = YES;
            [cell.joinButton setTitle:LS(@"inivte-join.title") forState:UIControlStateNormal];
        }else {
            cell.joinButton.enabled = NO;
            [cell.joinButton setTitle:LS(@"inivte-joined.title") forState:UIControlStateDisabled];
        }
    }
    
    if (self.isEdit) {
        cell.selectButton.hidden = NO;
        cell.containerView.left = cell.selectButton.right;
        if ([self.willDeleteMessageList containsObject:info]) {
            [cell.selectButton setImage:[UIImage imageNamed:@"invite_checkboxmark"] forState:UIControlStateDisabled];
        }else {
            [cell.selectButton setImage:[UIImage imageNamed:@"invite_checkboxmark_x"] forState:UIControlStateDisabled];
        }
    }else {
        cell.selectButton.hidden = YES;
        cell.containerView.left = 0;
    }
    return cell;
    
}
// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (![self.messagePageRequest isLoadEnd] &&
        self.messageList.count-1 == indexPath.row) {
        [self loadMessageList];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isEdit) {
        MessageMatchInviteInfo *info = [self.messageList objectAtIndex:indexPath.row
                                        ];
        if ([self.willDeleteMessageList containsObject:info]) {
            [self.willDeleteMessageList removeObject:info];
        }else {
            [self.willDeleteMessageList addObject:info];
        }
        [self.recordTable reloadData];
        if (self.deleteMessageBlock) {
            BLOCK_EXEC(self.deleteMessageBlock, [self.willDeleteMessageList copy]);
        }
    }
}



#pragma mark - Action

#pragma mark - Private

- (void)setupUI {
    
    [self.recordTable registerNib:[UINib nibWithNibName:@"GBMessageInvitedCell" bundle:nil] forCellReuseIdentifier:@"GBMessageInvitedCell"];
    self.recordTable.backgroundColor = [UIColor clearColor];
    self.recordTable.separatorColor = [UIColor blackColor];
    self.emptyScrollView = self.recordTable;
    
    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self loadMessageList];
    }];
    mj_header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.recordTable.mj_header = mj_header;
}

- (void)loadMessageList {
    
    @weakify(self)
    [self.messagePageRequest reloadPageWithHandle:^(id result, NSError *error) {
        @strongify(self)
        [self.recordTable.mj_header endRefreshing];
        if (error) {
            [self showToastWithText:error.domain];
            [self.recordTable reloadData];
        }else {
            self.messageList = self.messagePageRequest.responseInfo.items;
            //刷新是否有最新消息的时间
            [RawCacheManager sharedRawCacheManager].lastGetInviteMessageTime = [NSDate date].timeIntervalSince1970;
            BLOCK_EXEC(self.didRefreshMessage);
            self.isShowEmptyView = self.messageList.count==0;
            [self.recordTable reloadData];
        }
    }];
}

- (void)getNextMesssageList {
    
    @weakify(self)
    [self.messagePageRequest loadNextPageWithHandle:^(id result, NSError *error) {
        @strongify(self)
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            self.messageList = self.messagePageRequest.responseInfo.items;
            [self.recordTable reloadData];
        }
    }];
}

#pragma mark - Getters & Setters

- (MessageMatchInvitePageRequest *)messagePageRequest {
    
    if (!_messagePageRequest) {
        _messagePageRequest = [[MessageMatchInvitePageRequest alloc] init];
    }
    
    return _messagePageRequest;
}
@end
