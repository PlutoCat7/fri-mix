//
//  GBMakePairViewController.m
//  GB_Football
//
//  Created by Pizza on 2016/12/19.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBMakePairViewController.h"
#import "GBScanViewController.h"
#import "SystemRequest.h"
#import "GBBluetoothManager.h"
#import "GBPairView.h"
#import "GBBorderButton.h"
#import "GBPopAnimateTool.h"

@interface GBMakePairViewController ()

@property (nonatomic, strong) WristbandFilterInfo *wristbandInfo;

/**
 是否正在发起绑定手环的请求
 */
@property (nonatomic, assign) BOOL isBinding;

/**
 手环是否连接失败
 */
@property (nonatomic, assign) BOOL isFailToConnect;

@property (weak, nonatomic) IBOutlet GBBorderButton *bottomButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet GBPairView *pairView;

//监听
@property (nonatomic, strong) id observer;

@end

@implementation GBMakePairViewController

- (void)dealloc
{
    [self.pairView pop_removeAllAnimations];
    [[NSNotificationCenter defaultCenter] removeObserver:self.observer];
    self.observer = nil;
    if (![RawCacheManager sharedRawCacheManager].isBindWristband ) {
        
        [[GBBluetoothManager sharedGBBluetoothManager] resetGBBluetoothManager];
    }
    if ([RawCacheManager sharedRawCacheManager].isBindWristband) { //连接成功
        [[UpdateManager shareInstance] checkFirewareUpdate:nil];
    }
}

- (instancetype)initWithWristbandInfo:(WristbandFilterInfo *)info {
    
    self = [super init];
    if (self) {
        _wristbandInfo = info;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Action

// 用其他方式点击手环
- (IBAction)actionPressButton
{
    if (self.isFailToConnect) {
        @weakify(self)
        [self UIFailedToConnecting:^{
            
            @strongify(self)
            [self findiBeacon];
        }];
    }else {
        @weakify(self)
        [self UIConnectedToConnecting:^{
            
            @strongify(self)
            [self findiBeacon];
        }];
    }
}

#pragma mark - Private

- (void)setupUI
{
    self.title = LS(@"pair.button.bind");
    [self setupBackButtonWithBlock:nil];
    [self.bottomButton setupNomalBorderColor:[UIColor colorWithHex:0x909090] pressColor:[UIColor colorWithHex:0x212121]];
    [self performSelector:@selector(findiBeacon) withObject:nil afterDelay:2.0];
}

- (void)loadData {
    [GBBluetoothManager sharedGBBluetoothManager].iBeaconMac = self.wristbandInfo.mac;
    [GBBluetoothManager sharedGBBluetoothManager].iBeaconObj = self.wristbandInfo.ibeacon;
}

-(void)localizeUI
{
    [self.bottomButton  setTitle:LS(@"") forState:UIControlStateNormal];
    [self.titleLabel    setText:LS(@"pair.label.title.connecting")];
    [self.subTitleLabel setText:LS(@"pair.label.subtitle.connecting")];
}

- (void)findiBeacon {
    
    @weakify(self)
    [[GBBluetoothManager sharedGBBluetoothManager] searchWristWithComplete:^(NSError *error) {
        
        @strongify(self)
        if (!error) {//等待设备返回双击事件
            @weakify(self)
            [self UIConnectingToConnected:^{
                
                @strongify(self)
                [self waitingForiBeaconRespone];
                [[GBBluetoothManager sharedGBBluetoothManager] stopSearchWristWithComplete:nil];
            }];
        }else {
            [self UIConnetingToFailed:nil];
        }
        self.isFailToConnect = error?YES:NO;
    }];
}

- (void)waitingForiBeaconRespone {
    
    if (self.observer) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.observer];
        self.observer = nil;
    }
    @weakify(self)
    self.observer = [[NSNotificationCenter defaultCenter] addObserverForName:Notification_DeviceCheck object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        @strongify(self)
        GBLog(@"手环双击");
        if (self.isBinding) {
            return;
        }
        self.isBinding = YES;
        [self showLoadingToast];
        @weakify(self)
        [SystemRequest bindWristband:self.wristbandInfo.number handler:^(id result, NSError *error) {
            
            @strongify(self)
            [self dismissToast];
            if (error) {
                [self showToastWithText:error.domain];
            }else {
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_BindSuccess object:nil];
                [self showToastWithText:LS(@"pair.toast.success")];
                @weakify(self)
                [self performBlock:^{
                    
                    @strongify(self)
                    [self dismissToast];
                    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                    [viewControllers removeLastObject];
                    [viewControllers removeLastObject];
                    if ([viewControllers.lastObject isMemberOfClass:[GBScanViewController class]]) {
                        [viewControllers removeLastObject];
                    }
                    [self.navigationController setViewControllers:viewControllers animated:YES];
                } delay:1.5f];
            }
            self.isBinding = NO;
        }];
    }];
}

#pragma mark - UI操作
// 从连接中 到 连接成功
-(void)UIConnectingToConnected:(void(^)())completionBlock
{
    self.bottomButton.enabled = YES;
    [self.bottomButton setupNomalTextColor:[UIColor colorWithHex:0x909090] pressColor:[UIColor whiteColor]];
    [self.bottomButton setTitle:LS(@"pair.button.noshake") forState:UIControlStateNormal];
    @weakify(self)
    [GBPopAnimateTool popFade:self.bottomButton fade:NO repeat:NO duration:1.0 beginTime:2.5 completionBlock:^{
        @strongify(self)
        self.bottomButton.userInteractionEnabled = YES;
        self.bottomButton.alpha = 1.f;
    }];
    [self.pairView connectingTurnToConnected:^{
        @strongify(self)
        self.titleLabel.text = LS(@"pair.label.title.double");
        
        if ([GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.t_goal_Version == iBeaconVersion_T_Goal_S) {
            self.subTitleLabel.text = LS(@"pair.label.subtitle.double.tgoals");
        } else {
            self.subTitleLabel.text = LS(@"pair.label.subtitle.double.tgoal");
        }
        
        BLOCK_EXEC(completionBlock);
    }];
}
// 从连接成功 到 连接中
-(void)UIConnectedToConnecting:(void(^)())completionBlock
{
    self.bottomButton.userInteractionEnabled = NO;
    @weakify(self)
    [GBPopAnimateTool popFade:self.bottomButton fade:YES repeat:NO duration:1.0 beginTime:0 completionBlock:^{
        @strongify(self)
        self.bottomButton.alpha = 0.f;
    }];
    [self.pairView connectedTurnToConnecting:^{
        @strongify(self)
        [self.titleLabel setText:LS(@"pair.label.title.connecting")];
        [self.subTitleLabel setText:LS(@"pair.label.subtitle.connecting")];
        BLOCK_EXEC(completionBlock);
    }];
}

// 从连接中 到 连接失败
-(void)UIConnetingToFailed:(void(^)())completionBlock
{
    [self.bottomButton setupNomalTextColor:[UIColor whiteColor] pressColor:[UIColor colorWithHex:0x909090]];
    [self.bottomButton setTitle:LS(@"pair.button.retry") forState:UIControlStateNormal];
    @weakify(self)
    [GBPopAnimateTool popFade:self.bottomButton fade:NO repeat:NO duration:1.0 beginTime:1.0 completionBlock:^{
        @strongify(self)
        self.bottomButton.userInteractionEnabled = YES;
        self.bottomButton.alpha = 1.0;
        self.bottomButton.enabled = YES;
    }];
    [self.pairView connectingTurnToFailed:^{
        @strongify(self)
        self.titleLabel.text = LS(@"pair.label.title.failed");
        self.subTitleLabel.text = LS(@"pair.label.subtitle.failed");
        BLOCK_EXEC(completionBlock);
    }];
}

// 从连接失败 到连接中
-(void)UIFailedToConnecting:(void(^)())completionBlock
{
    self.bottomButton.userInteractionEnabled = NO;
    @weakify(self)
    [GBPopAnimateTool popFade:self.bottomButton fade:YES repeat:NO duration:1.0 beginTime:0 completionBlock:^{
        @strongify(self)
        self.bottomButton.alpha = 0.f;
    }];
    [self.pairView failedTurnToConnecting:^{
        @strongify(self)
        [self.titleLabel setText:LS(@"pair.label.title.connecting")];
        [self.subTitleLabel setText:LS(@"pair.label.subtitle.failed")];
        BLOCK_EXEC(completionBlock);
    }];
}

@end
