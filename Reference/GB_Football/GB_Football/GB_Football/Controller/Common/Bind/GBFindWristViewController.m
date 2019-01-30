//
//  GBScanFWViewController.m
//  GB_Football
//
//  Created by weilai on 16/8/29.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBFindWristViewController.h"
#import "GBScanTableViewCell.h"
#import "SystemRequest.h"
#import "GBBluetoothManager.h"
#import "GBMakePairViewController.h"

@interface GBFindWristViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) UIActivityIndicatorView *indicator;

@property (strong, nonatomic) UIBarButtonItem *progressItem;
@property (strong, nonatomic) UIBarButtonItem *refreshItem;

@property (assign, nonatomic) BOOL scanning;
@property (strong, nonatomic) NSMutableArray<WristbandFilterInfo *> *tableArray;
//最新搜索到的手环列表
@property (nonatomic, strong) NSMutableArray<iBeaconInfo *> *newestFoundibeaconList;
//过滤定时器
@property (nonatomic, strong) NSTimer *filterTimer;
// 提醒条（列表以手环信号强弱排序）
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottom;
@property (strong, nonatomic) IBOutlet UIView *tipBar;
@property (weak,   nonatomic) IBOutlet UILabel *tipLabel;
@end

@implementation GBFindWristViewController

#pragma mark -
#pragma mark Memory

- (void)dealloc{
    [_filterTimer invalidate];
    [[GBBluetoothManager sharedGBBluetoothManager] stopScanning];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Action

- (void)refreshClick {
    
    [self.tableArray removeAllObjects];
    [self.tableView reloadData];
    [self startScan];
}

#pragma mark - Private


-(void)setupUI {

    self.title = LS(@"pair.button.find");
    self.tipLabel.text = LS(@"pair.tip.rssi");
    [self setupBackButtonWithBlock:^{}];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"GBScanTableViewCell" bundle:nil] forCellReuseIdentifier:@"GBScanTableViewCell"];
    
    //初始化
    self.progressItem = [[UIBarButtonItem alloc] initWithCustomView:self.indicator];
    
    // 跳过
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 50, 40);
    [menuBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [menuBtn setTitle:LS(@"common.btn.refresh") forState:UIControlStateNormal];
    menuBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [menuBtn addTarget:self action:@selector(refreshClick) forControlEvents:UIControlEventTouchUpInside];
    self.refreshItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    [self startScan];
    [self hideTipBar];
}

- (void)loadData {
    
    self.tableArray = [NSMutableArray arrayWithCapacity:1];
    self.newestFoundibeaconList = [NSMutableArray arrayWithCapacity:1];
}

- (void)startScan {
    
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        [self showToastWithText:LS(@"network.tip.error")];
        return;
    }
    
    [self updateRightBarButton:YES];
    
    //过滤扫描到的手环，已绑定的剔除
    @weakify(self)
    void(^filterWirstband)() = ^{
        @strongify(self)
        if (self.newestFoundibeaconList.count == 0) {
            return;
        }
        //需要过滤的手环列表
        NSArray *uploadList = [self.newestFoundibeaconList copy];
        
        NSMutableArray *macList = [NSMutableArray arrayWithCapacity:1];
        NSMutableDictionary *ibeaconDic = [NSMutableDictionary dictionary];
        for (iBeaconInfo *info in uploadList) {
            [macList addObject:info.address];
            [ibeaconDic setObject:info forKey:info.address];
        }
        
        @weakify(self)
        [SystemRequest wristbandListFilter:[macList copy] handler:^(id result, NSError *error) {
            
            @strongify(self)
            if (error) { //重新加入到需要过滤的列表中
                [self.newestFoundibeaconList addObjectsFromArray:uploadList];
                return;
            }
            NSArray *list = result;
            //赋值RSSI
            for (WristbandFilterInfo *info in list) {
                info.ibeacon = [ibeaconDic objectForKey:info.mac];
            }
            [self.tableArray addObjectsFromArray:list];
            //按RSSI排序
            self.tableArray = [NSMutableArray arrayWithArray:[self.tableArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                WristbandFilterInfo *beaconObj1 = obj1;
                WristbandFilterInfo *beaconObj2 = obj2;
                if (beaconObj1.ibeacon.rssi > beaconObj2.ibeacon.rssi) {
                    return NSOrderedAscending;
                }else if (beaconObj1.ibeacon.rssi < beaconObj2.ibeacon.rssi) {
                    return NSOrderedDescending;
                }else {
                    return NSOrderedSame;
                }
            }]];
            [self.tableView reloadData];
            if ([self.tableArray count] > 1)
            {
                [self showTipBar];
            }
            else
            {
                [self hideTipBar];
            }
        }];
        //清除
        [self.newestFoundibeaconList removeAllObjects];
    };
    
    [self.filterTimer invalidate];
    self.filterTimer = [NSTimer scheduledTimerWithTimeInterval:4.0f block:^(NSTimer *timer) {
        filterWirstband();
    } repeats:YES];
    
    [[GBBluetoothManager sharedGBBluetoothManager] startScanningWithBeaconHandler:^(iBeaconInfo *foundBeacons, BOOL isStop, NSError *error) {
        
        @strongify(self)
        if (foundBeacons) {
            //有效的手环
            if (foundBeacons.rssi<0) {
                [self.newestFoundibeaconList addObject:foundBeacons];
            }
        }else if (isStop) {
            filterWirstband();
            //关闭定时器
            [self.filterTimer invalidate];
            [self updateRightBarButton:NO];
        }
        
        if (error && error.code == BeanErrors_BluetoothNotOn) {
            [self showToastWithText:error.domain];
        }
    }];
}

- (void)updateRightBarButton:(BOOL)isScanning {
    
    if (self.scanning != isScanning) {
        self.scanning = isScanning;
        if (self.scanning) {
            self.navigationItem.rightBarButtonItem = self.progressItem;
            
        } else {
            self.navigationItem.rightBarButtonItem = self.refreshItem;
        }
    }
}

#pragma mark - Getters & Setters
//懒加载
- (UIActivityIndicatorView *)indicator {
    
    //判断是否已经有了，若没有，则进行实例化
    if (!_indicator) {
        
        _indicator=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        //设置显示样式,见UIActivityIndicatorViewStyle的定义
        _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        //设置显示位置
        //[indicator setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
        //开始显示Loading动画
        [_indicator startAnimating];
    }
    return _indicator;
}


#pragma mark - Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 3.f;
}

// section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableArray != nil ? [self.tableArray count] : 0;
}

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GBScanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBScanTableViewCell"];
    
    WristbandFilterInfo *info = self.tableArray[indexPath.section];
    cell.addrLbl.text = info.showNumber;
    cell.nameLbl.text = [NSString stringIsNullOrEmpty:info.handEquipName]?info.name:info.handEquipName;
    @weakify(self)
    cell.clickBlock  = ^{
        @strongify(self)
        if (self.tableArray.count==0) {
            return;
        }
        if (![[RawCacheManager sharedRawCacheManager] isBindWristband]) {
            WristbandFilterInfo *info = self.tableArray[indexPath.section];
            GBMakePairViewController *vc = [[GBMakePairViewController alloc]initWithWristbandInfo:info];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            @weakify(self)
            [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [self showLoadingToast];
                    [SystemRequest bindWristband:nil handler:^(id result, NSError *error) {
                        @strongify(self)
                        if (error) {
                            [self showToastWithText:error.domain];
                        }else {
                            [[GBBluetoothManager sharedGBBluetoothManager] disconnectBeacon];
                            [[GBBluetoothManager sharedGBBluetoothManager] resetGBBluetoothManager];
                            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_CancelBindSuccess object:nil];
                            [self showToastWithText:LS(@"setting.hint.unbind.success")];
                            [self.tableView reloadData];
                            if ([self.tableArray count] > 1)
                            {
                               [self showTipBar];
                            }
                            else
                            {
                                [self hideTipBar];
                            }
                        }
                    }];
                }
            } title:LS(@"common.popbox.title.tip") message:LS(@"setting.hint.unbind") cancelButtonName:LS(@"common.btn.cancel") otherButtonTitle:LS(@"common.btn.yes") style:GBALERT_STYLE_NOMAL];
        }
        
    };
    
    if ([NSString stringIsNullOrEmpty:info.nickName]) {
        cell.bindButton.hidden = NO;
        cell.userLbl.hidden = YES;
        
        [cell.bindButton setTitle:LS(@"pair.button.bind") forState:UIControlStateNormal];
        
    } else {
        cell.bindButton.hidden = YES;
        cell.userLbl.hidden = NO;
        
        NSString *bindHint = [NSString stringWithFormat:@"%@%@%@", LS(@"pair.label.bind.lead"), info.nickName, LS(@"pair.label.bind.tail")];
        NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:bindHint];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range = [[hintString string]rangeOfString:info.nickName];
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range];
        cell.userLbl.attributedText = hintString;
    }

    return cell;
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

-(void)hideTipBar
{
    self.tipBar.hidden = YES;
    self.tableBottom.constant = 0;
}
-(void)showTipBar
{
    self.tipBar.hidden = NO;
    self.tableBottom.constant = 40;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end
