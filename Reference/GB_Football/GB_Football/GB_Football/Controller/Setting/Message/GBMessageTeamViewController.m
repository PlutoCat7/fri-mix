//
//  GBMessageTeamViewController.m
//  GB_Football
//
//  Created by 王时温 on 2017/8/3.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBMessageTeamViewController.h"
#import "GBBaseViewController+Empty.h"

#import "MJRefresh.h"
#import "GBMessageTeamCell.h"

#import "TeamLogic.h"
#import "MessageTeamPageRequest.h"

@interface GBMessageTeamViewController ()<GBMessageTeamCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *recordTable;

@property (nonatomic, strong) NSArray<MessageTeamInfo *> *messageList;
@property (nonatomic, strong) MessageTeamPageRequest *messagePageRequest;

@property (nonatomic, strong) NSMutableArray<MessageTeamInfo *> *willDeleteMessageList;

@end

@implementation GBMessageTeamViewController

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

#pragma mark GBMessageTeamCellDelegate

- (void)didClickAgreeButton:(GBMessageTeamCell *)cell {
    
    NSIndexPath *indexPath = [self.recordTable indexPathForCell:cell];
    MessageTeamInfo *info = self.messageList[indexPath.row];
    
    
    //判断是加入还是同意
    if (info.messageType == MessageTeamType_Apply) {
        [self showLoadingToast];
        @weakify(self)
        [TeamLogic disposeTeamApplyWithUserId:info.user_id agree:YES handler:^(NSError *error) {
            @strongify(self)
            [self dismissToast];
            if (!error) {
                info.messageStatus = 1;
                [self.recordTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
    }else if (info.messageType == MessageTeamType_Invite) {
        [self showLoadingToast];
        @weakify(self)
        [TeamLogic joinTeamWithTeamId:info.team_id handler:^(NSError *error) {
            @strongify(self)
            [self dismissToast];
            if (error) {
                [self showToastWithText:error.domain];
            }else {
                info.messageStatus = 1;
                [self.recordTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
    }
}

- (void)didClickRefuseButton:(GBMessageTeamCell *)cell {
    
    NSIndexPath *indexPath = [self.recordTable indexPathForCell:cell];
    MessageTeamInfo *info = self.messageList[indexPath.row];
    [self showLoadingToast];
    @weakify(self)
    [TeamLogic disposeTeamApplyWithUserId:info.user_id agree:NO handler:^(NSError *error) {
        @strongify(self)
        [self dismissToast];
        if (!error) {
            info.messageStatus = 2;
            [self.recordTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    GBMessageTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBMessageTeamCell"];
    cell.delegate = self;
    cell.contentView.backgroundColor = (indexPath.row%2 == 0)?[UIColor colorWithHex:0x41444d]:[UIColor colorWithHex:0x2c2f34];
    MessageTeamInfo *info = self.messageList[indexPath.row];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:info.create_time];
    NSString *dateString = [NSString stringWithFormat:@"%td-%02td-%02td", date.year, date.month, date.day];
    if ([date isToday]) {
        dateString = [NSString stringWithFormat:@"%02td:%02td", date.hour, date.minute];
    }
    cell.dateLabel.text = dateString;
    switch (info.messageType) {
        case MessageTeamType_Apply:
        {
            cell.contentLabel.attributedText = [self contentAttributedStringWith:info.nick_name secondName:LS(@"team.message.apply.to.team") thirdName:@""];
            
            cell.agreeButton.hidden = NO;
            cell.agreeButton.enabled = YES;
            if (info.messageStatus == 0) {
                cell.refuseButton.hidden = NO;
                [cell.agreeButton setTitle:LS(@"common.btn.agree") forState:UIControlStateNormal];
            }else if (info.messageStatus == 1) {
                cell.refuseButton.hidden = YES;
                cell.agreeButton.enabled = NO;
                [cell.agreeButton setTitle:LS(@"team.message.approved") forState:UIControlStateDisabled];
            }else if (info.messageStatus == 2) {
                cell.refuseButton.hidden = YES;
                cell.agreeButton.enabled = NO;
                [cell.agreeButton setTitle:LS(@"team.message.rejected") forState:UIControlStateDisabled];
            }
        }
            break;
        case MessageTeamType_Invite:
        {
            cell.contentLabel.attributedText = [self contentAttributedStringWith:info.nick_name secondName:LS(@"team.invite.you") thirdName:info.team_name];
            
            cell.refuseButton.hidden = YES;
            cell.agreeButton.hidden = NO;
            cell.agreeButton.enabled = YES;
            if (info.messageStatus == 0) {
                [cell.agreeButton setTitle:LS(@"nearby.popbox.btn.join") forState:UIControlStateNormal];
            }else if (info.messageStatus == 1) {
                cell.agreeButton.enabled = NO;
                [cell.agreeButton setTitle:LS(@"inivte-joined.title") forState:UIControlStateDisabled];
            }
            
        }
            break;
        case MessageTeamType_Other:
        {
            cell.refuseButton.hidden = YES;
            cell.agreeButton.hidden = YES;
            switch (info.messageStatus) {
                case 1://踢出
                {
                    cell.contentLabel.attributedText = [self contentAttributedStringWith:info.nick_name secondName:LS(@"team.message.tick.out.you") thirdName:info.team_name];
                }
                    break;
                case 2://任命副队长
                {
                    cell.contentLabel.attributedText = [self contentAttributedStringWith:info.nick_name secondName:LS(@"team.message.appoint.you.VCT") thirdName:@""];
                }
                    break;
                case 3://解除副队长
                {
                    NSString *content = [NSString stringWithFormat:@"%@ %@ %@", LS(@"team.message.you.has"), info.nick_name, LS(@"team.message.remove.VCT")];
                    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:content];
                    [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:[content rangeOfString:info.nick_name]];
                    cell.contentLabel.attributedText = [attriString copy];
                }
                    break;
                case 4://移交队长
                {
                    NSString *content = [NSString stringWithFormat:@"%@ %@ %@ %@", info.nick_name, LS(@"team.message.take"), info.team_name, LS(@"team.message.handed.you.CPT")];
                    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:content];
                    [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:[content rangeOfString:info.nick_name]];
                    [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:[content rangeOfString:info.team_name]];
                    cell.contentLabel.attributedText = [attriString copy];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
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
        MessageTeamInfo *info = [self.messageList objectAtIndex:indexPath.row
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
    
    [self.recordTable registerNib:[UINib nibWithNibName:@"GBMessageTeamCell" bundle:nil] forCellReuseIdentifier:@"GBMessageTeamCell"];
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
            [RawCacheManager sharedRawCacheManager].lastGetTeamMessageTime = [NSDate date].timeIntervalSince1970;
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

- (NSAttributedString *)contentAttributedStringWith:(NSString *)firstName secondName:(NSString *)secondName thirdName:(NSString *)thirdName{
    
    NSString *content = [NSString stringWithFormat:@"%@ %@ %@", firstName, secondName, thirdName];
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:content];
    [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:[content rangeOfString:firstName]];
    [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:[content rangeOfString:thirdName]];
    
    return [attriString copy];
}

#pragma mark - Getters & Setters

- (MessageTeamPageRequest *)messagePageRequest {
    
    if (!_messagePageRequest) {
        _messagePageRequest = [[MessageTeamPageRequest alloc] init];
    }
    
    return _messagePageRequest;
}

@end
