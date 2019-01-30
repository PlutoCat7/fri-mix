//
//  GBBindPlayerViewController.m
//  GB_Team
//
//  Created by weilai on 16/9/26.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBBindPlayerViewController.h"
#import "GBHomePageViewController.h"
#import "GBPositionLabel.h"
#import "GBBindPlayerCell.h"
#import "UIImageView+WebCache.h"
#import "GBAlertView.h"
#import "GBSyncDataViewController.h"

#import "SystemRequest.h"
#import "TeamRequest.h"
#import "MatchRequest.h"
#import "AGPSManager.h"

#define kRepeatTimes 5
#define kSearchStarSuccessLimitTime  (3*60)     //搜星超时时间

@interface GBBindPlayerViewController () <
UIComboBoxDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *numberLbl;
@property (weak, nonatomic) IBOutlet GBPositionLabel *positionLabel1;
@property (weak, nonatomic) IBOutlet GBPositionLabel *positionLabel2;
@property (weak, nonatomic) IBOutlet UIComboBox *wristComboBox;
@property (weak, nonatomic) IBOutlet GBHightLightButton *bindPlayerBtn;
// 一键加速按钮
@property (weak, nonatomic) IBOutlet UIButton *oneKeyButton;
// 编辑按钮
@property (nonatomic, strong) UIButton *sureButton;
// 选中的当前项
@property (nonatomic, assign) NSInteger selectedIndex;
// 选中手环当前项
@property (nonatomic, assign) NSInteger selectWristIndex;
// 手环列表
@property (nonatomic, strong) NSMutableArray <WristbandInfo*> *wristArray;

@property (nonatomic, strong) MatchBindInfo *matchBindInfo;
@property (nonatomic, strong) PlayerBindInfo *searchingBindInfo;  //正在巡检手环

@property (nonatomic, strong) NSTimer *repeatTimer;    //定时刷新手环是否搜星成功定时器

@end

@implementation GBBindPlayerViewController

- (instancetype)initWithMatchBindInfo:(MatchBindInfo *)matchBindInfo {
    
    if (self = [super init]) {
        _matchBindInfo = matchBindInfo;
        _selectedIndex = -1;
        _selectWristIndex = -1;
    }
    
    return self;
}

- (void)dealloc{
    
    [[AGPSManager shareInstance] cleanAGPSFile];
    [[GBMultiBleManager sharedMultiBleManager] resetMultiBleManager];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[AGPSManager shareInstance] cleanAGPSFile];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.headImageView.layer.cornerRadius = self.headImageView.width/2;
    });
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.repeatTimer invalidate];
    @weakify(self);
    self.repeatTimer = [NSTimer scheduledTimerWithTimeInterval:kRepeatTimes block:^(NSTimer *timer) {
        
        @strongify(self)
        [self turnsWristbandState];
    } repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.repeatTimer invalidate];
}

//轮询手环搜星状态
- (void)turnsWristbandState {
    
    GBLog(@"巡检手环状态");
    for (PlayerBindInfo *info in self.matchBindInfo.playerBindArray) {
        if (info.wristbandInfo && info.wristbandInfo.searchStartState != STAR_SEARCH_STATE_COMPLETE) {
            @weakify(self)
            [[AGPSManager shareInstance] checkAGPSStateWithMac:info.wristbandInfo.mac complete:^(NSString *mac, BleGpsState state) {
                
                @strongify(self)
                if (state == BleGpsState_Success) { //搜星成功
                    info.wristbandInfo.searchStartState = STAR_SEARCH_STATE_COMPLETE;
                    [self.tableView reloadData];
                }
            }];
        }
    }
}

#pragma mark - Action
// 点击了确认按钮
- (void)actionSurePress {

    self.sureButton.enabled = NO;
    @weakify(self)
    [self showLoadingToast];
    [MatchRequest uploadMatchBindInfo:self.matchBindInfo handler:^(id result, NSError *error) {
        @strongify(self)
        [self dismissToast];
        self.sureButton.enabled = YES;
        if (error) {
            [self showToastWithText:error.domain];
        } else {
            // 保存待完成比赛id
            [[RawCacheManager sharedRawCacheManager] setDoingMatchId:[result integerValue]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_CreateMatchSuccess object:nil];
            
            GBSyncDataViewController *vc = [[GBSyncDataViewController alloc] initWithMatcId:[result integerValue]];
            NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            [viewControllers removeLastObject];
            [viewControllers removeLastObject];
            [viewControllers removeLastObject];
            [viewControllers addObject:vc];
            
            [self.navigationController setViewControllers:[viewControllers copy] animated:YES];
        }
    }];
}

- (IBAction)actionBindPlayer:(id)sender {
    
    PlayerBindInfo *playerBindInfo = self.matchBindInfo.playerBindArray[self.selectedIndex];
    WristbandInfo *wristbandInfo = self.wristArray[self.selectWristIndex];
    
    // 给选中的赋值
    playerBindInfo.wristbandInfo = wristbandInfo;
    self.selectedIndex = -1;
    
    // 删除手环列表的数据
    [self.wristArray removeObject:wristbandInfo];
    self.selectWristIndex = -1;
    WristbandInfo *needWristbindInfo = nil;
    // 自动指向下一个未绑定的手环
    if (self.wristArray.count >0) {
        self.selectWristIndex = 0;
        needWristbindInfo = self.wristArray[0];
    }
    [self updateComboData:needWristbindInfo];
    
    // 自动选择下一个未绑定的球员
    for (int index = 0; index < [self.matchBindInfo.playerBindArray count]; index++) {
        PlayerBindInfo *tempInfo = self.matchBindInfo.playerBindArray[index];
        if (tempInfo.wristbandInfo == nil) {
            self.selectedIndex = index;
            break;
        }
    }
    [self.tableView reloadData];
    [self updateSelectPlayerUI];
    
    [self checkInputValid];
    [self checkSureValid];
    [self checkOneKeyValid];
}

- (void)unbindWristband:(PlayerBindInfo *)playerBindInfo {
    
    @weakify(self)
    [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        @strongify(self)
        if (buttonIndex == 1) {
            
            if (self.searchingBindInfo == playerBindInfo) {
                self.searchingBindInfo = nil;
            }
            
            WristbandInfo *wristbandInfo = playerBindInfo.wristbandInfo;
            playerBindInfo.wristbandInfo = nil;
            if (wristbandInfo.searchStartState == STAR_SEARCH_STATE_ING) { //正在搜星中，  取消搜星
                [[AGPSManager shareInstance] cancelAGPSWithMac:wristbandInfo.mac];
            }
            //解绑是选择该球员
            self.selectedIndex = [self.matchBindInfo.playerBindArray indexOfObject:playerBindInfo];
            [self updateSelectPlayerUI];
            
            NSInteger selectItem = self.wristComboBox.selectedItem;
            WristbandInfo *curWristband = nil;
            if (selectItem > -1 && selectItem < [self.wristArray count]) {
                curWristband = self.wristArray[selectItem];
            }
            
            [self.wristArray addObject:wristbandInfo];
            
            [self comparatorWristband];
            [self updateComboData:curWristband];
            [self.tableView reloadData];
            [self checkOneKeyValid];
        }
    } title:LS(@"温馨提示") message:LS(@"您确定要解绑该球员的手环吗？") cancelButtonName:LS(@"取消") otherButtonTitle:LS(@"确定")];
}

- (void)checkWristband:(PlayerBindInfo *)playerBindInfo cell:(GBBindPlayerCell *)cell {
    
    if (self.searchingBindInfo) {//等待上个手环巡检完毕
        [self showToastWithText:LS(@"正在寻找手环，请稍候")];
        return;
    }
    
    if (!playerBindInfo.wristbandInfo) {
        return;
    }
    
    self.searchingBindInfo = playerBindInfo;
    [cell startSearchWrist];
    @weakify(cell)
    @weakify(self)
    [[GBMultiBleManager sharedMultiBleManager] findDevice:playerBindInfo.wristbandInfo.mac  findState:BleFindState_Find handler:^(NSError *error) {
        
        @strongify(cell)
        @strongify(self)
        self.searchingBindInfo = nil;
        [cell stopSearchWrist];
        if (error) {
            [self showToastWithText:error.domain];
        }
    }];
}

// 一键加速按钮
- (IBAction)actionOneKeyPressed:(id)sender {
    
    for (PlayerBindInfo *info in self.matchBindInfo.playerBindArray) {
        if (info.wristbandInfo) {
            if (info.wristbandInfo.searchStartState == STAR_SEARCH_STATE_IDLE ||
                info.wristbandInfo.searchStartState == STAR_SEARCH_STATE_FAILED) {
                [self searchStartWithWristbandInfo:info.wristbandInfo];
            }
        }
    }
}

#pragma mark - Private

-(void)setupUI {
    
    self.title = LS(@"配对列表");
    [self setupBackButtonWithBlock:nil];
    [self setupTableView];
    [self setupRightButton];
    [self checkSureValid];
    
    self.headImageView.clipsToBounds = YES;
    
    self.positionLabel1.hidden = YES;
    self.positionLabel2.hidden = YES;
    
    self.wristComboBox.delegate = self;
    self.wristComboBox.topShow = YES;
    [self.wristComboBox setComboBoxPlaceholder:@"选择手环" color:[UIColor colorWithHex:0x01FF00]];
    
    [self checkOneKeyValid];
}

-(void)loadData {
    
    [self showLoadingToast];
    @weakify(self)
    [TeamRequest getTeamMemberWithTeamId:self.matchBindInfo.homeTeamId handler:^(id result, NSError *error) {
        
        @strongify(self)
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            [self updateResultPlayerData:result];
            if ([self.matchBindInfo.playerBindArray count] > 0) {
                self.selectedIndex = 0;   //默认选择第一个球员
                [self updateSelectPlayerUI];
            }
            self.isShowEmptyView = self.matchBindInfo.playerBindArray.count == 0;
            [self.tableView reloadData];
        }
    }];
    
    [SystemRequest getBindWristbandListWithHandler:^(id result, NSError *error) {
        @strongify(self)
        [self dismissToast];
        if (!error) {
            self.wristArray = result;
            [self updateComboData:nil];
        }
    }];
}

- (void)setupTableView {
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"GBBindPlayerCell" bundle:nil] forCellReuseIdentifier:@"GBBindPlayerCell"];
    
    self.emptyScrollView = self.tableView;
}

- (void)setupRightButton {
    
    self.sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sureButton setSize:CGSizeMake(48,44)];
    [self.sureButton.titleLabel setFont:[UIFont systemFontOfSize:20.f]];
    [self.sureButton setTitle:LS(@"确定") forState:UIControlStateNormal];
    [self.sureButton setTitle:LS(@"确定") forState:UIControlStateHighlighted];
    [self.sureButton setTitleColor:[ColorManager styleColor] forState:UIControlStateNormal];
    [self.sureButton setTitleColor:[UIColor colorWithHex:0x909090] forState:UIControlStateDisabled];
    self.sureButton.backgroundColor = [UIColor clearColor];
    [self.sureButton addTarget:self action:@selector(actionSurePress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:self.sureButton];
    [self.navigationItem setRightBarButtonItem:rightButton];
}

- (void)updateResultPlayerData:(NSArray *)playerArray {
    
    NSMutableArray *playerBindArray = [NSMutableArray array];
    for (int i = 0; i < playerArray.count; i++) {
        PlayerBindInfo *playerBindInfo = [[PlayerBindInfo alloc] init];
        playerBindInfo.playerInfo = playerArray[i];
        
        [playerBindArray addObject:playerBindInfo];
    }
    self.matchBindInfo.playerBindArray = [playerBindArray copy];
}

- (void)updateComboData:(WristbandInfo *)curWristband {
    
    NSInteger newIndex = -1;
    NSMutableArray *wristNameArray = [NSMutableArray array];
    for (int i = 0; i < [self.wristArray count]; i++) {
        [wristNameArray addObject:((WristbandInfo *) self.wristArray[i]).name];
        if (curWristband && self.wristArray[i].wristId == curWristband.wristId) {
            newIndex = i;
        }
    }
    self.wristComboBox.entries = [wristNameArray copy];
    if (newIndex != -1) {
        self.wristComboBox.selectedItem = newIndex;
        [self comboBox:self.wristComboBox selected:(int)newIndex];
    } else {
        [self.wristComboBox resetComboBoxSelect];
        [self comboBox:self.wristComboBox selected:(int)newIndex];
    }
}

- (void)updateSelectPlayerUI {
    
    if (self.selectedIndex < 0 || self.selectedIndex >= [self.matchBindInfo.playerBindArray count]) {
        self.headImageView.image = [UIImage imageNamed:@"portrait_placeholder"];
        self.nameLbl.text = @"";
        self.numberLbl.text = @"";
        self.positionLabel1.hidden = YES;
        self.positionLabel2.hidden = YES;
    }else {
        PlayerBindInfo *playerBindInfo = self.matchBindInfo.playerBindArray[self.selectedIndex];
        
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:playerBindInfo.playerInfo.imageUrl] placeholderImage:[UIImage imageNamed:@"portrait_placeholder"]];
        self.nameLbl.text = playerBindInfo.playerInfo.playerName;
        self.numberLbl.text = [NSString stringWithFormat:@"%td号", playerBindInfo.playerInfo.playerNum];
        
        NSArray<NSString*> *selectList = @[];
        if (![NSString stringIsNullOrEmpty:playerBindInfo.playerInfo.position]) {
            selectList = [playerBindInfo.playerInfo.position componentsSeparatedByString:@","];
        }
        if (selectList.count > 0) {
            self.positionLabel1.hidden = NO;
            self.positionLabel1.index = selectList.firstObject.integerValue;
        } else {
            self.positionLabel1.hidden = YES;
        }
        if (selectList.count > 1) {
            self.positionLabel2.hidden = NO;
            self.positionLabel2.index = selectList.lastObject.integerValue;
        } else {
            self.positionLabel2.hidden = YES;
        }
    }
    
    
    [self checkInputValid];
}

- (void)checkInputValid {
    
    BOOL isSelectValid = !(self.selectWristIndex == -1) && !(self.selectedIndex == -1);
    self.bindPlayerBtn.enabled = isSelectValid;
}

- (void)checkSureValid {
    
    BOOL isValid = NO;
    for (int index = 0; index < [self.matchBindInfo.playerBindArray count]; index++) {
        PlayerBindInfo *tempInfo = self.matchBindInfo.playerBindArray[index];
        if (tempInfo.wristbandInfo) {
            isValid = YES;
            break;
        }
    }
    self.sureButton.enabled = isValid;
}

- (void)comparatorWristband {
    
    NSArray *sortedArray = [self.wristArray sortedArrayUsingComparator:^NSComparisonResult(WristbandInfo * obj1, WristbandInfo * obj2) {
        return [obj1.name compare:obj2.name];
    }];
    
    [self.wristArray removeAllObjects];
    [self.wristArray addObjectsFromArray:sortedArray];
}

// 一键按钮是否需要现实
- (void)checkOneKeyValid {
    
    BOOL isValid = NO;
    for (PlayerBindInfo *info in self.matchBindInfo.playerBindArray) {
        if (info.wristbandInfo) {
            if (info.wristbandInfo.searchStartState == STAR_SEARCH_STATE_IDLE ||
                info.wristbandInfo.searchStartState == STAR_SEARCH_STATE_FAILED) {
                isValid = YES;
                break;
            }
        }
    }
    
    self.oneKeyButton.enabled = isValid;
}

- (void)searchStartWithWristbandInfo:(WristbandInfo *)wristbandInfo {
    
    wristbandInfo.searchStartState = STAR_SEARCH_STATE_ING;
    @weakify(self)
    [[AGPSManager shareInstance] startAGPSWithMac:wristbandInfo.mac complete:^(NSString *mac, NSError *error) {
        
        @strongify(self)
        if (error) {
            NSLog(@"");
        }
        if ([mac isEqualToString:wristbandInfo.mac]) {
            wristbandInfo.searchStartState = error?STAR_SEARCH_STATE_FAILED:STAR_SEARCH_STATE_FINISH;
        }
        [self checkOneKeyValid];
        [self.tableView reloadData];
    }];
    [self checkOneKeyValid];
    [self.tableView reloadData];
    
    wristbandInfo.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:kSearchStarSuccessLimitTime block:^(NSTimer *timer) {
        
        [timer invalidate];
        @strongify(self)
        if (wristbandInfo.searchStartState == STAR_SEARCH_STATE_ING ||
            wristbandInfo.searchStartState == STAR_SEARCH_STATE_FINISH) {
            
            GBLog(@"搜星超时！");
            wristbandInfo.searchStartState = STAR_SEARCH_STATE_FAILED;
            [self checkOneKeyValid];
            [self.tableView reloadData];
        }
    } repeats:NO];
}

#pragma mark - Delegate

#pragma mark  UIComboBoxDelegate
-(void)comboBox:(UIComboBox *)comboBox selected:(int)selected {
    
    self.selectWristIndex = selected;
    [self checkInputValid];
}

#pragma mark  UITableViewDelegate
// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.matchBindInfo.playerBindArray == nil ? 0 : [self.matchBindInfo.playerBindArray count];
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GBBindPlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBBindPlayerCell"];
    
    PlayerBindInfo *playerInfo = self.matchBindInfo.playerBindArray[indexPath.row];
    [cell refreshWithPlayerBindInfo:playerInfo selected:indexPath.row == (self.selectedIndex)];
    if (self.searchingBindInfo && playerInfo == self.searchingBindInfo) {
        [cell startSearchWrist];
    }
    cell.searchState = playerInfo.wristbandInfo?playerInfo.wristbandInfo.searchStartState:STAR_SEARCH_STATE_HIDDEN;
    
    @weakify(self)
    cell.unbindHandler = ^(PlayerBindInfo *playerBindInfo) {
        @strongify(self)
        [self unbindWristband:playerBindInfo];
    };

    @weakify(cell)
    cell.checkWristbandHandler = ^(PlayerBindInfo *playerBindInfo) {
        @strongify(self)
        @strongify(cell)
        [self checkWristband:playerBindInfo cell:cell];
    };
    
    cell.starSearchHandler = ^(BOOL isReset) {
        
        @strongify(self)
        [self searchStartWithWristbandInfo:playerInfo.wristbandInfo];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PlayerBindInfo *playerBindInfo = self.matchBindInfo.playerBindArray[indexPath.row];
    if (playerBindInfo.wristbandInfo) {
        return;
    }
    self.selectedIndex = indexPath.row;
    [self updateSelectPlayerUI];
    [self.tableView reloadData];
}

@end
