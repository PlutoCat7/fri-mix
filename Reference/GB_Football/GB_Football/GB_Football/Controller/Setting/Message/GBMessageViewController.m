//
//  GBMessageViewController.m
//  GB_Football
//
//  Created by Pizza on 16/9/8.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBMessageViewController.h"
#import "GBMessageCell.h"
#import "MJRefresh.h"
#import "MessagePageRequest.h"
#import "GBWKWebViewController.h"
#import "GBBaseViewController+Empty.h"

#import "APNSManager.h"

@interface GBMessageViewController ()<
UITableViewDelegate,
UITableViewDataSource>
// 表格
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<MessageInfo *> *messageList;
@property (nonatomic, strong) MessagePageRequest *messagePageRequest;

@end

@implementation GBMessageViewController

#pragma mark -
#pragma mark Memory

- (void)dealloc{
    
}

#pragma mark - PageViewController Method

- (void)initPageData {
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - Notification

#pragma mark - Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;;
}

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageList.count;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageInfo *info = self.messageList[indexPath.row];
    GBMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBMessageCell"];
    cell.titleLabel.text = info.title;
    cell.detialLabel.text = info.content;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:info.createTime];
    NSString *dateString = [NSString stringWithFormat:@"%td-%02td-%02td", date.year, date.month, date.day];
    if ([date isToday]) {
        dateString = [NSString stringWithFormat:@"%02td:%02td",date.hour, date.minute];
    }
    cell.dateLabel.text = dateString;
    cell.bgView.backgroundColor = (indexPath.row%2 == 1)?[UIColor colorWithHex:0x2c2f34]:[UIColor colorWithHex:0x41444d];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.messagePageRequest isLoadEnd] &&
        self.messagePageRequest.responseInfo.items.count-1 == indexPath.row) {
        [self getNextMesssageList];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageInfo *info = self.messageList[indexPath.row];
    [[APNSManager shareInstance] pushSystemMessage:info];
}

#pragma mark - Private

- (void)setupUI {
    
    self.title = LS(@"message.nav.title");
    [self setupBackButtonWithBlock:nil];
    [self setupTableView];
}

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GBMessageCell" bundle:nil] forCellReuseIdentifier:@"GBMessageCell"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.emptyScrollView = self.tableView;
    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self loadMessageList];
    }];
    mj_header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.tableView.mj_header = mj_header;
}

- (void)loadMessageList {
    
    @weakify(self)
    [self.messagePageRequest reloadPageWithHandle:^(id result, NSError *error) {
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            self.messageList = self.messagePageRequest.responseInfo.items;
            //刷新是否有最新消息的时间
            [RawCacheManager sharedRawCacheManager].lastGetMessageTime = [NSDate date].timeIntervalSince1970;
            BLOCK_EXEC(self.didRefreshMessage);
        }
        self.isShowEmptyView = self.messageList.count==0;
        [self.tableView reloadData];
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
        }
        [self.tableView reloadData];
    }];
}

- (MessagePageRequest *)messagePageRequest {
    
    if (!_messagePageRequest) {
        _messagePageRequest = [[MessagePageRequest alloc] init];
    }
    return _messagePageRequest;
}

@end
