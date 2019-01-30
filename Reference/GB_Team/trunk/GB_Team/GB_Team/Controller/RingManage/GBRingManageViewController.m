//
//  GBRingManageViewController.m
//  GB_Team
//
//  Created by Pizza on 16/9/20.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBRingManageViewController.h"
#import "GBHomePageViewController.h"
#import "GBRingCell.h"
#import "GBScanQRView.h"
#import "GBRingHardUpdateViewController.h"
#import <pop/POP.h>
#import "GBAlertView.h"
#import "MJRefresh.h"

#import "SystemRequest.h"

@interface WristbandInfo (battery)

@property (nonatomic, assign) RING_STATE ringState;

@end

static char kRING_STATE;
@implementation WristbandInfo (battery)

- (void)setRingState:(RING_STATE)ringState {
    
    objc_setAssociatedObject(self, &kRING_STATE, @(ringState), OBJC_ASSOCIATION_RETAIN);
}

- (RING_STATE)ringState {
    
    NSNumber *state = objc_getAssociatedObject(self, &kRING_STATE);
    return [state integerValue];
}

@end

@interface GBRingManageViewController ()<UITableViewDataSource,
UITableViewDataSource,
UITextFieldDelegate,
GBRingCellDelegate>
// 表格
@property (weak, nonatomic) IBOutlet UITableView *tableView;
// 手环序列号输入框
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
// 绑定按钮
@property (weak, nonatomic) IBOutlet GBHightLightButton *bindButton;
// 相机
@property (weak, nonatomic) IBOutlet GBScanQRView *cameraView;
// 固件更新按钮
@property (strong, nonatomic) UIButton *updateButton;
// 解绑按钮
@property (strong, nonatomic) UIButton *unbindButton;
// 解绑编辑状态
@property (nonatomic, assign) BOOL isEdit;
//手环列表
@property (nonatomic,strong) NSMutableArray<WristbandInfo *> *wristbandList;
// 记录选择状态
@property (nonatomic,strong) NSMutableArray<NSNumber *> *selectArray;
// 确认解绑右弹出窗口
@property (strong, nonatomic) IBOutlet UIView *popBox;
// 弹出框按钮
@property (strong, nonatomic) IBOutlet GBHightLightButton *popBoxButton;
// 当前扫到的手环号
@property (weak, nonatomic) IBOutlet UILabel *ringNumberLabel;
// 删除叉标志
@property (weak, nonatomic) IBOutlet UIImageView *deleteImgaeView;
// 一键检测
@property (weak, nonatomic) IBOutlet UIButton *oneKeyCheckButton;

//正在寻找的手环
@property (nonatomic, strong) WristbandInfo *searchingWristbandInfo;

@end

@implementation GBRingManageViewController

- (void)dealloc {
    
    [_cameraView cleanData];
    [[GBMultiBleManager sharedMultiBleManager] resetMultiBleManager];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.cameraView startCameraScan];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if ([self.navigationController.topViewController isMemberOfClass:[GBHomePageViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

#pragma mark - Action

// 点击按下右侧弹框确认解绑按钮
- (IBAction)actionPopBoxUnbindPress:(id)sender {
    
    @weakify(self)
    [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        @strongify(self)
        
        if (buttonIndex == 1) {
            NSArray *deleteList = [self getWillDeleteWristbandList];
            
            [self showLoadingToast];
            NSMutableArray *deleteIds = [NSMutableArray arrayWithCapacity:1];
            for (WristbandInfo *info in deleteList) {
                [deleteIds addObject:@(info.wristId).stringValue];
            }
            @weakify(self)
            [SystemRequest unbindWristband:[deleteIds copy] handler:^(id result, NSError *error) {
                @strongify(self)
                [self dismissToast];
                if (error) {
                    [self showToastWithText:error.domain];
                }else {
                    
                    [self.unbindButton setTitle:LS(@"解绑") forState:UIControlStateNormal];
                    [self.unbindButton setTitle:LS(@"解绑") forState:UIControlStateHighlighted];
                    [self.unbindButton setTitleColor:[ColorManager styleColor] forState:UIControlStateNormal];
                    self.updateButton.hidden = NO;
                    self.isEdit = NO;
                    [self hidePopBox];
                    [self.wristbandList removeObjectsInArray:deleteList];
                    self.isShowEmptyView = self.wristbandList.count == 0;
                    [self checkOneKeyButtonValid];
                    [self.tableView reloadData];
                    
                    for (WristbandInfo *info in deleteList) {
                        if (self.searchingWristbandInfo == info) {
                            self.searchingWristbandInfo = nil;
                        }
                    }
                }
            }];
        }
    } title:LS(@"温馨提示") message:LS(@"您确定要解除绑定的手环吗？") cancelButtonName:LS(@"取消") otherButtonTitle:LS(@"确定")];
}

// 点击导航栏上的升级固件按钮
-(void)actionUpdatePress {
    
    [self.navigationController pushViewController:[[GBRingHardUpdateViewController alloc] initWithWristList:self.wristbandList] animated:YES];
}

// 点击导航栏上的解绑按钮
-(void)actionUnbindPress {
    
    self.popBoxButton.enabled = NO;
    if (self.isEdit == NO) {
        self.selectArray = [NSMutableArray arrayWithCapacity:self.wristbandList.count];
        for (NSInteger index=0; index<self.wristbandList.count; index++) {
            [self.selectArray addObject:@(0)];
        }
        [self.unbindButton setTitle:LS(@"取消") forState:UIControlStateNormal];
        [self.unbindButton setTitle:LS(@"取消") forState:UIControlStateHighlighted];
        [self.unbindButton setTitleColor:[ColorManager textColor] forState:UIControlStateNormal];
        self.updateButton.hidden = YES;
        self.isEdit = YES;
        [self showPopBox];
    }else {
        [self.selectArray removeAllObjects];
        
        [self.unbindButton setTitle:LS(@"解绑") forState:UIControlStateNormal];
        [self.unbindButton setTitle:LS(@"解绑") forState:UIControlStateHighlighted];
        [self.unbindButton setTitleColor:[ColorManager styleColor] forState:UIControlStateNormal];
        self.updateButton.hidden = NO;
        self.isEdit = NO;
        [self hidePopBox];
    }
    [self.tableView reloadData];
}
// 点击了绑定按钮
- (IBAction)actionBindPress:(id)sender {
    
    if ([NSString stringIsNullOrEmpty:self.numberTextField.text]) { //
        return;
    }
    
    [self showLoadingToast];
    self.bindButton.enabled = NO;
    self.cameraView.isStart = NO;
    @weakify(self)
    [SystemRequest bindWristband:[self.numberTextField.text trimWhitespace] handler:^(id result, NSError *error) {
        
        @strongify(self)
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
            self.bindButton.enabled = YES;
        }else {
            self.numberTextField.text = @"";
            self.cameraView.isStart = YES;
            [self.tableView.mj_header beginRefreshing];
        }
    }];
}

// 点击了一键检测电量按钮
- (IBAction)actionOneKeyCheckPress:(id)sender {
    
    for (WristbandInfo *info in self.wristbandList) {
        [self readBatteryWithWristInfo:info];
    }
}

//输入框删除
- (IBAction)actionDelete:(id)sender {
    
    self.numberTextField.text = @"";
    [self checkInputValid];
}

#pragma mark - Private
#pragma mark  UI

- (void)setupUI {
    
    self.title = LS(@"手环管理");
    [self setupTableView];
    [self setupRightButton];
    [self setupBackButtonWithBlock:nil];
    [self setupCarmare];
    [self setupNoticeAndDelegate];
    
    self.oneKeyCheckButton.hidden = YES;
}

- (void)setupRightButton {
    
    self.updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.updateButton setSize:CGSizeMake(96,44)];
    [self.updateButton.titleLabel setFont:[UIFont systemFontOfSize:20.f]];
    [self.updateButton setTitle:LS(@"更新固件") forState:UIControlStateNormal];
    [self.updateButton setTitle:LS(@"更新固件") forState:UIControlStateHighlighted];
    [self.updateButton setTitleColor:[ColorManager styleColor] forState:UIControlStateNormal];
    [self.updateButton setTitleColor:[UIColor colorWithHex:0x909090] forState:UIControlStateDisabled];
    self.updateButton.backgroundColor = [UIColor clearColor];
    [self.updateButton addTarget:self action:@selector(actionUpdatePress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonUpdate = [[UIBarButtonItem alloc] initWithCustomView:self.updateButton];
    
    self.unbindButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.unbindButton setSize:CGSizeMake(48,44)];
    [self.unbindButton.titleLabel setFont:[UIFont systemFontOfSize:20.f]];
    [self.unbindButton setTitle:LS(@"解绑") forState:UIControlStateNormal];
    [self.unbindButton setTitle:LS(@"解绑") forState:UIControlStateHighlighted];
    [self.unbindButton setTitleColor:[ColorManager styleColor] forState:UIControlStateNormal];
    [self.unbindButton setTitleColor:[UIColor colorWithHex:0x909090] forState:UIControlStateDisabled];
    self.unbindButton.backgroundColor = [UIColor clearColor];
    [self.unbindButton addTarget:self action:@selector(actionUnbindPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonUnbind = [[UIBarButtonItem alloc] initWithCustomView:self.unbindButton];
    
    UIButton *placeholderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [placeholderButton setSize:CGSizeMake(48,44)];
    placeholderButton.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *placeButton = [[UIBarButtonItem alloc] initWithCustomView:placeholderButton];
    UIButton *placeholderButtonMid = [UIButton buttonWithType:UIButtonTypeCustom];
    [placeholderButtonMid setSize:CGSizeMake(48,44)];
    placeholderButtonMid.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *placeButtonMid = [[UIBarButtonItem alloc] initWithCustomView:placeholderButtonMid];
    [self.navigationItem setRightBarButtonItems:@[placeButton,buttonUnbind,placeButtonMid,buttonUpdate]];
}

- (void)setupTableView {
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"GBRingCell" bundle:nil] forCellReuseIdentifier:@"GBRingCell"];
    
    self.emptyScrollView = self.tableView;
    
    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self getFirstRecordList];
    }];
    mj_header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.tableView.mj_header = mj_header;
}

- (void)setupCarmare {
    
    @weakify(self)
    self.cameraView.selectedHandler = ^(NSString *item){
        
        @strongify(self)
        self.ringNumberLabel.text = item;
        self.numberTextField.text = item;
        self.bindButton.enabled = YES;
        [self checkInputValid];
    };
}

#pragma mark Logic

- (void)getFirstRecordList {
    
    @weakify(self)
    [SystemRequest getBindWristbandListWithHandler:^(id result, NSError *error) {
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        if (error) {
            [self showToastWithText:error.domain];
            [self.tableView reloadData];
        }else {
            if (self.wristbandList.count>0) {
                for (WristbandInfo *newInfo in result) {
                    newInfo.ringState = STATE_NOMAL;
                    for (WristbandInfo *oldInfo in self.wristbandList) {
                        if ([newInfo.mac isEqualToString:oldInfo.mac]) {
                            newInfo.battery = oldInfo.battery;
                            newInfo.ringState = oldInfo.ringState;
                            break;
                        }
                    }
                }
            }
            self.wristbandList = [NSMutableArray arrayWithArray:result];
            self.isShowEmptyView = self.wristbandList.count==0;
            [self checkOneKeyButtonValid];
            [self.tableView reloadData];
        }
    }];
}

// 打开右侧弹出框
- (void)showPopBox {
    
    self.oneKeyCheckButton.hidden = YES;
    
    self.popBox.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 64, 418, 702);
    [self.view addSubview:self.popBox];
    POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionAnimation.duration = 0.5f;
    positionAnimation.fromValue = @([UIScreen mainScreen].bounds.size.width);
    positionAnimation.toValue   = @([UIScreen mainScreen].bounds.size.width-418/2);
    [self.popBox.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    @weakify(self)
    positionAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){if (finished)
    {
        @strongify(self)
        [self.popBox.layer pop_removeAnimationForKey:@"positionAnimation"];
    }};
}

// 收起右侧弹出框
- (void)hidePopBox {
    
    self.oneKeyCheckButton.hidden = NO;
    
    POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionAnimation.duration    = 0.5f;
    positionAnimation.fromValue   = @([UIScreen mainScreen].bounds.size.width-418/2);
    positionAnimation.toValue     = @([UIScreen mainScreen].bounds.size.width+418/2);
    [self.popBox.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    @weakify(self)
    positionAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
        @strongify(self)
        if (finished){
            [self.popBox.layer pop_removeAnimationForKey:@"positionAnimation"];
            [self.popBox removeFromSuperview];
        }};
}

- (NSArray *)getWillDeleteWristbandList {
    
    NSMutableArray *deleteList = [NSMutableArray arrayWithCapacity:1];
    for(NSInteger index=0; index<self.wristbandList.count; index++) {
        NSNumber *selectNumber = self.selectArray[index];
        if (selectNumber.integerValue == 1) {
            [deleteList addObject:self.wristbandList[index]];
        }
    }
    
    return [deleteList copy];
}

- (void)checkOneKeyButtonValid {
    
    if (self.isEdit) {
        self.oneKeyCheckButton.enabled = NO;
    }else {
        self.oneKeyCheckButton.hidden = !(self.wristbandList.count>0);
        BOOL isvalid = NO;
        for (WristbandInfo *info in self.wristbandList) {
            if (info.ringState == STATE_NOMAL ||
                info.ringState == STATE_FAIL_RETRY) {
                    isvalid = YES;
                    break;
            }
        }
        self.oneKeyCheckButton.enabled = isvalid;
    }
}

- (void)checkInputValid {
    
    NSString *number = [self.numberTextField.text stringByTrimmingCharactersInSet:
                        [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.bindButton.enabled = number.length ==14;
    self.deleteImgaeView.hidden = !(self.numberTextField.text.length>0);
    if (self.numberTextField.text.length == 0) {
        self.cameraView.isStart = YES;
    }
}

- (void)readBatteryWithWristInfo:(WristbandInfo *)info {
    
    if (info.ringState == STATE_SHOW_BATTERY ||
        info.ringState == STATE_GETTING) {
        return;
    }
    
    info.ringState = STATE_GETTING;
    @weakify(self)
    [[GBMultiBleManager sharedMultiBleManager] readBatteryWithMac:info.mac handler:^(NSInteger battery, NSError *error) {
        
        @strongify(self)
        if (error) {
            info.ringState = STATE_FAIL_RETRY;
            //[self showToastWithText:error.domain];
        }else {
            info.battery = battery;
            info.ringState = STATE_SHOW_BATTERY;
        }
        [self checkOneKeyButtonValid];
        [self.tableView reloadData];
    }];
    [self checkOneKeyButtonValid];
    [self.tableView reloadData];
}

#pragma mark - Setters And Getters

- (void)setIsShowEmptyView:(BOOL)isShowEmptyView {
    
    [super setIsShowEmptyView:isShowEmptyView];
    self.updateButton.enabled = !self.isShowEmptyView;
    self.unbindButton.enabled = !self.isShowEmptyView;
}

#pragma mark - Table Delegate

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.wristbandList.count;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WristbandInfo *info = self.wristbandList[indexPath.row];
    
    GBRingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBRingCell"];
    cell.delegate = self;
    cell.ringNameLabel.text = info.name;
    cell.ringNumberLabel.text = info.number;
    if (self.isEdit == NO) {
        cell.batteryInt = info.battery;
        cell.selectState = info.ringState;
    }else {
        if ([self.selectArray[indexPath.row] isEqual:@(0)]) {
            [cell setSelectState:STATE_UNSELECT];
        }else {
            [cell setSelectState:STATE_SELECTED];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.selectArray.count == 0) {
        return;
    }
    self.selectArray[indexPath.row] = [self.selectArray[indexPath.row]  isEqual: @(0)] ? @(1):@(0);
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    NSArray *deleteList = [self getWillDeleteWristbandList];
    self.popBoxButton.enabled = deleteList.count>0;
}

#pragma mark - TextField Notice && Delegate
- (void)textFieldTextDidChange:(NSNotification *)notification{
    [self checkInputValid];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self checkInputValid];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self checkInputValid];
}

// 设置代理和通知
-(void)setupNoticeAndDelegate
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    self.numberTextField.delegate = self;
}

#pragma mark - RingCell Delegate

- (void)GBRingCell:(GBRingCell *)cell didPressGetBatteryWithState:(RING_STATE)state {
    
    GBLog(@"点击了电量检测按钮");
    WristbandInfo *info = self.wristbandList[[self.tableView indexPathForCell:cell].row];
    [self readBatteryWithWristInfo:info];
}

- (void)GBRingCell:(GBRingCell *)cell didDoubleTapsWithState:(RING_STATE)state {
    
    GBLog(@"双击了单元格");
    if (self.searchingWristbandInfo) {//等待上个手环巡检完毕
        [self showToastWithText:LS(@"正在寻找手环，请稍候")];
        return;
    }
    WristbandInfo *info = self.wristbandList[[self.tableView indexPathForCell:cell].row];
    if (!info) {
        return;
    }
    
    self.searchingWristbandInfo = info;
    @weakify(self)
    [[GBMultiBleManager sharedMultiBleManager] findDevice:info.mac findState:BleFindState_Find handler:^(NSError *error) {
        
        @strongify(self)
        self.searchingWristbandInfo = nil;
//        if (error) {
//            [self showToastWithText:error.domain];
//        }
    }];
}

@end
