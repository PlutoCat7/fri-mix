//
//  GBSyncDataViewController.m
//  GB_Team
//
//  Created by Pizza on 16/9/23.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBSyncDataViewController.h"
#import "GBHomePageViewController.h"
#import "GBGameCompleteViewController.h"

#import "GBSyncCell.h"
#import "GBAlertView.h"

#import "MatchRequest.h"

@interface SyncObject : NSObject

@property (nonatomic, copy) NSString *mac;
@property (nonatomic, copy) NSString *wristName;
@property (nonatomic, assign) NSInteger playerId;
@property (nonatomic, copy) NSString *playerName;
@property (nonatomic, assign) float progress;
@property (nonatomic, assign) Sync_STATE updateState;

@end

@implementation SyncObject
@end

@interface GBSyncDataViewController () <
GBSyncCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIView *syncContainer;
@property (weak, nonatomic) IBOutlet UIView *completeContainer;
@property (weak, nonatomic) IBOutlet UIView *quitContainer;
@property (weak, nonatomic) IBOutlet UIImageView *syncImageView;
@property (weak, nonatomic) IBOutlet UIImageView *completeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *quitImageView;
@property (weak, nonatomic) IBOutlet UIButton *syncButton;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet UIButton *quitButton;

@property (nonatomic, assign) NSInteger matchId;
@property (nonatomic, strong) PendingMatchInfo *pendingMatchInfo;
@property (nonatomic, strong) NSArray<SyncObject *> *syncList;

@end

@implementation GBSyncDataViewController

- (void)dealloc{
    
    [[GBMultiBleManager sharedMultiBleManager] resetMultiBleManager];
}

- (instancetype)initWithMatcId:(NSInteger)matchId {
    
    if(self=[super init]){
        _matchId = matchId;
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
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
#pragma mark - Delegate

- (void)didPressRetryUpdateButtonWithGBSyncCell:(GBSyncCell *)cell {
    
    SyncObject *object = self.syncList[[self.tableView indexPathForCell:cell].row];
    [self syncSportData:object];
    [self.tableView reloadData];
}

#pragma mark - Action

- (IBAction)actionSyncData:(id)sender {
    
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        [self showToastWithText:LS(@"请连接网络")];
        return;
    }
    
    BOOL isNeedSync = NO;
    for (SyncObject *object in self.syncList) {
        if (object.updateState != STATE_FINISHED) {
            isNeedSync = YES;
            break;
        }
    }
    if (!isNeedSync) {
        return;
    }
    
    for (SyncObject *object in self.syncList) {
        [self syncSportData:object];
    }
    [self.tableView reloadData];
}

- (IBAction)actionCompleteGame:(id)sender {
    
    BOOL isNeedSync = NO;
    for (SyncObject *object in self.syncList) {
        if (object.updateState == STATE_UPDATING) {
            [self showToastWithText:LS(@"数据同步中请稍候")];
            return;
        }
        if (object.updateState != STATE_FINISHED) {
            isNeedSync = YES;
            break;
        }
    }
    [self.completeImageView setHighlighted:YES];
    if (isNeedSync) {
        NSString *messgae = LS(@"您还没有同步数据，确定要完成比赛设置比赛数据吗？");
        @weakify(self)
        [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                @strongify(self)
                [self finishMatch];
                [self.completeImageView setHighlighted:NO];
            }else {
                [self.completeImageView setHighlighted:NO];
            }
        } title:LS(@"温馨提示") message:messgae cancelButtonName:LS(@"取消") otherButtonTitle:LS(@"确定")];
    }else{
        [self finishMatch];
        [self.completeImageView setHighlighted:NO];
    }
}

- (IBAction)actionQuitGame:(id)sender {
    
    [self.quitImageView setHighlighted:YES];
    NSString *messgae = LS(@"退出后所有参与者的数据将丢失,确定退出吗？");
    @weakify(self)
    [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        @strongify(self)
        if (buttonIndex == 1) {
            [self showLoadingToast];
            [MatchRequest delMatchBindInfo:self.matchId handler:^(id result, NSError *error) {
                
                [self dismissToast];
                if (error) {
                    [self showToastWithText:error.domain];
                    [self.quitImageView setHighlighted:NO];
                    
                } else {
                    [[RawCacheManager sharedRawCacheManager] setDoingMatchId:0];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_DeleteMatchSuccess object:nil];
                    [self.quitImageView setHighlighted:NO];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        } else {
            [self.quitImageView setHighlighted:NO];
        }
    } title:LS(@"温馨提示") message:messgae cancelButtonName:LS(@"取消") otherButtonTitle:LS(@"确定")];
}

#pragma mark - Private

- (void)setupUI {
    
    self.title = LS(@"同步数据");
    [self setupBackButtonWithBlock:nil];
    [self setupTableView];
    
    
    [self loadMatchBindInfo];
}

- (void)setupTableView {
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"GBSyncCell" bundle:nil] forCellReuseIdentifier:@"GBSyncCell"];
}

- (void)loadMatchBindInfo {
    
    @weakify(self)
    [self showLoadingToast];
    [MatchRequest getMatchBindInfo:self.matchId handler:^(id result, NSError *error) {
        @strongify(self)
        [self dismissToast];
        if (error) {
            [[UIApplication sharedApplication].keyWindow showToastWithText:error.domain];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            self.pendingMatchInfo = result;
            [self updateMatchInfo];
        }
    }];
}

- (void)updateMatchInfo {
    
    self.nameLabel.text = self.pendingMatchInfo.matchHeadInfo.matchName;
    NSDate *matchDate = [NSDate dateWithTimeIntervalSince1970:self.pendingMatchInfo.matchHeadInfo.createTime];
    self.dateLabel.text = [NSString stringWithFormat:@"%td - %02td - %02td", matchDate.year, matchDate.month, matchDate.day];
    self.addressLabel.text = self.pendingMatchInfo.matchHeadInfo.courtName;
    
    [self.tableView reloadData];
}

- (void)finishMatch {
    
//默认今天
    NSDate *createDate = [NSDate date];
    GBGameCompleteViewController *vc = [[GBGameCompleteViewController alloc] initWithMatchId:self.pendingMatchInfo.matchHeadInfo.matchId matchTime:[createDate timeIntervalSince1970]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)syncSportData:(SyncObject *)object {
    
    if (object.updateState == STATE_FINISHED || object.updateState == STATE_UPDATING) {
        return;
    }
    [self.syncImageView setHighlighted:YES];
    object.progress = 0;
    object.updateState = STATE_UPDATING;
    
    @weakify(self)
    [[GBMultiBleManager sharedMultiBleManager] readSportModelData:object.mac handler:^(id data, id originalData, NSError *error) {

        @strongify(self)
        if (error) {
            object.updateState = STATE_FAIL;
            [self.tableView reloadData];
        }else {
            object.progress = 1.0f;
            [self.tableView reloadData];
            
            NSData *parseData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
            //上传运动数据
            [MatchRequest syncMatchDataWithMatchId:self.matchId palyerId:object.playerId originData:originalData handleData:parseData handler:^(id result, NSError *error) {
                
                if (error) {
                    object.updateState = STATE_FAIL;
                }else {
                    object.updateState = STATE_FINISHED;
                }
                [self.tableView reloadData];
            }];
        }
        
        BOOL isSync = NO;
        for (SyncObject *object in self.syncList) {  //是否还有在同步数据
            if (object.updateState == STATE_UPDATING) {
                isSync = YES;
            }
        }
        [self.syncImageView setHighlighted:isSync];
    } progressBlock:^(CGFloat progress) {
        
        @strongify(self)
        object.progress = progress;
        GBSyncCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.syncList indexOfObject:object] inSection:0]];
        [cell.slider setValue:object.progress animated:NO];
        cell.state = object.updateState;
    }];
}

#pragma mark - Delegate

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.syncList.count;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GBSyncCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBSyncCell"];
    cell.delegate = self;
    
    SyncObject *object = self.syncList[indexPath.row];
    cell.ringNameLabel.text = object.wristName;
    cell.playerNameLabel.text = object.playerName;
    cell.slider.value = object.progress;
    cell.state = object.updateState;
    
    return cell;
}

- (void)setPendingMatchInfo:(PendingMatchInfo *)pendingMatchInfo {
    
    _pendingMatchInfo = pendingMatchInfo;
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:pendingMatchInfo.matchPlayerList.count];
    for (PendingMatchPlayerListInfo *info in pendingMatchInfo.matchPlayerList) {
        SyncObject *object = [[SyncObject alloc] init];
        object.mac = info.mac;
        object.wristName = info.orderName;
        object.playerName = info.playerName;
        object.playerId = info.playerId;
        object.updateState = STATE_INIT;
        [list addObject:object];
    }
    self.syncList = [list copy];
}

@end
