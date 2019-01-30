//
//  GBMenuViewController+Bluetooth.m
//  GB_Football
//
//  Created by 王时温 on 2017/6/5.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBMenuViewController+Bluetooth.h"
#import "GBMenuViewController_Blue.h"
#import "GBScanViewController.h"
#import "GBStartRunViewController.h"
#import "GBEndRunViewController.h"
#import "GBFootBallModeViewController.h"
#import "GBSyncDataViewController.h"

#import "UIImage+RTTint.h"

#import "GBBluetoothManager.h"
#import "AGPSManager.h"
#import "BaseNetworkRequest.h"
#import "RunLogic.h"

@implementation GBMenuViewController (Bluetooth)

#pragma mark - OverWrite

- (void)localizeUI {
    
    self.connectLabel.text = LS(@"menu.icon.connect");
    self.bindLabel.text = LS(@"menu.icon.bind");
    self.connectedLabel.text = LS(@"menu.icon.connected");
    self.footballSwitchLabel.text = LS(@"menu.icon.switching");
    self.connectingLabel.text = LS(@"menu.icon.connecting");
}

#pragma mark - Public

- (void)initBluetooth {
    
    //蓝牙模式初始化配置
    [[GBBluetoothManager sharedGBBluetoothManager] initConfig];
    
    [AGPSManager shareInstance];
    
    [self refreshFootballState:FOOTBALL_MODE_STATE_IDLE];
    
    [self observeGBBluetoothManagerState];
}

- (void)connectWristbandWithMac:(NSString *)mac {
    
    [GBBluetoothManager sharedGBBluetoothManager].iBeaconMac = mac;
    [[GBBluetoothManager sharedGBBluetoothManager] connectBeaconWithUI:nil];
}

- (void)updateAboutBlutoothUI {
    
    self.connectingConnectView.hidden = [GBBluetoothManager sharedGBBluetoothManager].ibeaconConnectState == iBeaconConnectState_Connecting?NO:YES;
    self.bindConnectView.hidden = [[RawCacheManager sharedRawCacheManager] isBindWristband];
    self.unConnectView.hidden = !([[RawCacheManager sharedRawCacheManager] isBindWristband] && [GBBluetoothManager sharedGBBluetoothManager].ibeaconConnectState == iBeaconConnectState_UnConnect);
    self.connectedView.hidden = !([[RawCacheManager sharedRawCacheManager] isBindWristband] && [[GBBluetoothManager sharedGBBluetoothManager] isConnectedBean]);
    self.batteryIndicator.percent = [GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.battery;
}

- (void)addBluetoothNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindiBeaconSuccess) name:Notification_ConnectSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAboutBlutoothUI) name:Notification_CancelBindSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAboutBlutoothUI) name:Notification_CancelConenctSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAboutBlutoothUI) name:Notification_ReadBatterySuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readConnnectInfoTimeOutNotification:) name:Notification_Bluetooth_ReadConnectInfoTimeOut object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark - NSNotification

- (void)bindiBeaconSuccess {
    
    [self updateAboutBlutoothUI];
    
    @weakify(self)
    void (^statusChangeBlock)(iBeaconStatus status) = ^(iBeaconStatus status){
        @strongify(self)
        switch (status) {
            case iBeaconStatus_Sport:
                [self refreshFootballState:FOOTBALL_MODE_STATE_OK_Sport];
                break;
            case iBeaconStatus_Searching:
                [self refreshFootballState:FOOTBALL_MODE_STATE_SWTICHING_Sport];
                break;
            case iBeaconStatus_Run:
                [self refreshFootballState:FOOTBALL_MODE_STATE_OK_Run];
                break;
            case iBeaconStatus_Run_Entering:
                [self refreshFootballState:FOOTBALL_MODE_STATE_SWTICHING_Run];
                break;
            case iBeaconStatus_Normal:
                [self refreshFootballState:FOOTBALL_MODE_STATE_IDLE];
                break;
            case iBeaconStatus_Unknow:
                [self refreshFootballState:FOOTBALL_MODE_STATE_IDLE];
                break;
                
            default:
                break;
        }
    };
    //界面及时更新
    statusChangeBlock([GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.status);
    
    [self.yah_KVOController observe:[AGPSManager shareInstance] keyPath:@"status" block:^(id observer, id object, NSDictionary *change) {
        
        iBeaconStatus status = [AGPSManager shareInstance].status;
        statusChangeBlock(status);
    }];
    
    //同步今日数据
    if ([RawCacheManager sharedRawCacheManager].isBindWristband) {
        [self performBlock:^{
            [LogicManager asyncToday_DailyData];
        } delay:1.0f];
    }
}

- (void)willEnterForegroundNotification {
    
    //同步今日数据
    if ([RawCacheManager sharedRawCacheManager].isBindWristband) {
        [self performBlock:^{
            [LogicManager asyncToday_DailyData];
        } delay:1.0f];
    }
}

- (void)readConnnectInfoTimeOutNotification:(NSNotification *)notification {
    
    NSString *errorString = notification.object;
    [BaseNetworkRequest sendErrorReport:[NSError errorWithDomain:@"" code:KBlueTooth_Error_Code userInfo:@{AFNetworkingOperationFailingURLResponseErrorKey:errorString?errorString:@"string is empty"}] uri:KBlueTooth_Error_Uri];
}

#pragma mark - Action

// 点击并取消足球模式
- (IBAction)actionSwitchToQuitFootballMode:(id)sender {
    if (self.footballState == FOOTBALL_MODE_STATE_IDLE) {
        return;
    }
    
    [UMShareManager event:Analy_Click_Menu_ExitFB];
    
//    if (self.footballState == FOOTBALL_MODE_STATE_SWTICHING_Run) {
//        GBStartRunViewController *viewController = [[GBStartRunViewController alloc]init];
//        [self.navigationController pushViewController:viewController animated:YES];
//        
//    } else if (self.footballState == FOOTBALL_MODE_STATE_OK_Run) {
//        [self showLoadingToast];
//        @weakify(self)
//        [[GBBluetoothManager sharedGBBluetoothManager] readRunTime:^(id data, NSError *error) {
//            @strongify(self)
//            if (error) {
//                [self showToastWithText:error.domain];
//            }else {
//                [self dismissToast];
//                NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[RunLogic runBeginTime:data]];
//                GBEndRunViewController *viewController = [[GBEndRunViewController alloc]initWithStartDate:startDate];
//                [self.navigationController pushViewController:viewController animated:YES];
//            }
//        } level:GBBluetoothTask_PRIORITY_Hight];
//        
//    } else if (self.footballState == FOOTBALL_MODE_STATE_SWTICHING_Sport || self.footballState == FOOTBALL_MODE_STATE_OK_Sport) {
//        
//        if (![RawCacheManager sharedRawCacheManager].userInfo.matchInfo) {
//            NSString *title = LS(@"football.failed.pop.quit");
//            NSString *message = LS(@"football.quit.pop.text");
//            [self UIEffectSwitchToQuit];
//            @weakify(self)
//            [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
//                @strongify(self)
//                if (buttonIndex == 1){
//                    [[AGPSManager shareInstance] cancelAGPS:^(NSError *error){
//                        if(error){
//                            [self showToastWithText:error.domain];
//                            return;
//                        }
//                        [self refreshFootballState:FOOTBALL_MODE_STATE_IDLE];
//                    }];
//                }
//            } title:title message:message
//                               cancelButtonName:LS(@"football.quit.pop.cancel" )
//                               otherButtonTitle:LS(@"football.quit.pop.ok")
//                                          style:GBALERT_STYLE_CANCEL_GREEN];
//            
//        } else if (self.footballState == FOOTBALL_MODE_STATE_SWTICHING_Sport) {
//            [self.navigationController pushViewController:[[GBFootBallModeViewController alloc] init] animated:YES];
//            
//        } else if (self.footballState == FOOTBALL_MODE_STATE_OK_Sport) {
//            [self.navigationController pushViewController:[[GBSyncDataViewController alloc]
//                                                           initWithMatchId:[RawCacheManager sharedRawCacheManager].userInfo.matchInfo.match_id
//                                                           showSportCard:NO] animated:YES];
//        }
//
//    }
    NSString *title = LS(@"football.failed.pop.quit");
    NSString *message = LS(@"football.quit.pop.text");
    if (self.footballState == FOOTBALL_MODE_STATE_SWTICHING_Run ||
        self.footballState == FOOTBALL_MODE_STATE_OK_Run) {
        title = LS(@"run.model.exit");
        message = LS(@"run.model.exit.makesure");
    }
    [self UIEffectSwitchToQuit];
    @weakify(self)
    [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        @strongify(self)
        if (buttonIndex == 1){
            [[AGPSManager shareInstance] cancelAGPS:^(NSError *error){
                if(error){
                    [self showToastWithText:error.domain];
                    return;
                }
                [self refreshFootballState:FOOTBALL_MODE_STATE_IDLE];
            }];
        }
    } title:title message:message
                       cancelButtonName:LS(@"football.quit.pop.cancel" )
                       otherButtonTitle:LS(@"football.quit.pop.ok")
                                  style:GBALERT_STYLE_CANCEL_GREEN];

}

- (IBAction)actionConnect:(id)sender {
    
    [UMShareManager event:Analy_Click_Menu_Bind];
    
    if (![[RawCacheManager sharedRawCacheManager] isBindWristband]) {
        [self.navigationController pushViewController:[GBScanViewController new] animated:YES];
    }else if (![[GBBluetoothManager sharedGBBluetoothManager] isConnectedBean]) {
        [[GBBluetoothManager sharedGBBluetoothManager] connectBeaconWithUI:^(NSError *error) {
            if (!error) {
                [self updateAboutBlutoothUI];
            }
        }];
    }
}

#pragma mark - Private

// 监听状态
-(void)observeGBBluetoothManagerState
{
    @weakify(self)
    [self.yah_KVOController observe:[GBBluetoothManager sharedGBBluetoothManager]
                            keyPath:@"ibeaconConnectState"
                              block:^(id observer, id object, NSDictionary *change) {
                                  @strongify(self)
                                  [self updateAboutBlutoothUI];
                              }];
}


-(void)UIEffectSwitchToQuit
{
    self.footballSwitchView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:0.5 delay:0.1 usingSpringWithDamping:0.3 initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveLinear animations:^{
                            self.footballSwitchView.transform = CGAffineTransformIdentity;
                        } completion:nil];
}

#pragma mark - Setter Getter

-(void)refreshFootballState:(FOOTBALL_MODE_STATE)footballState
{
    self.footballState = footballState;
    switch (footballState)
    {
        case FOOTBALL_MODE_STATE_IDLE:
        {
            self.footballSwitchView.alpha = 0.f;
            self.footballSwitchLabel.alpha = 0.f;
        }
            break;
        case FOOTBALL_MODE_STATE_SWTICHING_Sport:
        {
            self.footballSwitchView.alpha = 1.f;
            self.footballSwitchImageView.image =  [[UIImage imageNamed:@"football_w"] rt_tintedImageWithColor:[UIColor whiteColor] level:1.0];
            self.footballSwitchLabel.alpha = 1.f;
        }
            break;
        case FOOTBALL_MODE_STATE_OK_Sport:
        {
            self.footballSwitchView.alpha = 1.f;
            self.footballSwitchImageView.image =  [[UIImage imageNamed:@"football_w"] rt_tintedImageWithColor:[UIColor greenColor] level:1.0];
            self.footballSwitchLabel.alpha = 0.f;
        }
            break;
        case FOOTBALL_MODE_STATE_SWTICHING_Run:
        {
            self.footballSwitchView.alpha = 1.f;
            self.footballSwitchImageView.image =  [[UIImage imageNamed:@"running_w"] rt_tintedImageWithColor:[UIColor whiteColor] level:1.0];
            self.footballSwitchLabel.alpha = 1.f;
        }
            break;
        case FOOTBALL_MODE_STATE_OK_Run:
        {
            self.footballSwitchView.alpha = 1.f;
            self.footballSwitchImageView.image =  [[UIImage imageNamed:@"running_w"] rt_tintedImageWithColor:[UIColor greenColor] level:1.0];
            self.footballSwitchLabel.alpha = 0.f;
        }
            break;
        default:
            break;
    }
}


@end
