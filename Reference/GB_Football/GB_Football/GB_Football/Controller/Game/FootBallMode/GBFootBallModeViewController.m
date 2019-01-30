//
//  GBFootBallModeViewController.m
//  足球模式
//
//  Created by Pizza on 2017/3/7.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBFootBallModeViewController.h"
#import "GBHightLightButton.h"
#import "GBTowerView.h"
#import "SystemRequest.h"
#import "GBProgressLabelView.h"
#import "AGPSManager.h"
#import "GBBorderButton.h"
#import "GBPopAnimateTool.h"
#import "GBSyncDataViewController.h"
#import "MatchInfo.h"
#import "GBMenuViewController.h"
#import "NoRemindManager.h"
#import "GBCourseMask.h"
#import "MatchRequest.h"
#import "GBBluetoothManager.h"

@interface GBFootBallModeViewController()
// 卫星塔视图
@property (weak, nonatomic) IBOutlet GBTowerView *towerView;
// 状态标志视图
@property (weak, nonatomic) IBOutlet GBProgressLabelView *progressLabelView;
// 取消搜星按钮
@property (weak, nonatomic) IBOutlet GBBorderButton *cancelButton;
// 进入足球模式
@property (weak, nonatomic) IBOutlet GBHightLightButton *footBallButton;
// 同步数据按钮
@property (weak, nonatomic) IBOutlet GBBorderButton *syncDataButton;
// 提示标签
@property (nonatomic, strong) IBOutlet UILabel *noteLabel;
// 教程覆盖页
@property (weak, nonatomic) IBOutlet GBCourseMask *courseMask;
// 青色的中文字符
@property (weak, nonatomic) IBOutlet UILabel *noteOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteTwoLabel;
// 取消收星提示弹框
@property (weak, nonatomic)  GBAlertView *cancelAGPSAlertView;
// 收星提醒提示弹框
@property (weak, nonatomic)  GBAlertView *hintAGPSAlertView;
// 右上角按钮
@property (weak, nonatomic) IBOutlet UIButton *quitGameButton;

@end
@implementation GBFootBallModeViewController

#pragma mark - Life Cycle

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

#pragma mark - Analytics

- (NSString *)pageName {
    return Analy_Page_Create_ScanGPS;
}

- (void)setupUI {
    
    self.title = LS(@"football.nav.title");
    [self setupBackButtonWithBlock:nil];
    [self setupButtonStyle];
    
    [self observeProgressStatus];
    self.quitGameButton = [self menuButton];
    // 搜星中, 再次进入该页面重新写入星历
    if ([AGPSManager shareInstance].progressStatus == AGPSProgressStatus_Searching &&
        ([AGPSManager shareInstance].status == iBeaconStatus_Searching)) {
        [self startAPGSWithAnimate:NO];
    }
}

-(void)localizeUI{
    self.noteLabel.text = LS(@"football.label.tip");
    self.noteOneLabel.text = LS(@"footballmode.button.enter.note");
    self.noteTwoLabel.text = LS(@"footballmode.button.loaddata.note");
    [self.footBallButton setTitle:LS(@"footballmode.button.enter")      forState:UIControlStateNormal];
    [self.syncDataButton setTitle:LS(@"footballmode.button.loaddata")   forState:UIControlStateNormal];
    [self.cancelButton   setTitle:LS(@"footballmode.button.quit")       forState:UIControlStateNormal];
}

- (void)dealloc{
    [self.towerView animationStop];
}

#pragma mark - Action

// 点击了上场比赛按钮
- (IBAction)actionEnterFootBallMode:(id)sender {
    
    [UMShareManager event:Analy_Click_Game_FBMode];
    
    // 手环未绑定
    if (![[RawCacheManager sharedRawCacheManager] isBindWristband]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_NeedBindiBeacon object:nil];
        return;
    }
    // 手环可用,走正常搜星流程
    @weakify(self);
    self.hintAGPSAlertView = [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        @strongify(self)
        // 确定按钮
        if (buttonIndex == 1)
        {
            if ([NoRemindManager sharedInstance].tutorialMaskFootBall == NO)
            {
                [self.courseMask showWithType:COURSE_MASK_FOOTBALL];
                @weakify(self);
                self.courseMask.action = ^{
                    @strongify(self)
                    [self startAPGSWithAnimate:YES];
                };
            }
            else
            {
                [self startAPGSWithAnimate:YES];
            }
            return;
        }
        // 取消
        else
        {
            return;
        }
    }
                                  title:LS(@"common.popbox.title.tip")
                                message:LS(@"football.pop.text.clear")
                       cancelButtonName:LS(@"common.btn.cancel")
                       otherButtonTitle:LS(@"common.btn.yes")
                                  style:GBALERT_STYLE_CANCEL_GREEN];
}

// 点击了导出数据（仅同步数据不搜星）
- (IBAction)actionSyncData:(id)sender {
    
    [UMShareManager event:Analy_Click_Game_Export];
    
    GBSyncDataViewController *vc = [[GBSyncDataViewController alloc]
                                    initWithMatchId:[RawCacheManager sharedRawCacheManager].userInfo.matchInfo.match_id showSportCard:NO];
    vc.hideRecordTimeDivision = YES;
    [self.navigationController yh_pushViewController:vc animated:YES];
}

// 点击了取消搜星按钮
- (IBAction)actionCancel:(id)sender {
    
    [UMShareManager event:Analy_Click_Game_ExitFB];
    
    @weakify(self)
    self.cancelAGPSAlertView = [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        @strongify(self)
        if (buttonIndex == 1) {
            [self cancelAGPS];
        }
    } title:LS(@"football.cancel.pop.title") message:LS(@"football.cancel.pop.text") cancelButtonName:LS(@"football.cancel.pop.cancel" )otherButtonTitle:LS(@"football.cancel.pop.ok") style:GBALERT_STYLE_CANCEL_GREEN];
}

#pragma mark - 搜星进度通知

- (void)doAGPSSuccess {
    [self.towerView animationStop];
    [self.progressLabelView setState:PROGRESS_STATE_ING3];
    [self.cancelAGPSAlertView dismiss];
    [self.hintAGPSAlertView dismiss];
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [viewControllers removeLastObject];
    [viewControllers addObject:[[GBSyncDataViewController alloc] initWithMatchId:[RawCacheManager sharedRawCacheManager].userInfo.matchInfo.match_id showSportCard:YES]];
    [self.navigationController setViewControllers:viewControllers animated:YES];
}

- (void)doAGPSFail {
    @weakify(self);
    [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        @strongify(self)
        if (buttonIndex == 1)
        {
            [self startAPGSWithAnimate:NO];
        }
        else
        {
            [[AGPSManager shareInstance] reset];
        }

    } title:LS(@"common.popbox.title.tip") message:LS(@"football.failed.pop.text") cancelButtonName:LS(@"common.btn.cancel") otherButtonTitle:LS(@"football.failed.pop.retry") style:GBALERT_STYLE_CANCEL_GREEN];
}

#pragma mark - 搜星指令

// 监听搜星进度
-(void)observeProgressStatus
{
    @weakify(self)
    void(^initBlock)() = ^{
        
        @strongify(self)
        AGPSProgressStatus progressStatus = [AGPSManager shareInstance].progressStatus;
        iBeaconStatus status = [AGPSManager shareInstance].status;
        
        switch (progressStatus) {
            case AGPSProgressStatus_DownAGPS:{
                if (status == iBeaconStatus_Searching ||
                    status == iBeaconStatus_Sport) {
                    [self.progressLabelView setState:PROGRESS_STATE_ING0];
                    [self UIStartAPGSWithAnimate:NO];
                }
            }
                
                break;
            case AGPSProgressStatus_WriteAGPS:{
                if (status == iBeaconStatus_Searching ||
                    status == iBeaconStatus_Sport) {
                    [self.progressLabelView setState:PROGRESS_STATE_ING1];
                    [self UIStartAPGSWithAnimate:NO];
                }
            }
                break;
            case AGPSProgressStatus_Searching:{
                if (status == iBeaconStatus_Searching ||
                    status == iBeaconStatus_Sport) {
                    [self.progressLabelView setState:PROGRESS_STATE_ING2];
                    [self UIStartAPGSWithAnimate:NO];
                }
            }
                break;
            case AGPSProgressStatus_Success:
                if (status == iBeaconStatus_Searching ||
                    status == iBeaconStatus_Sport) {
                    [self doAGPSSuccess];
                }
                break;
            case AGPSProgressStatus_Failure:
            {
                if (status == iBeaconStatus_Searching ||
                    status == iBeaconStatus_Sport) {
                    [self UIStopAPGS];
                    [self doAGPSFail];
                }
            }
                
                break;
                
            default:
                [self.progressLabelView setState:PROGRESS_STATE_GUIDE];
                break;
        }
    };
    
    //初始化状态
    BLOCK_EXEC(initBlock);
    
    [self.yah_KVOController observe:[AGPSManager shareInstance] keyPaths:@[@"progressStatus"] block:^(id observer, id object, NSDictionary *change) {
        
        BLOCK_EXEC(initBlock);
    }];
    
}

// 开始搜星
-(void)startAPGSWithAnimate:(BOOL)animate{
    
    void(^enterFootballBlock)() = ^{
        @weakify(self)
        [[AGPSManager shareInstance] enterFootballModel:^(NSError* error){
            @strongify(self)
            if(error){
                [self showToastWithText:error.domain];
                return;
            }
            [self UIStartAPGSWithAnimate:animate];
        }];
    };
    
    @weakify(self)
    if (![[GBBluetoothManager sharedGBBluetoothManager] isConnectedBean]) {
        [[GBBluetoothManager sharedGBBluetoothManager] connectBeaconWithUI:^(NSError *error) {
            @strongify(self)
            if (error) {
                [self showToastWithText:error.domain];
            }else {
                enterFootballBlock();
            }
        }];
    }else {
        enterFootballBlock();
    }
}

// 取消搜星
-(void)cancelAGPS{
    @weakify(self)
    [[AGPSManager shareInstance] cancelAGPS:^(NSError *error){
        @strongify(self)
        if(error){
            [self showToastWithText:error.domain];
            return;
        }
        [self UIStopAPGS];
    }];
}

#pragma mark - UI展示

-(void)setupButtonStyle
{
    [self.syncDataButton setupNomalTextColor:[UIColor greenColor] pressColor:[UIColor greenColor]];
    [self.syncDataButton setupNomalBorderColor:[UIColor colorWithHex:0x3f3f3f] pressColor:[UIColor colorWithHex:0x3f3f3f]];
    [self.syncDataButton setupNomalBackColor:[UIColor clearColor] pressColor:[UIColor blackColor]];
    [self.cancelButton setupNomalTextColor:[UIColor greenColor] pressColor:[UIColor greenColor]];
    [self.cancelButton setupNomalBorderColor:[UIColor colorWithHex:0x3f3f3f] pressColor:[UIColor colorWithHex:0x3f3f3f]];
    [self.cancelButton setupNomalBackColor:[UIColor clearColor] pressColor:[UIColor blackColor]];
    self.cancelButton.enabled = YES;
    self.footBallButton.enabled = YES;
    self.syncDataButton.enabled = YES;
}

-(void)UIStartAPGSWithAnimate:(BOOL)animate
{
    [self.towerView animationStart];
    [self.towerView showTowerView:animate];
    if (animate) {
        [GBPopAnimateTool popFade:self.cancelButton fade:NO repeat:NO duration:0.5 beginTime:0 completionBlock:nil];
        [GBPopAnimateTool popFade:self.footBallButton fade:YES repeat:NO duration:0.5 beginTime:0 completionBlock:nil];
        [GBPopAnimateTool popFade:self.syncDataButton fade:YES repeat:NO duration:0.5 beginTime:0 completionBlock:nil];
        [GBPopAnimateTool popFade:self.noteLabel fade:NO repeat:NO duration:0.5 beginTime:0 completionBlock:nil];
        [GBPopAnimateTool popFade:self.noteOneLabel fade:YES repeat:NO duration:0.5 beginTime:0 completionBlock:nil];
        [GBPopAnimateTool popFade:self.noteTwoLabel fade:YES repeat:NO duration:0.5 beginTime:0 completionBlock:nil];
        [GBPopAnimateTool popFade:self.quitGameButton fade:YES repeat:NO duration:0.5 beginTime:0 completionBlock:nil];
        return;
    }
    self.cancelButton.alpha     = 1;
    self.footBallButton.alpha   = 0;
    self.syncDataButton.alpha   = 0;
    self.noteLabel.alpha        = 1;
    self.noteOneLabel.alpha      = 0;
    self.noteTwoLabel.alpha      = 0;
    self.quitGameButton.alpha   = 0;
}

-(void)UIStopAPGS
{
    [self.towerView animationStop];
    [self.towerView showFootBallView:YES];
    [GBPopAnimateTool popFade:self.cancelButton fade:YES repeat:NO duration:0.5 beginTime:0 completionBlock:nil];
    [GBPopAnimateTool popFade:self.footBallButton fade:NO repeat:NO duration:0.5 beginTime:0 completionBlock:nil];
    [GBPopAnimateTool popFade:self.syncDataButton fade:NO repeat:NO duration:0.5 beginTime:0 completionBlock:nil];
    [GBPopAnimateTool popFade:self.noteLabel fade:YES repeat:NO duration:0.5 beginTime:0 completionBlock:nil];
    [GBPopAnimateTool popFade:self.noteOneLabel fade:NO repeat:NO duration:0.5 beginTime:0 completionBlock:nil];
    [GBPopAnimateTool popFade:self.noteTwoLabel fade:NO repeat:NO duration:0.5 beginTime:0 completionBlock:nil];
    [GBPopAnimateTool popFade:self.quitGameButton fade:NO repeat:NO duration:0.5 beginTime:0 completionBlock:nil];
    [self.progressLabelView setState:PROGRESS_STATE_GUIDE];
}

-(UIButton*)menuButton
{
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 80, 40);
    [menuBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [menuBtn setTitle:LS(@"footballmode.menu.quitgame") forState:UIControlStateNormal];
    menuBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    @weakify(self)
    [menuBtn addActionHandler:^(NSInteger tag) {
        @strongify(self)
        
        [UMShareManager event:Analy_Click_Game_Exit1];
        
        UserInfo *userInfo = [RawCacheManager sharedRawCacheManager].userInfo;
        BOOL isCreateMatch = userInfo.matchInfo.creator_id == userInfo.userId;
        NSString *messgae = isCreateMatch ? LS(@"sync.quit.popbox.label.message.creator"):LS(@"sync.quit.popbox.label.message.jion");
        @weakify(self)
        [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex){
            if (buttonIndex == 1)
            {
                @strongify(self)
                [self showLoadingToast];
                [MatchRequest deleteMatch:userInfo.matchInfo.match_id isCreator:isCreateMatch handler:^(id result, NSError *error)
                 {
                     [self dismissToast];
                     if (error){
                         [self showToastWithText:error.domain];
                     }else {
                         [[NSNotificationCenter defaultCenter] postNotificationName:Notification_DeleteMatchSuccess object:nil];
                     }
                 }];
            }
        } title:LS(@"common.popbox.title.tip") message:messgae cancelButtonName:LS(@"common.btn.cancel") otherButtonTitle:LS(@"common.btn.yes") style:GBALERT_STYLE_NOMAL];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    return menuBtn;
}
@end
