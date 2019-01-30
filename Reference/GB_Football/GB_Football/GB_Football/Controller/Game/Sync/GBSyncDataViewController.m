//
//  GBSyncDataViewController.m
//  GB_Football
//
//  Created by Pizza on 16/8/19.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBSyncDataViewController.h"
#import "GBGameCompeleteViewController.h"
#import "GBMenuViewController.h"
#import "GBGameTimeDivisionRecordViewController.h"
#import "GBGuestGameCompeleteViewController.h"
#import "GBGameTimeDivisionCompleteViewController.h"
#import "GBMultiCoursePageViewController.h"
#import "GBMatchInviteViewController.h"

#import <pop/POP.h>
#import "GBBluetoothManager.h"
#import "GBSyncCircle.h"
#import "GBBoxButton.h"
#import "RTLabel.h"
#import "AGPSManager.h"
#import "GBSportModeCard.h"
#import "NoRemindManager.h"

#import "MatchRequest.h"

@interface GBSyncDataViewController ()
// 比赛名称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
// 创建者
@property (weak, nonatomic) IBOutlet UILabel *createrLabel;
// 创建日期
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
// 球场地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
//加入人数view
@property (weak, nonatomic) IBOutlet UIView *joinCountView;
@property (weak, nonatomic) IBOutlet UILabel *joinCountLabel;
// 同步圈(动画)
@property (weak, nonatomic) IBOutlet GBSyncCircle *syncCicel;
// 赛事简介容器(动画)
@property (weak, nonatomic) IBOutlet UIView *subContainer;
// 底部提示框(动画)
@property (strong, nonatomic) IBOutlet UIView *bottomAlertView;
// 提示条基座
@property (weak, nonatomic) IBOutlet UIView *alertSocket;
// 中间的同步点击按钮
@property (weak, nonatomic) IBOutlet UIButton *centerButton;

// 完成比赛按钮
@property (weak, nonatomic) IBOutlet UIButton *quitButton;
@property (weak, nonatomic) IBOutlet UIButton *inviteFriendButton;

// 静态国家化标签
@property (weak, nonatomic) IBOutlet UILabel *tipMessageStLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchNameStLabel;
@property (weak, nonatomic) IBOutlet UILabel *creatorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateStLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationStLabel;
@property (weak, nonatomic) IBOutlet UILabel *joinedLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeRecordLabel;

@property (weak, nonatomic) IBOutlet GBBoxButton *tipCancelButton;
@property (weak, nonatomic) IBOutlet GBBoxButton *tipYesButton;
@property (weak, nonatomic) IBOutlet UIView *timeDivisionRecordView;

// 显示足球模式弹框
@property (nonatomic, assign) BOOL showSportCard;
@property (nonatomic, assign) NSInteger matchId;
@property (nonatomic, strong) MatchDoingInfo *matchDoingInfo;
@property (nonatomic, assign, getter=isCreateMatch) BOOL createMatch;   //是否是自己创建的比赛
@property (nonatomic, assign, getter=isHasSyncData) BOOL hasSyncData;


@end

@implementation GBSyncDataViewController

#pragma mark -
#pragma mark Memory

- (void)dealloc{
    
    [[GBBluetoothManager sharedGBBluetoothManager] cancelSportModelData];
}

-(void)localizeUI
{
    self.tipMessageStLabel.text = LS(@"sync.actionbox.label.message");
    self.matchNameStLabel.text = LS(@"sync.label.name");
    self.creatorNameLabel.text = LS(@"sync.label.creator");
    self.dateStLabel.text = LS(@"sync.label.date");
    self.locationStLabel.text = LS(@"sync.label.loaction");
    self.joinedLabel.text = LS(@"inivte-joined.title");
    [self.tipCancelButton setTitle:LS(@"common.btn.cancel") forState:UIControlStateNormal];
    [self.tipYesButton setTitle:LS(@"common.btn.yes") forState:UIControlStateNormal];
    self.timeRecordLabel.text = LS(@"sync.time.record");
    [self.quitButton setTitle:LS(@"sync.quit.btn.title") forState:UIControlStateNormal];
    [self.quitButton setTitle:LS(@"sync.quit.btn.title") forState:UIControlStateSelected];
    [self.inviteFriendButton setTitle:LS(@"sync.invite.btn.title") forState:UIControlStateNormal];
    [self.inviteFriendButton setTitle:LS(@"sync.invite.btn.title") forState:UIControlStateSelected];
}

- (instancetype)initWithMatchId:(NSInteger)matchId showSportCard:(BOOL)showSportCard {
    
    if(self=[super init]) {
        _showSportCard = showSportCard;
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
    if ([self.navigationController.topViewController isMemberOfClass:[GBMenuViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

-(void)viewDidLayoutSubviews
{
    self.bottomAlertView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 196);
}

#pragma mark - Analytics

- (NSString *)pageName {
    return Analy_Page_Create_Sync;
}

#pragma mark - Notification

#pragma mark - Delegate

#pragma mark - Action
// 同步数据按钮
- (IBAction)actionSyncData:(id)sender {
    
    [UMShareManager event:Analy_Click_Game_Sync];
    
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        [self showToastWithText:LS(@"network.tip.error")];
        return;
    }
    
    if (![[RawCacheManager sharedRawCacheManager] isBindWristband]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_NeedBindiBeacon object:nil];
        return;
    }
    
    if ([AGPSManager shareInstance].status == iBeaconStatus_Run_Entering ||
        [AGPSManager shareInstance].status == iBeaconStatus_Run) {
        [self showToastWithText:LS(@"run.model.sync.run_tips")];
        return;
    }
    
    if (self.hasSyncData) {
        [self syncCompleteViewControll];
        return;
    }
    
    [self showBottomAlert];
}

// 退出比赛按钮
- (IBAction)actionQuitGame:(id)sender {
    
    [UMShareManager event:Analy_Click_Game_Exit2];
    
    [self.quitButton setSelected:YES];
    NSString *messgae = self.isCreateMatch?LS(@"sync.quit.popbox.label.message.creator"):LS(@"sync.quit.popbox.label.message.jion");
    @weakify(self)
    [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1)
        {
            @strongify(self)
            [self showLoadingToast];
            [MatchRequest deleteMatch:self.matchDoingInfo.match_id isCreator:self.isCreateMatch handler:^(id result, NSError *error)
             {
                 [self dismissToast];
                 if (error) {
                     [self showToastWithText:error.domain];
                 }else {
                     
                     [[NSNotificationCenter defaultCenter] postNotificationName:Notification_DeleteMatchSuccess object:nil];
                 }
                 [self.quitButton setSelected:NO];
             }];
        }else {
            [self.quitButton setSelected:NO];
        }
    } title:LS(@"common.popbox.title.tip") message:messgae cancelButtonName:LS(@"common.btn.cancel") otherButtonTitle:LS(@"common.btn.yes") style:GBALERT_STYLE_NOMAL];
}

// 邀请好友按钮
- (IBAction)actionInviteFriend:(id)sender {
    
    [UMShareManager event:Analy_Click_Game_Invite2];
    
    GBMatchInviteViewController *vc = [[GBMatchInviteViewController alloc] initWithMatchId:self.matchId gameType:self.matchDoingInfo.type];
    @weakify(self)
    vc.joinFriendCountBlock = ^(NSInteger joinCount) {
        
        @strongify(self)
        self.matchDoingInfo.joinedCount = joinCount;
        self.joinCountLabel.text = [NSString stringWithFormat:@"%td%@", self.matchDoingInfo.joinedCount, LS(@"invite-has-jion-unit")];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

// 底部提示框 取消
- (IBAction)actionCancel:(id)sender {
    [self hideBottomAlert];
}
// 底部提示框 确认
- (IBAction)actionOK:(id)sender {
    
    [self beginBottomAlertWithCompletionBlock:^{
        [self.syncCicel syncWithCompletionBlock:^{}];
        //只有普通模式才能读取足球数据
        if ([GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.status != iBeaconStatus_Normal) {
            [[AGPSManager shareInstance] leaveAGPS:^(NSError *error) {
                if (!error) {
                    [self startSyncData];
                }else {
                    [self showToastWithText:error.domain];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)),dispatch_get_main_queue(),^{
                        [self endBottomAlertWithCompletionBlock:^{} analysisOK:NO];
                    });
                }
            }];
        }else {
            [self startSyncData];
        }
    }];
}

- (IBAction)actionTimeDivisionRecord:(id)sender {
    
    [UMShareManager event:Analy_Click_Game_Punch];
    
    [self.navigationController pushViewController:[[GBGameTimeDivisionRecordViewController alloc] initWithMatchInfo:self.matchDoingInfo] animated:YES];
}
#pragma mark - Private

- (void)setupUI {
    
    self.title = LS(@"sync.nav.title");
    [self setupBackButtonWithBlock:nil];
    self.inviteFriendButton.hidden = YES;
}

- (void)refreshUI {
    
    if (!self.matchDoingInfo) {
        return;
    }
    
    self.createMatch = self.matchDoingInfo.creatorId==[RawCacheManager sharedRawCacheManager].userInfo.userId;
    
    self.nameLabel.text = self.matchDoingInfo.match_name;
    self.createrLabel.text = self.matchDoingInfo.nick_name;
    NSDate *matchDate = [NSDate dateWithTimeIntervalSince1970:self.matchDoingInfo.match_date];
    self.dateLabel.text = [NSString stringWithFormat:@"%td - %02td - %02td", matchDate.year, matchDate.month, matchDate.day];
    self.addressLabel.text = self.matchDoingInfo.court_address;
    self.joinCountLabel.text = [NSString stringWithFormat:@"%td%@", self.matchDoingInfo.joinedCount, LS(@"invite-has-jion-unit")];
    [self.alertSocket addSubview:self.bottomAlertView];
    [self setupButtonPressAnimation];
    [self showSportCardBox];
    
    self.quitButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.quitButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.inviteFriendButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.inviteFriendButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    if (self.matchDoingInfo.type == GameType_Standard || self.matchDoingInfo.type == GameType_Team) {
        self.timeDivisionRecordView.hidden = YES;
        self.joinCountView.hidden = NO;
        if (self.createMatch) {
            self.inviteFriendButton.hidden = NO;
            if (self.matchDoingInfo.type == GameType_Team) {
                [self.inviteFriendButton setTitle:LS(@"sync.invite.btn.title.team") forState:UIControlStateNormal];
                [self.inviteFriendButton setTitle:LS(@"sync.invite.btn.title.team") forState:UIControlStateSelected];
            } else {
                [self.inviteFriendButton setTitle:LS(@"sync.invite.btn.title") forState:UIControlStateNormal];
                [self.inviteFriendButton setTitle:LS(@"sync.invite.btn.title") forState:UIControlStateSelected];
            }
            
        }else {
            self.inviteFriendButton.hidden = YES;
        }
    }else {
        self.timeDivisionRecordView.hidden = NO;
        self.inviteFriendButton.hidden = YES;
        self.joinCountView.hidden = YES;
    }
    if (self.hideRecordTimeDivision) {
        self.timeDivisionRecordView.hidden = YES;
    }
}

-(void)showSportCardBox
{
    if (self.showSportCard == NO) {
        [self showTutorial];
        return;
    }
    // 不再提示框未被关闭过
    if ([NoRemindManager sharedInstance].sportModeSwitchSuccess == NO)
    {
        [GBSportModeCard showWithTitle:LS(@"search.success.title")
                               content:LS(@"search.success.content")
                         buttonStrings:@[LS(@"common.btn.yes"),LS(@"sync.popbox.btn.no.remind")] onOk:^{
                             [self showTutorial];
                             
                         } onCancel:^{
                             [NoRemindManager sharedInstance].sportModeSwitchSuccess = YES;
                             [self showTutorial];
                         }];
    }
}

- (void)showTutorial {
    
    if (self.matchDoingInfo.type==GameType_Define && !self.hideRecordTimeDivision && [NoRemindManager sharedInstance].tutorialMultiMode == NO) {
        
        GBMultiCoursePageViewController *vc = [[GBMultiCoursePageViewController alloc] init];
        [self.navigationController pushViewController:vc animated:NO];
    }
}

- (void)loadData {
    
    //加载缓存
    self.matchDoingInfo = [MatchDoingInfo loadCache];
    
    [self showLoadingToast];
    @weakify(self)
    [MatchRequest getMatchDoingInfoWithMatchId:self.matchId handler:^(id result, NSError *error) {
        
        @strongify(self)
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            self.matchDoingInfo = result;
            [self.matchDoingInfo loadDefaultLocalData];
            [self refreshUI];
            //保存缓存
            [self.matchDoingInfo saveCache];
        }
    }];
}

- (void)finishMatch {
    
    if (self.matchDoingInfo.type == GameType_Standard || self.matchDoingInfo.type == GameType_Team) {
        GBGameCompeleteViewController *vc = [[GBGameCompeleteViewController alloc] initWithMatchInfo:self.matchDoingInfo];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        GBGameTimeDivisionCompleteViewController *vc = [[GBGameTimeDivisionCompleteViewController alloc] initWithMatchInfo:self.matchDoingInfo];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)syncCompleteViewControll {
    
    if (self.isCreateMatch) {
        
        [self finishMatch];
    } else {
        GBGuestGameCompeleteViewController *vc = [[GBGuestGameCompeleteViewController alloc] initWithMatchInfo:self.matchDoingInfo];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)startSyncData {
    
    // 只要有数据就读取，所以这里日期用0
    NSInteger month = 0;
    NSInteger day = 0;
    @weakify(self)
    [[GBBluetoothManager sharedGBBluetoothManager] readSportModelData:month day:day serviceBlock:^(id data, id originalData, NSError *error) {
        @strongify(self)
        if (originalData)
        {
            [MatchRequest syncMatchSourceData:self.matchDoingInfo.match_id data:originalData handler:nil];
        }
        if (error)
        {
            [self showToastWithText:error.domain];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)),dispatch_get_main_queue(),^{
                [self endBottomAlertWithCompletionBlock:^{} analysisOK:NO];
            });
        }
        else
        {
            [self.syncCicel setPercent:100];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)),dispatch_get_main_queue(),^{
                [self calculateMatchTime:data];
                [self.syncCicel analysisWithCompletionBlock:^{}];
                NSData *parseData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
                @weakify(self)
                [MatchRequest syncMatchData:self.matchDoingInfo.match_id data:parseData isCreateror:self.isCreateMatch  handler:^(id result, NSError *error) {
                    @strongify(self)
                    [self dismissToast];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)),dispatch_get_main_queue(),^{
                        [self endBottomAlertWithCompletionBlock:^{} analysisOK:YES];
                    });
                    if (error) {
                        [self showToastWithText:error.domain];
                    }else {
                        self.hasSyncData = YES;
                        [self syncCompleteViewControll];
                    }
                }];
            });
        }
    } progressBlock:^(NSProgress *progress) {
        @strongify(self)
        GBLog(@"同步进度:%f", (CGFloat)progress.completedUnitCount/progress.totalUnitCount);
        [self.syncCicel setPercent:(CGFloat)progress.completedUnitCount/progress.totalUnitCount*100];
    }];
}

- (void)calculateMatchTime:(NSDictionary *)dataDict {
    
    NSDateComponents *GMT8DateComponents = [[NSDate date] dateComponentsWithGMT8];
    // 计算开始时间
    NSInteger year = GMT8DateComponents.year;
    NSInteger month = [[dataDict objectForKey:@"month"] integerValue];
    NSInteger day = [[dataDict objectForKey:@"day"] integerValue];
    NSInteger hour = [[dataDict objectForKey:@"hour"] integerValue];
    NSInteger minute = [[dataDict objectForKey:@"minute"] integerValue];
    NSInteger second = [[dataDict objectForKey:@"second"] integerValue];
    //判断比赛记录是否比当前日期大
    if (month>GMT8DateComponents.month) {
        year -= 1;
    }else if (month==GMT8DateComponents.month) {
        if (day>GMT8DateComponents.day) {
            year -= 1;
        }else if (day == GMT8DateComponents.day) {
            if (hour>GMT8DateComponents.hour) {
                year -= 1;
            }else if (hour == GMT8DateComponents.hour) {
                if (minute>GMT8DateComponents.minute) {
                    year -= 1;
                }
            }
        }
    }
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = year;
    dateComponents.month = month;
    dateComponents.day = day;
    dateComponents.hour = hour;
    dateComponents.minute = minute;
    dateComponents.second = second;
    NSDate *localBeginDate = [NSDate dateWithGMT8DateComponents:dateComponents];
    
    self.matchDoingInfo.matchBeginTime = [localBeginDate timeIntervalSince1970];
    //  计算结束时间
    self.matchDoingInfo.matchEndTime = self.matchDoingInfo.matchBeginTime;
    NSArray *dataItemArray = [dataDict objectForKey:@"items"];
    if ([dataItemArray isKindOfClass:[NSArray class]] && dataItemArray.count > 0) {
        NSDictionary *lastItem = dataItemArray[dataItemArray.count - 1];
        NSInteger intervalTime = [[lastItem objectForKey:@"interval_time"] integerValue];
        self.matchDoingInfo.matchEndTime += intervalTime;
    }
}

#pragma mark - Getters & Setters

#pragma mark - Animation

#pragma mark - PopBox

-(void)showBottomAlert
{
    self.centerButton.userInteractionEnabled = NO;
    [self.syncCicel prepareWithCompletionBlock:^{
        [UIView animateWithDuration:0.5f animations:^{
            self.syncCicel.transform = CGAffineTransformMakeTranslation(0, -110*kAppScale);
            self.subContainer.transform = CGAffineTransformMakeTranslation(0, -110*kAppScale);
            self.quitButton.alpha = 0;
            self.inviteFriendButton.alpha = 0;
            self.alertSocket.transform = CGAffineTransformMakeTranslation(0, -196);
            self.timeDivisionRecordView.alpha = 0;
        } completion:nil];
    }];
    
}

-(void)hideBottomAlert
{
    [self.syncCicel cancelWithCompletionBlock:^{
        [UIView animateWithDuration:0.5f animations:^{
            self.syncCicel.transform = CGAffineTransformMakeTranslation(0, 0);
            self.subContainer.transform = CGAffineTransformMakeTranslation(0, 0);
            self.quitButton.alpha = 1;
            self.inviteFriendButton.alpha = 1;
            self.alertSocket.transform = CGAffineTransformMakeTranslation(0, 0);
            self.timeDivisionRecordView.alpha = 1;
        } completion:^(BOOL finished){
            self.centerButton.userInteractionEnabled = YES;
        }];
        
    }];
}

-(void)beginBottomAlertWithCompletionBlock:(void(^)())completionBlock
{
    self.centerButton.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.5f animations:^{
        self.syncCicel.transform = CGAffineTransformMakeTranslation(0, 0);
        self.alertSocket.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished){
        [self.syncCicel showWithCompletionBlock:^{BLOCK_EXEC(completionBlock);}];
    }];
    
}

-(void)endBottomAlertWithCompletionBlock:(void(^)())completionBlock analysisOK:(BOOL)analysisOK
{
    [self.syncCicel idleWithCompletionBlock:^{
        [UIView animateWithDuration:0.5f animations:^{
            self.syncCicel.transform = CGAffineTransformMakeTranslation(0, 0);
            self.subContainer.transform = CGAffineTransformMakeTranslation(0, 0);
            self.quitButton.alpha = 1;
            self.inviteFriendButton.alpha = 1;
            self.alertSocket.transform = CGAffineTransformMakeTranslation(0, 0);
            self.timeDivisionRecordView.alpha = 1;
        } completion:^(BOOL finished){
            self.centerButton.userInteractionEnabled = YES;
        }];
        BLOCK_EXEC(completionBlock);
    } analysisOK:analysisOK];
}


#pragma mark - 按钮动画

-(void)setupButtonPressAnimation
{
    NSArray *tmpArray = @[self.quitButton, self.inviteFriendButton, self.centerButton];
    for (UIButton *button in tmpArray) {
        [button addTarget:self action:@selector(scaleToSmall:)forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
        [button addTarget:self action:@selector(scaleAnimation:)forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(scaleToDefault:)forControlEvents:UIControlEventTouchDragExit];
    }
}

-(void)scaleToSmall:(id)sender
{
    if (sender == self.centerButton) {
        sender = self.syncCicel;
    }
    [self scaleWithView:sender value:[NSValue valueWithCGSize:CGSizeMake(0.95f, 0.95f)]];
}

-(void)scaleToDefault:(id)sender
{
    if (sender == self.centerButton) {
        sender = self.syncCicel;
    }
    [self scaleWithView:sender value:[NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)]];
}

-(void)scaleAnimation:(id)sender
{
    UIView *button = sender;
    if (button == self.centerButton) {
        button = self.syncCicel;
    }
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.springBounciness = 18.0f;
    scaleAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished)
    {
        [button.layer pop_removeAnimationForKey:@"layerScaleSpringAnimation"];
    };
    [button.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
}

- (void)scaleWithView:(UIView *)view value:(NSValue *)value {
    
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = value;
    scaleAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished)
    {
        [view.layer pop_removeAnimationForKey:@"layerScaleDefaultAnimation"];
    };
    [view.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleDefaultAnimation"];
}

@end
