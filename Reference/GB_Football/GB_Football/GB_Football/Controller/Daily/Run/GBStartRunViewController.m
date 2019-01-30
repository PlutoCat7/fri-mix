//
//  GBStartRunViewController.m
//  GB_Football
//
//  Created by gxd on 17/7/3.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBStartRunViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationManager.h>
#import "GBRunRecordViewController.h"
#import "GBEndRunViewController.h"
#import "GBMapPolylineViewController.h"
#import "GBMenuViewController.h"

#import "GBRippleView.h"
#import "GBCountDownView.h"
#import <pop/POP.h>
#import "GBAlertViewOneWay.h"

#import "AGPSManager.h"
#import "GBBluetoothManager.h"
#import "RunLogic.h"


#define MAXW  ([UIScreen mainScreen].bounds.size.width)
#define MAXH  ([UIScreen mainScreen].bounds.size.height)
#define LTime 5  //定位超时
#define RTime 3  //地理解析超时

typedef enum {
    AnimStatu_Stop = 0,
    AnimStatu_Start
}AnimStatu;

@interface GBStartRunViewController () <RippleClickDelegate>
// 地图图层
@property (strong, nonatomic) IBOutlet MAMapView *mapView;
// 定位管理器
@property (strong, nonatomic) AMapLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet GBRippleView *centerRippleView;
@property (weak, nonatomic) IBOutlet GBRippleView *syncRippleView;

@property (weak, nonatomic) IBOutlet UILabel *waitSearchStarStLbl;
@property (weak, nonatomic) IBOutlet UILabel *batteryRemindStLbl;
@property (nonatomic, strong) UIButton *rightBarButton;

// 取消收星提示弹框
@property (weak, nonatomic)  GBAlertView *cancelAGPSAlertView;
//搜星失败弹框
@property (weak, nonatomic)  GBAlertView *failureAGPSAlertView;
// 动画状态
@property (assign, nonatomic) AnimStatu animStatu;

@end

@implementation GBStartRunViewController

- (void)dealloc{
    
    [_locationManager stopUpdatingLocation];
    [self.centerRippleView endRingWithCompletionBlock];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)localizeUI {
    self.waitSearchStarStLbl.text = LS(@"run.model.label.search.star");
    self.batteryRemindStLbl.text = LS(@"run.model.label.battery.remind");
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self checkRunData:nil];
    
    [self observeProgressStatus];
    // 搜星中, 再次进入该页面重新写入星历
    if ([AGPSManager shareInstance].progressStatus == AGPSProgressStatus_Searching &&
        ([AGPSManager shareInstance].status == iBeaconStatus_Run_Entering)) {
        [self startAPGS];
    }
    
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

#pragma mark - Action

- (IBAction)actionLocateMyLocation:(id)sender {
    [self.mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
}

- (void)rightBarAction {
    
    [self.navigationController pushViewController:[GBRunRecordViewController new] animated:YES];
}

#pragma mark - RippleClickDelegate
- (void)didRippleClick:(GBRippleView *)rippleView {
    
    if (rippleView == self.centerRippleView) {
        
        // 手环未绑定
        if (![[RawCacheManager sharedRawCacheManager] isBindWristband]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_NeedBindiBeacon object:nil];
            return;
        }
        
        iBeaconStatus status = [AGPSManager shareInstance].status;
        if (status == iBeaconStatus_Run_Entering) {
            @weakify(self)
            self.cancelAGPSAlertView = [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
                @strongify(self)
                if (buttonIndex == 1) {
                    [self cancelAGPS];
                }
            } title:LS(@"run.model.exit") message:LS(@"run.model.exit.makesure") cancelButtonName:LS(@"football.cancel.pop.cancel" )otherButtonTitle:LS(@"football.cancel.pop.ok") style:GBALERT_STYLE_CANCEL_GREEN];
            
        }else {
            [self startAPGS];
        }
        
    }
    
}

#pragma mark - Private
- (void)setupUI {
    
    self.title=LS(@"run.model.nav.title");
    [self setupBackButtonWithBlock:nil];
    [self showRightButton];
    
    [self setupMapView];
    self.animStatu = AnimStatu_Stop;
    
    [self.centerRippleView setButtonBackgroudImage:[UIImage imageNamed:@"running_go_an.png"]];
    [self.centerRippleView setButtonFontSize:26];
    [self.centerRippleView setButtonTitle:LS(@"run.model.label.start")];
    self.centerRippleView.delegate = self;
    
    [self.syncRippleView setButtonBackgroudImage:[UIImage imageNamed:@"running_tb_an.png"]];
    [self.syncRippleView setButtonFontSize:14];
    [self.syncRippleView setButtonTitle:LS(@"run.model.label.sync")];
    self.syncRippleView.delegate = self;
    //隐藏
    self.syncRippleView.hidden = YES;
}

- (void)showRightButton {
    
    NSString *title = LS(@"run.model.label.record");
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToHeight:24];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setSize:size];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(rightBarAction) forControlEvents:UIControlEventTouchUpInside];
    self.rightBarButton = button;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:rightButton];
}

// 地图参数设置
-(void)setupMapView
{
    [self.mapView setRotateEnabled:YES];
    [self.mapView setSkyModelEnable:NO];
    [self.mapView setRotateCameraEnabled:NO];
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setScrollEnabled:YES];
    [self.mapView setMapType:MAMapTypeStandard];
    [self.mapView setShowsScale:NO];
    [self.mapView setShowsCompass:NO];
    [self.mapView setZoomLevel:15 animated:YES];
    [self.mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
}

- (void)checkRunData:(void(^)(BOOL hasRunData, BOOL clickSyncButton))handler {
    
    if ([AGPSManager shareInstance].status != iBeaconStatus_Normal) {
        return;
    }
    
    [self showLoadingToast];
    @weakify(self)
    [[GBBluetoothManager sharedGBBluetoothManager] readRunTime:^(id data, NSError *error) {
        @strongify(self)
        [self dismissToast];
        if (!error && data) {
            NSDictionary *timeDic = data;
            if ([timeDic isKindOfClass:[NSDictionary class]]) {
                NSInteger month = [[timeDic objectForKey:@"month"] integerValue];
                if (month>0) { //有一场未完成的比赛数据
                    [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
                        if (buttonIndex == 0) {  //放弃
                            [[GBBluetoothManager sharedGBBluetoothManager] cleanRunData:nil];
                            BLOCK_EXEC(handler, YES, NO);
                        }else if (buttonIndex == 1) { //同步
                            @weakify(self)
                            [RunLogic startAsyncRunData:^(BOOL success, NSInteger runBeginTime) {
                                @strongify(self)
                                if (success) {
                                    [self.navigationController pushViewController:[[GBMapPolylineViewController alloc] initWithStartTime:runBeginTime] animated:YES];
                                }
                            }];
                            BLOCK_EXEC(handler, YES, YES);
                        }
                    } title:LS(@"common.popbox.title.tip") message:LS(@"run.model.has.rundata.tips") cancelButtonName:LS(@"run.model.data.giveup" )otherButtonTitle:LS(@"run.model.data.sync") style:GBALERT_STYLE_SURE_GREEN];
                }else {
                    BLOCK_EXEC(handler, NO, NO);
                }
            }
        }else {
            BLOCK_EXEC(handler, NO, NO);
        }
    } level:GBBluetoothTask_PRIORITY_Normal];
}

#pragma mark Animation

- (void)UIStartAGPS {
    
    if (self.animStatu == AnimStatu_Start) {
        return;
    }
    
    self.animStatu = AnimStatu_Start;
    [self.centerRippleView setButtonTitle:LS(@"run.model.label.stop")];
    [self.centerRippleView setButtonBackgroudImageAlpha:1.f toAlpha:0.8f];
    [self.centerRippleView beginLedWithCompletionBlock];
    self.waitSearchStarStLbl.alpha = 0;
    self.waitSearchStarStLbl.hidden = NO;
    self.batteryRemindStLbl.hidden = YES;
    
    self.rightBarButton.hidden = YES;
    
    [self alpha:self.syncRippleView        fade:YES duration:0.3f beginTime:0 completionBlock:^{}];
    [self alpha:self.waitSearchStarStLbl        fade:NO duration:0.3f beginTime:0 completionBlock:^{}];
    
}

- (void)UIStopAGPS {
    if (self.animStatu == AnimStatu_Stop) {
        return;
    }
    
    self.animStatu = AnimStatu_Stop;
    [self.centerRippleView setButtonTitle:LS(@"run.model.label.start")];
    [self.centerRippleView setButtonBackgroudImageAlpha:0.8f toAlpha:1.f];
    [self.centerRippleView endRingWithCompletionBlock];
    self.waitSearchStarStLbl.alpha = 1;
    self.batteryRemindStLbl.hidden = NO;
    
    self.rightBarButton.hidden = NO;
    
    [self alpha:self.syncRippleView        fade:NO duration:0.3f beginTime:0 completionBlock:^{}];
    [self alpha:self.waitSearchStarStLbl        fade:YES duration:0.3f beginTime:0 completionBlock:^{}];
}

// alpha动画
-(void)alpha:(UIView*)view fade:(BOOL)fade duration:(CGFloat)duration beginTime:(CGFloat)beginTime completionBlock:(void(^)())completionBlock
{
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.duration = duration;
    anim.beginTime = CACurrentMediaTime() + beginTime;
    if (fade)
    {
        anim.fromValue = @(1.0);
        anim.toValue   = @(0.0);
    }
    else
    {
        anim.fromValue = @(0.0);
        anim.toValue   = @(1.0);
    }
    anim.completionBlock = ^(POPAnimation *ani, BOOL fin){
        if(fin)
        {
            [view pop_removeAnimationForKey:@"alpha"];
            BLOCK_EXEC(completionBlock);
        }
    };
    [view pop_addAnimation:anim forKey:@"alpha"];
}

#pragma mark - Getters & Setters


// 定位管理器
-(AMapLocationManager*)locationManager
{
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc]init];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [_locationManager setPausesLocationUpdatesAutomatically:NO];
        [_locationManager setLocationTimeout:LTime];
        [_locationManager setReGeocodeTimeout:RTime];
    }
    return _locationManager;
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
        if (status != iBeaconStatus_Run_Entering &&
            status != iBeaconStatus_Run) {
            return ;
        }
        
        switch (progressStatus) {
            case AGPSProgressStatus_DownAGPS:
            case AGPSProgressStatus_WriteAGPS:
            case AGPSProgressStatus_Searching:
            {
                [self UIStartAGPS];
            }
                break;
            case AGPSProgressStatus_Success:
                [self doAGPSSuccess];
                break;
            case AGPSProgressStatus_Failure:
            {
                [self UIStopAGPS];
                [self doAGPSFail];
            }
                
                break;
            default:
                
                break;
        }
    };
    
    //初始化状态
    BLOCK_EXEC(initBlock);
    
    [self.yah_KVOController observe:[AGPSManager shareInstance] keyPaths:@[@"progressStatus", @"status"] block:^(id observer, id object, NSDictionary *change) {
        
        BLOCK_EXEC(initBlock);
    }];
    
}

// 开始搜星
-(void)startAPGS {
    
    void(^enterFootballBlock)() = ^{
        //判断是否未T-Goal S
        if (!([GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.t_goal_Version == iBeaconVersion_T_Goal_S)) {
            [GBAlertViewOneWay showWithTitle:LS(@"common.popbox.title.tip") content:LS(@"run.model.not.support.tips") button:LS(@"sync.popbox.btn.got.it") onOk:nil  style:GBALERT_STYLE_NOMAL];
            return;
        }
        //判断固件版本
        if ([[GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.firewareVersion floatValue] <= 2.30) {
            [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
                
                if (buttonIndex == 1) {
                    [[UpdateManager shareInstance] checkFirewareUpdate:nil];
                }
            } title:LS(@"common.popbox.title.tip") message:LS(@"run.model.fireware.tips") cancelButtonName:LS(@"common.btn.cancel") otherButtonTitle:LS(@"common.btn.update") style:GBALERT_STYLE_NOMAL];
            return;
        }
        
        @weakify(self)
        //先检查手环里是否有数据
        [self checkRunData:^(BOOL hasRunData, BOOL clickSyncButton) {
            if (hasRunData) {
                if (!clickSyncButton) {
                    [[AGPSManager shareInstance] enterRunModel:^(NSError* error){
                        @strongify(self)
                        if(error){
                            [self showToastWithText:error.domain];
                            return;
                        }
                        [self UIStartAGPS];
                    }];
                }
            }else {
                [[AGPSManager shareInstance] enterRunModel:^(NSError* error){
                    @strongify(self)
                    if(error){
                        [self showToastWithText:error.domain];
                        return;
                    }
                    [self UIStartAGPS];
                }];
            }
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
- (void)cancelAGPS {
    
    @weakify(self)
    [[AGPSManager shareInstance] cancelAGPS:^(NSError *error){
        @strongify(self)
        if(error){
            [self showToastWithText:error.domain];
            return;
        }
        [self UIStopAGPS];
    }];
}

- (void)doAGPSSuccess {
    
    [self.cancelAGPSAlertView dismiss];
    [self.failureAGPSAlertView dismiss];
    
    [self.yah_KVOController unobserve:[AGPSManager shareInstance]];
    [[GBBluetoothManager sharedGBBluetoothManager] readRunTime:^(id data, NSError *error) {
        
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[RunLogic runBeginTime:data]];
            NSInteger timeLength = [[NSDate date] timeIntervalSinceDate:startDate];
            if (timeLength < 10) { //是否显示倒计时界面
                [GBCountDownView show:nil];
            }
            NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            [viewControllers removeLastObject];
            [viewControllers addObject:[[GBEndRunViewController alloc] initWithStartDate:startDate]];
            [self.navigationController setViewControllers:viewControllers animated:NO];
        }
    } level:GBBluetoothTask_PRIORITY_Hight];
}

- (void)doAGPSFail {
    @weakify(self);
    self.failureAGPSAlertView = [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        @strongify(self)
        if (buttonIndex == 1)
        {
            [self startAPGS];
        }
        else
        {
            [[AGPSManager shareInstance] reset];
        }
        
    } title:LS(@"common.popbox.title.tip") message:LS(@"run.model.failed.pop.text") cancelButtonName:LS(@"common.btn.cancel") otherButtonTitle:LS(@"football.failed.pop.retry") style:GBALERT_STYLE_CANCEL_GREEN];
}

@end
