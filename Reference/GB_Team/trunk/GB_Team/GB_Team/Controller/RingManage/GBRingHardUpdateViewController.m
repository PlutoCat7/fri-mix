//
//  GBRingHardUpdateViewController.m
//  GB_Team
//
//  Created by Pizza on 16/9/20.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBRingHardUpdateViewController.h"
#import "GBUpdateCell.h"
#import "GBAlertView.h"

#import "SystemRequest.h"
#import "YAHDownloadManager.h"

@interface FirewareUpdateObject : NSObject

@property (nonatomic, copy) NSString *mac;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) UPDATE_STATE updateState;
@property (nonatomic, copy) NSURL *firewareFilePath;
@property (nonatomic, assign) iBeaconVersion ibeaconVersion;

@end

@implementation FirewareUpdateObject
@end

@interface GBRingHardUpdateViewController ()<
UITableViewDataSource,
UITableViewDataSource,
GBUpdateCellDelegate>
// 表格
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<FirewareUpdateObject *> *wristList;

@property (nonatomic, strong) NSMutableArray<FirewareUpdateObject *> *updateTaskList;
@property (nonatomic, strong) FirewareUpdateObject *currentTask;

@end

@implementation GBRingHardUpdateViewController

- (void)dealloc{
    
    //[[BluetoothManager sharedBluetoothManager] overUpdateMode];
}

- (instancetype)initWithWristList:(NSArray<WristbandInfo *> *)wristList {
    
    if(self=[super init]) {
        
        NSMutableArray *list = [NSMutableArray arrayWithCapacity:wristList.count];
        for (WristbandInfo *info in wristList) {
            FirewareUpdateObject *fireUpdateInfo = [[FirewareUpdateObject alloc] init];
            fireUpdateInfo.name = info.name;
            fireUpdateInfo.mac = info.mac;
            fireUpdateInfo.updateState = STATE_INIT;
            [list addObject:fireUpdateInfo];
        }
        _wristList = [list copy];
        _updateTaskList = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //[[BluetoothManager sharedBluetoothManager] overUpdateMode];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

#pragma mark - Action

//一键升级
- (void)actionUpdate {
    
    for (NSInteger index=0; index<self.wristList.count; index++) {
        [self checkNeedUpdateFirewareWithIndex:index];
    }
}

#pragma mark - Private

- (void)setupUI {
    
    self.title = LS(@"固件升级");
    [self setupTableView];
    [self setupBackButtonWithBlock:nil];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setSize:CGSizeMake(96,44)];
    [button.titleLabel setFont:[UIFont systemFontOfSize:20.f]];
    [button setTitle:LS(@"一键升级") forState:UIControlStateNormal];
    [button setTitleColor:[ColorManager styleColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(actionUpdate) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonUpdate = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonUpdate;
}

- (void)setupTableView {
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"GBUpdateCell" bundle:nil] forCellReuseIdentifier:@"GBUpdateCell"];
}

#pragma mark - Delegate

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.wristList.count;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FirewareUpdateObject *object = self.wristList[indexPath.row];
    
    GBUpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBUpdateCell"];
    cell.delegate = self;
    cell.ringNameLabel.text = object.name;
    cell.slider.value = object.progress;
    cell.state = object.updateState;
    
    return cell;
}

#pragma mark GBUpdateCellDelegate

- (void)didPressCheckUpdateButtonWithGBUpdateCell:(GBUpdateCell *)cell {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self checkNeedUpdateFirewareWithIndex:indexPath.row];
}

- (void)didPressRetryUpdateButtonWithGBUpdateCell:(GBUpdateCell *)cell {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self checkNeedUpdateFirewareWithIndex:indexPath.row];
}

//检查是否需要更新固件
- (void)checkNeedUpdateFirewareWithIndex:(NSInteger)index {
    
    FirewareUpdateObject *object = self.wristList[index];
    if (object.updateState != STATE_INIT &&
        object.updateState != STATE_FAIL) {
        return;
    }
    object.updateState = STATE_WAITING;
    [self.tableView reloadData];
    
    if (![self.updateTaskList containsObject:object]) {
        [self.updateTaskList addObject:object];
    }

    //[self startUpdateTask];
    
    
}

- (void)startUpdateTask {
   /*
    if (self.currentTask || self.updateTaskList.count==0) {
        return;
    }
    self.currentTask = self.updateTaskList.firstObject;
    FirewareUpdateObject *object = self.updateTaskList.firstObject;
    [self.updateTaskList removeObjectAtIndex:0];
    @weakify(self)
    //读取固件版本、手环版本
    [[BluetoothManager sharedBluetoothManager] readFireVersionAndDeviceVersionWithMac:object.mac handler:^(NSString *fireVersion, NSString *deviceVersion, iBeaconVersion deviceVersionType, NSError *error) {
        
        @strongify(self)
        if (error) {
            [self showToastWithText:error.domain];
            object.updateState = STATE_FAIL;
            [self completeUpdateTask];
        }else {
            //检查是否需要升级
            [SystemRequest checkFirewareUpgrade:fireVersion deviceVersion:deviceVersion handler:^(id result, NSError *error) {
                if (error) {
                    [self showToastWithText:error.domain];
                    object.updateState = STATE_FAIL;
                    [self completeUpdateTask];
                }else {
                    FirewareUpdateInfo *info = result;
                    if (info.firewareUrl.length > 0) {
                        //下载所需固件
                        @weakify(self)
                        [[YAHDownloadManager shareInstance] donwloadWithUrl:info.firewareUrl complete:^(NSURL *filePath, NSError *error) {
                            @strongify(self)
                            if (error) {
                                [self showToastWithText:error.domain];
                                object.updateState = STATE_FAIL;
                                [self completeUpdateTask];
                            }else {
                                //升级固件
                                object.firewareFilePath = filePath;
                                object.ibeaconVersion = deviceVersionType;
                                [self updateFireware];
                            }
                        }];
                    }else { //已经是最新固件
                        object.updateState = STATE_NO_UPDATE;
                        [self completeUpdateTask];
                    }
                }
            }];
        }
    }];
    */
}

//更新固件
- (void)updateFireware {
    /*
    FirewareUpdateObject *object = self.currentTask;
    if (!object) {
        [self completeUpdateTask];
        return;
    }
    object.progress = 0;
    object.updateState = STATE_UPDATING;
    GBUpdateCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.wristList indexOfObject:object] inSection:0]];
    @weakify(self)
    @weakify(cell)
    [[BluetoothManager sharedBluetoothManager] updateFirewareWithMac:object.mac deviceVersionType:object.ibeaconVersion filePath:object.firewareFilePath complete:^(NSError *error) {
        
        @strongify(self)
        if (error) {
            object.updateState = STATE_FAIL;
        }else {
            object.updateState = STATE_FINISHED;
        }
        
        [self completeUpdateTask];
    } progressBlock:^(CGFloat progress) {
        
        @strongify(cell)
        object.progress = progress;
        
        cell.slider.value = object.progress;
        cell.state = object.updateState;
    }];
     */
}

- (void)completeUpdateTask {
    
    self.currentTask = nil;
    //[self startUpdateTask];
    
    [self.tableView reloadData];
}

@end
