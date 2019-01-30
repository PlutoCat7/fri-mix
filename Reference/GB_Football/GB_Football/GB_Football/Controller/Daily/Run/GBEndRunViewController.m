//
//  GBEndRunViewController.m
//  GB_Football
//
//  Created by gxd on 17/7/6.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBEndRunViewController.h"
#import "GBMenuViewController.h"
#import "GBStartRunViewController.h"
#import "GBMapPolylineViewController.h"

#import "GBRippleView.h"
#import "GBBottomAlertView.h"

#import "GBBluetoothManager.h"
#import "AGPSManager.h"
#import "RunLogic.h"

@interface GBEndRunViewController () <RippleClickDelegate>
@property (weak, nonatomic) IBOutlet UILabel *runDurationStLbl;
@property (weak, nonatomic) IBOutlet UIButton *unConnectButton;
@property (weak, nonatomic) IBOutlet UILabel *runTimeStLbl;
@property (weak, nonatomic) IBOutlet UILabel *runTowHourStLbl;

@property (weak, nonatomic) IBOutlet UIView *runDurationView;
@property (weak, nonatomic) IBOutlet UILabel *runDurationHourLbl;
@property (weak, nonatomic) IBOutlet UILabel *runDurationMinLbl;
@property (weak, nonatomic) IBOutlet UILabel *runDurationSecLbl;
@property (weak, nonatomic) IBOutlet UILabel *runStartTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *runDurationOnePntLbl;
@property (weak, nonatomic) IBOutlet UILabel *runDurationTwoPntLbl;

@property (weak, nonatomic) IBOutlet GBRippleView *endRippleView;
@property (weak, nonatomic) IBOutlet GBRippleView *cancelRippleView;

@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, strong) NSTimer *runningTimer;
@property (nonatomic, assign) BOOL isRetrySync;

@end

@implementation GBEndRunViewController

- (instancetype)initWithStartDate:(NSDate *)date {
    self = [super init];
    if (self) {
        _startDate = date;
    }
    return self;
    
}

- (void)dealloc{
    
}

- (void)localizeUI {
    self.runDurationStLbl.text = LS(@"run.model.label.run.duration");
    self.runTimeStLbl.text = LS(@"run.model.label.start.time");
    self.runTowHourStLbl.text = LS(@"run.model.label.long.time");
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

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [self cancelRunningTimer];
}

#pragma mark - RippleClickDelegate
- (void)didRippleClick:(GBRippleView *)rippleView {
    if (rippleView == self.endRippleView) {
        [self actionCompleteRun];
        
    } else if (rippleView == self.cancelRippleView) {
        [self actionCancelRun];
    }
}

- (void)actionCompleteRun {
    
    [GBBottomAlertView showWithTitle:LS(@"run.model.exit.and.sync") handler:^(BOOL isSure) {
        
        if (isSure) {
            [RunLogic startAsyncRunData:^(BOOL success, NSInteger runBeginTime) {
                if (success) {
                    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                    [viewControllers removeLastObject];
                    [viewControllers addObject:[[GBMapPolylineViewController alloc] initWithStartTime:runBeginTime]];
                    [self.navigationController setViewControllers:viewControllers animated:YES];
                } else {
                    self.isRetrySync = YES;
                    [self cancelRunningTimer];
                    [self refreshUIWithContectState:([GBBluetoothManager sharedGBBluetoothManager].ibeaconConnectState == iBeaconConnectState_Connected) isRetrySync:self.isRetrySync];
                }
            }];
        }
    }];
}

- (void)actionCancelRun {
    
    @weakify(self)
    [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1)
        {
            [[AGPSManager shareInstance] cancelAGPS:^(NSError *error){
                @strongify(self)
                if(error){
                    [self showToastWithText:error.domain];
                }else {
                    [[GBBluetoothManager sharedGBBluetoothManager] cleanRunData:nil];
                    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                    [viewControllers removeLastObject];
                    [viewControllers addObject:[[GBStartRunViewController alloc] init]];
                    [self.navigationController setViewControllers:viewControllers animated:YES];
                }
            }];
        }
    } title:LS(@"run.model.exit") message:LS(@"run.model.exit.makesure") cancelButtonName:LS(@"common.btn.cancel") otherButtonTitle:LS(@"common.btn.yes") style:GBALERT_STYLE_NOMAL];
}

- (IBAction)connectWristAction:(id)sender {
    
    if (![[GBBluetoothManager sharedGBBluetoothManager] isConnectedBean]) {
        [[GBBluetoothManager sharedGBBluetoothManager] connectBeaconWithUI:nil];
    }
}
#pragma mark - Private
- (void)setupUI {
    
    self.title=LS(@"run.model.nav.title");
    [self setupBackButtonWithBlock:nil];
    [self setupBluetoothStateObserve];
    [self setupUIData];
    
    [self startRunningTimer];
}

- (void)setupUIData {
    [self.endRippleView setButtonBackgroudImage:[UIImage imageNamed:@"running_go_an.png"]];
    [self.endRippleView setButtonFontSize:26];
    [self.endRippleView setButtonTitle:LS(@"run.model.label.complete")];
    self.endRippleView.delegate = self;
    
    [self.cancelRippleView setButtonBackgroudImage:[UIImage imageNamed:@"running_a_an"]];
    [self.cancelRippleView setButtonFontSize:14];
    [self.cancelRippleView setButtonTitle:LS(@"run.model.label.stop")];
    self.cancelRippleView.delegate = self;
    
    self.runDurationStLbl.text = LS(@"run.model.label.run.duration");
    
    NSDateFormatter *dateToStrFormatter = [[NSDateFormatter alloc] init];
    [dateToStrFormatter setDateFormat:@"HH:mm:ss"];
    self.runStartTimeLbl.text = [dateToStrFormatter stringFromDate:self.startDate];
    
    [self refreshUIWithContectState:([GBBluetoothManager sharedGBBluetoothManager].ibeaconConnectState == iBeaconConnectState_Connected) isRetrySync:self.isRetrySync];
    [self refershUIWithTime];
}

- (void)setupBluetoothStateObserve {
    @weakify(self)
    void (^statusChangeBlock)(iBeaconConnectState status) = ^(iBeaconConnectState status){
        @strongify(self)
        switch (status) {
            case iBeaconConnectState_None:
            case iBeaconConnectState_UnConnect:
            case iBeaconConnectState_Connecting:
                [self refreshUIWithContectState:NO isRetrySync:self.isRetrySync];
                break;
            case iBeaconConnectState_Connected:
                [self refreshUIWithContectState:YES isRetrySync:self.isRetrySync];
                break;
                
            default:
                break;
        }
    };
    
    //界面及时更新
    statusChangeBlock([GBBluetoothManager sharedGBBluetoothManager].ibeaconConnectState);
    
    [self.yah_KVOController observe:[GBBluetoothManager sharedGBBluetoothManager]
                            keyPath:@"ibeaconConnectState" block:^(id observer, id object, NSDictionary *change) {
                                
                                iBeaconConnectState status = [GBBluetoothManager sharedGBBluetoothManager].ibeaconConnectState;
                                statusChangeBlock(status);
                            }];
}

- (void)refreshUIWithContectState:(BOOL)hasContected isRetrySync:(BOOL)isRetrySync {
    if (hasContected) {
        self.unConnectButton.hidden = YES;
        if (isRetrySync) {
            self.runDurationStLbl.textColor = [UIColor colorWithHex:0xffae00];
            self.runDurationStLbl.text = LS(@"run.model.label.retry.sync");
            [self.endRippleView setButtonTitle:LS(@"run.model.label.sync")];
            
        } else {
            self.runDurationStLbl.textColor = [UIColor colorWithHex:0xffffff];
            self.runDurationStLbl.text = LS(@"run.model.label.run.duration");
            [self.endRippleView setButtonTitle:LS(@"run.model.label.complete")];
        }
        
        self.runDurationHourLbl.textColor = [UIColor colorWithHex:0xffffff];
        self.runDurationMinLbl.textColor = [UIColor colorWithHex:0xffffff];
        self.runDurationSecLbl.textColor = [UIColor colorWithHex:0xffffff];
        self.runDurationOnePntLbl.textColor = [UIColor colorWithHex:0xffffff];
        self.runDurationTwoPntLbl.textColor = [UIColor colorWithHex:0xffffff];
        
    } else {
        if (isRetrySync) {
            self.unConnectButton.hidden = YES;
            self.runDurationStLbl.textColor = [UIColor colorWithHex:0xffae00];
            self.runDurationStLbl.text = LS(@"run.model.label.retry.sync");
            [self.endRippleView setButtonTitle:LS(@"run.model.label.sync")];
            
        } else {
            self.unConnectButton.hidden = NO;
            self.runDurationStLbl.textColor = [UIColor colorWithHex:0xffae00];
            self.runDurationStLbl.text = LS(@"run.model.label.unconnect");
            [self.endRippleView setButtonTitle:LS(@"run.model.label.complete")];
        }
        
        self.runDurationHourLbl.textColor = [UIColor colorWithHex:0x909090];
        self.runDurationMinLbl.textColor = [UIColor colorWithHex:0x909090];
        self.runDurationSecLbl.textColor = [UIColor colorWithHex:0x909090];
        self.runDurationOnePntLbl.textColor = [UIColor colorWithHex:0x909090];
        self.runDurationTwoPntLbl.textColor = [UIColor colorWithHex:0x909090];
    }
}

- (void)refershUIWithTime {
    NSDate *nowDate = [NSDate date];
    
    NSInteger duration = [nowDate timeIntervalSince1970] - [self.startDate timeIntervalSince1970];
    NSInteger hour = duration / 3600;
    NSInteger min = (duration - hour * 3600) / 60;
    NSInteger sec = (duration - hour * 3600) % 60;
    
    if (hour >= 2) {
        self.runTowHourStLbl.hidden = NO;
        self.runDurationView.hidden = YES;
    } else {
        self.runTowHourStLbl.hidden = YES;
        self.runDurationView.hidden = NO;
        
        self.runDurationHourLbl.text = [NSString stringWithFormat:@"%02d", (int) hour];
        self.runDurationMinLbl.text = [NSString stringWithFormat:@"%02d", (int) min];
        self.runDurationSecLbl.text = [NSString stringWithFormat:@"%02d", (int) sec];
    }
    
}

- (void)startRunningTimer {
    
    if (self.runningTimer) {
        [self.runningTimer invalidate];
    }
    
    CGFloat repeatTime = 1.0f;
    self.runningTimer = [NSTimer scheduledTimerWithTimeInterval:repeatTime block:^(NSTimer * _Nonnull timer) {
        [self refershUIWithTime];
        
    } repeats:YES];
    [self.runningTimer fire];
}

- (void)cancelRunningTimer {
    
    [self.runningTimer invalidate];
}

@end
