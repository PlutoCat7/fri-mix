//
//  UpdateManager.m
//  GB_Football
//
//  Created by 王时温 on 2016/11/8.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "UpdateManager.h"
#import "AFNetworkReachabilityManager.h"
#import "SystemRequest.h"
#import "GBBluetoothManager.h"
#import "GBHardUpdateView.h"
#import "AppDelegate.h"
#import "GBAlertViewTwoWay.h"
#import "GBAlertViewOneWay.h"
#import "GB_Football-Swift.h"

#define kAppUpdateAlertView_Tag  1001
#define kFirewareUpdateAlertView_Tag  1002

@interface UpdateManager () <
DFUServiceDelegate,
DFUProgressDelegate,
DFUPeripheralSelectorDelegate>

@property (nonatomic, strong) DFUServiceController *dfuServiceController;
@property (nonatomic, strong) GBHardUpdateView *updateProgressView;

@end

@implementation UpdateManager

+ (instancetype)shareInstance {
    
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[UpdateManager alloc] init];
    });
    return instance;
}

- (void)startMonitoring {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkingReachabilityDidChangeNotification:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindSuccessNotification) name:Notification_ConnectSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(invalidBlueToothCommand) name:Notification_Bluetooth_Invalid_Command object:nil];
}

- (void)stopMonitoring {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AFNetworkingReachabilityDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_ConnectSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_Bluetooth_Invalid_Command object:nil];
}

#pragma mark Public

- (void)checkAppAndFirewareUpdate {
    
    [self performBlock:^{
        [self checkAppUpdate:^(NSString *url, NSError *error) {
            
            if (!(url.length>0)) {
                if (![[GBBluetoothManager sharedGBBluetoothManager] isConnectedBean]) {
                    return;
                }
                [self checkFirewareUpdate:nil];
            }
        }];
    } delay:1.0f];
}

- (void)checkAppUpdate:(void(^)(NSString *url, NSError *error))complete {
    
    [SystemRequest checkAppVersion:^(id result, NSError *error) {
        
        ApkUpdateInfo *info = result;
        if (!error && info.apkUrl.length>0) {
            [self needAppUpdate:info.isForce apkUrl:info.apkUrl content:info.content];
        }
        BLOCK_EXEC(complete, info.apkUrl, error);
    }];
}

- (void)checkFirewareUpdate:(void(^)(NSString *url, NSError *error))complete {
    
    if (![RawCacheManager sharedRawCacheManager].isBindWristband) {
        return;
    }
    
    [SystemRequest checkFirewareUpgrade:^(id result, NSError *error) {
        
        FirewareUpdateInfo *info = result;
        if (info.firewareUrl.length > 0) {
            [self needFirewareUpdate:info.isForce firewareUrl:info.firewareUrl];
        }
        BLOCK_EXEC(complete, info.firewareUrl, error);
    }];
}

- (void)checkAppUpdateWithMessageType:(MessageType)type {
    
    switch (type) {
        case MessageType_None:
        case MessageType_Friend:
        case MessageType_MatchData:
        case MessageType_InsideWeb:
        case MessageType_OutsideWeb:
            break;
            
        default:  //无效type检查是否需要升级
            //检查app是否需要更新
            [self checkAppUpdate:nil];
            break;
    }
}

- (BOOL)checkNeedAppUpdateWithPushType:(PushType)type {
    
    switch (type) {
        case MessageType_None:
        case PushType_Friend:
        case PushType_MatchData:
        case PushType_InsideWeb:
        case PushType_OutsideWeb:
        case PushType_MatchInvite:
        case PushType_TEAM_INVITE:
        case PushType_TEAM_APPLY:
        case PushType_TEAM_ACCEPT_APPLY:
        case PushType_TEAM_REFUSE_APPLY:
        case PushType_TEAM_ACCEPT_INVITE:
            return NO;
            break;
            
        default:  //无效type检查是否需要升级
            //检查app是否需要更新
            [self checkAppUpdate:nil];
            return YES;
            break;
    }
    return YES;
}

#pragma mark - Notification

- (void)networkingReachabilityDidChangeNotification:(NSNotification *)notification {
    
    if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
        [self checkAppAndFirewareUpdate];
    }
}

- (void)bindSuccessNotification {
    
    if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
        [self checkFirewareUpdate:nil];
    }
}

- (void)invalidBlueToothCommand {
    
    if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
        [self checkFirewareUpdate:nil];
    }
}

#pragma mark - Private

- (void)needAppUpdate:(BOOL)isForce apkUrl:(NSString *)url content:(NSString*)content
{
    // 强制更新
    if (isForce == YES)
    {
        [GBAlertViewOneWay showWithTitle:LS(@"appupdate.label.title") content:content button:LS(@"common.btn.update") onOk:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            [self exitApplication];
        } style:GBALERT_STYLE_NOMAL];
        return;
    }
    // 非强制更新
    else if (isForce == NO)
    {
        [GBAlertViewTwoWay showWithTitle:LS(@"appupdate.label.title") content:content
                           buttonStrings:@[LS(@"common.btn.update"),LS(@"common.btn.cancel"),] onOk:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];} onCancel:nil];
    }
}

- (void)needFirewareUpdate:(BOOL)isForce firewareUrl:(NSString *)firewareUrl {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_NeedUpdateFireware object:nil];
    
    GBAlertView *alertView = [[UIApplication sharedApplication].keyWindow viewWithTag:kFirewareUpdateAlertView_Tag];
    if (alertView) {
        return;
    }
    
    alertView = [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            [self syncUpdateFireware:firewareUrl];
        }else if (buttonIndex == 0) {
            if (isForce) {//断开蓝牙连接
                [[GBBluetoothManager sharedGBBluetoothManager] disconnectBeacon];
            }
        }
    } title:LS(@"common.popbox.title.tip") message:(isForce ? LS(@"setting.hint.force.upate.firmware") : LS(@"setting.hint.upate.firmware")) cancelButtonName:LS(@"common.btn.cancel") otherButtonTitle:LS(@"common.btn.update") style:GBALERT_STYLE_NOMAL];
    alertView.tag = kFirewareUpdateAlertView_Tag;
}

// 异步更新固件
- (void)syncUpdateFireware:(NSString *)firewareUrl
{
    GBHardUpdateView *updateProgressView = [[[NSBundle mainBundle] loadNibNamed:@"GBHardUpdateView" owner:nil options:nil] lastObject];
    updateProgressView.deviceUpdateType = ([GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.t_goal_Version == iBeaconVersion_T_Goal_S) ? UPDATE_TYPE_NO_BUTTON :  UPDATE_TYPE_HAVE_BUTTON;
    updateProgressView.firmversion = [GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.firewareVersion;
    dispatch_async(dispatch_get_main_queue(), ^{
        [updateProgressView show];
    });
    updateProgressView.didClickButton = ^(NSInteger index) {
        if (index == 1) {
            [[GBBluetoothManager sharedGBBluetoothManager] connectBeaconWithUI:nil];
        }
    };
    [SystemRequest downloadFirewareFile:firewareUrl handler:^(id result, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [updateProgressView remove];
            });
            [[UIApplication sharedApplication].keyWindow showToastWithText:error.domain];
        } else {
            [updateProgressView setupState:STATE_PROGRAMMING];
            [self performBlock:^{
                NSURL *filePath = result;
                if ( [GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.t_goal_Version == iBeaconVersion_T_Goal_S) {
                    [self DFU_fireware:filePath progressView:updateProgressView];
                }else {
                    [self BIN_fireware:filePath progressView:updateProgressView];
                }
            } delay:1.0f];
        }
    } progress:^(CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
        [updateProgressView setupState:STATE_PROGRAMMING];
        updateProgressView.percent = 0;
        });
    }];
}

- (void)BIN_fireware:(NSURL *)filePath progressView:(GBHardUpdateView *)updateProgressView {
    
    if (![[filePath pathExtension] isEqualToString:@"img"] || (![RawCacheManager sharedRawCacheManager].isBindWristband || ![GBBluetoothManager sharedGBBluetoothManager].isConnectedBean)) {
        [updateProgressView remove];
        [[UIApplication sharedApplication].keyWindow showToastWithText:LS(@"bluetooth.write.fail")];
    }
    [[GBBluetoothManager sharedGBBluetoothManager] updateFireware:filePath complete:^(NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [updateProgressView remove];
                [[UIApplication sharedApplication].keyWindow showToastWithText:error.domain];
            });
        }else {
            [[GBBluetoothManager sharedGBBluetoothManager] disconnectBeacon];
            dispatch_async(dispatch_get_main_queue(), ^{
                [updateProgressView setupState:STATE_PROGRAM_FINISH];
            });
        }
    } progressBlock:^(NSProgress *progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [updateProgressView setupState:STATE_PROGRAMMING];
            updateProgressView.percent = ((CGFloat)progress.completedUnitCount/progress.totalUnitCount)*100;
        });
    }];
}

- (void)DFU_fireware:(NSURL *)filePath progressView:(GBHardUpdateView *)updateProgressView {
    
    if (![[filePath pathExtension] isEqualToString:@"zip"] || (![RawCacheManager sharedRawCacheManager].isBindWristband || ![GBBluetoothManager sharedGBBluetoothManager].isConnectedBean)) {
        [updateProgressView remove];
        [[UIApplication sharedApplication].keyWindow showToastWithText:LS(@"bluetooth.write.fail")];
        return;
    }

    DFUFirmware *selectedFirmware = [[DFUFirmware alloc] initWithUrlToZipFile:filePath];
    if (!selectedFirmware) {
        [updateProgressView remove];
        [[UIApplication sharedApplication].keyWindow showToastWithText:LS(@"bluetooth.write.fail")];
        return;
    }
    
    CBPeripheral *peripheral = [GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.peripheral;
    [[GBBluetoothManager sharedGBBluetoothManager] enterLipiUpdate];
    self.updateProgressView = updateProgressView;
    
    DFUServiceInitiator *initiator = [[[DFUServiceInitiator alloc] initWithCentralManager:[GBBluetoothManager sharedGBBluetoothManager].manager target:peripheral] withFirmware:selectedFirmware];
    initiator.delegate = self;
    initiator.progressDelegate = self;
    initiator.enableUnsafeExperimentalButtonlessServiceInSecureDfu = YES;
    initiator.peripheralSelector = self;
    self.dfuServiceController = [initiator start];
}

- (void)exitApplication {
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *window = app.window;
    
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
    } completion:^(BOOL finished) {
        exit(0);
    }];
    
}

#pragma mark - DFU  Delegate

- (void)dfuStateDidChangeTo:(enum DFUState)state {
    
    switch (state) {
        case DFUStateCompleted:
            [self.updateProgressView setupState:STATE_PROGRAM_FINISH];
            [[GBBluetoothManager sharedGBBluetoothManager] overLipiUpdate];
            break;
        case DFUStateUploading:
            break;
        case DFUStateDisconnecting:   //退出后台，再进入前台无法响应DFUStateCompleted
        {
            if (self.updateProgressView.percent>=1.0) {
                [self.updateProgressView setupState:STATE_PROGRAM_FINISH];
                [[GBBluetoothManager sharedGBBluetoothManager] overLipiUpdate];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)dfuError:(enum DFUError)error didOccurWithMessage:(NSString *)message {
    
    if (error) {
        [self.updateProgressView remove];
        [[UIApplication sharedApplication].keyWindow showToastWithText:LS(@"bluetooth.write.fail")];
        
        [[GBBluetoothManager sharedGBBluetoothManager] overLipiUpdate];
    }
}

- (void)dfuProgressDidChangeFor:(NSInteger)part outOf:(NSInteger)totalParts to:(NSInteger)progress currentSpeedBytesPerSecond:(double)currentSpeedBytesPerSecond avgSpeedBytesPerSecond:(double)avgSpeedBytesPerSecond {
    
    [self.updateProgressView setupState:STATE_PROGRAMMING];
    self.updateProgressView.percent = progress;
    
    GBLog(@"当前固件写入速度:%lf bit", currentSpeedBytesPerSecond);
    GBLog(@"平均固件写入速度:%lf bit", avgSpeedBytesPerSecond);
}

//切换到dfu模式， 扫描设备时的回调
- (BOOL)select:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    
    return YES;
}

- (NSArray<CBUUID *> * _Nullable)filterByHint:(CBUUID * _Nonnull)dfuServiceUUID {
    
    return @[[CBUUID UUIDWithString:@"FE59"]];
}


@end
