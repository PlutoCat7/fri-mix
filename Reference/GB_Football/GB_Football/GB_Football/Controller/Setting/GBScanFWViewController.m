//
//  GBScanFWViewController.m
//  GB_Football
//
//  Created by weilai on 16/8/29.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBScanFWViewController.h"
#import "GBScanTableViewCell.h"
#import "GBBluetoothManager.h"

@interface GBScanFWViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) UIActivityIndicatorView *indicator;

@property (strong, nonatomic) UIBarButtonItem *progressItem;
@property (strong, nonatomic) UIBarButtonItem *refreshItem;

@property (assign, nonatomic) BOOL scanning;
@property (strong, nonatomic) NSMutableArray<iBeaconInfo *> *tableArray;

@end

@implementation GBScanFWViewController

#pragma mark -
#pragma mark Memory

- (void)dealloc{
    
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

    self.title = LS(@"setting.label.scan");
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
}

- (void)loadData {
    
    self.tableArray = [NSMutableArray arrayWithCapacity:1];
}

- (void)startScan {
    
    [self updateRightBarButton:YES];
    
    //过滤扫描到的手环，已绑定的剔除
    @weakify(self)
    void(^filterWirstband)() = ^{
        @strongify(self)
        if (self.tableArray.count == 0) {
            return;
        }
        //按RSSI排序
        self.tableArray = [NSMutableArray arrayWithArray:[self.tableArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            iBeaconInfo *beaconObj1 = obj1;
            iBeaconInfo *beaconObj2 = obj2;
            if (beaconObj1.rssi > beaconObj2.rssi) {
                return NSOrderedAscending;
            }else if (beaconObj1.rssi < beaconObj2.rssi) {
                return NSOrderedDescending;
            }else {
                return NSOrderedSame;
            }
        }]];
        [self.tableView reloadData];
    };
    
    [[GBBluetoothManager sharedGBBluetoothManager] startScanningWithBeaconHandler:^(iBeaconInfo *foundBeacons, BOOL isStop, NSError *error) {
        
        @strongify(self)
        if (foundBeacons) {
            
            [self.tableArray addObject:foundBeacons];
            filterWirstband();
        }else if (isStop) {
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
    
    iBeaconInfo *info = self.tableArray[indexPath.section];
    cell.addrLbl.text = info.address;
    cell.nameLbl.text = info.name;
    cell.clickBlock  = ^{
        UIPasteboard *pboard = [UIPasteboard generalPasteboard];
        pboard.string = info.address;
    };
    
    [cell.bindButton setTitle:LS(@"common.copy") forState:UIControlStateNormal];

    return cell;
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

@end
