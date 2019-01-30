//
//  CommenSettingsController.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CommenSettingsController.h"
#import "CommonSettingCell.h"
#import "AccountInfoViewController.h"
#import "AboutUSViewController.h"
#import "ClearCacheViewController.h"
#import "NotificationViewController.h"
#import "Login.h"
#import "ShareViewController.h"
#import <UShareUI/UShareUI.h>
#define kLoginStatus @"login_status"

@interface CommenSettingsController ()<UITableViewDelegate, UITableViewDataSource,CommenSettingDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *UIModels;

@end

@implementation CommenSettingsController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 刷新缓存数据
    CommonSettingCell *cell = (CommonSettingCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    cell.subLabel.text = [self getSize];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"通用设置";
    self.UIModels = [UIHelp getSettingsUI];
    [self tableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.backgroundView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.scrollEnabled = NO;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(@(kNavigationBarHeight));
        }];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.UIModels count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 3 ? 1 : [self.UIModels[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId;
    if (indexPath.section == 0 || indexPath.section == 1) {
        cellId = @"normalCellId";
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        cellId = @"cacheCellId";
    } else if (indexPath.section == 2 && indexPath.row == 1) {
        cellId = @"wifiCellId";
    } else {
        cellId = @"quitCellId";
    }
    CommonSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[CommonSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (indexPath.section != 3) {
        cell.titleLabel.text = [_UIModels[indexPath.section][indexPath.row] Title];
    } else {
        cell.delegate = self;
    }
    if (indexPath.section == 2 && indexPath.row == 1) {
        cell.switchControl.on = [Login curLoginUser].useriswifi;
        [cell setSwitchBlock:^(BOOL isOn) {
            isOn ? [self onlyWifi] : [self use4G];
        }];
    }
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        cell.subLabel.text = [self getSize];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 2 ? 30 : 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self.navigationController pushViewController:[AccountInfoViewController new] animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        [self.navigationController pushViewController:[AboutUSViewController new] animated:YES];
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        [self.navigationController pushViewController:[ClearCacheViewController new] animated:YES];
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        [self.navigationController pushViewController:[NotificationViewController new] animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        ShareViewController *shareVC = [ShareViewController new];
        shareVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        shareVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:shareVC animated:YES completion:nil];
        //        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        //
        //        }];
    }
}

#pragma mark - CommenSettingDelegate
- (void)quitLogin {
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认退出登录?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *clearAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/user/logout" withParams:@{@"uid": [NSNumber numberWithLong:[[Login curLoginUser] uid]]} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
            if ([data[@"is"] intValue]) {
                [NSObject showHudTipStr:data[@"msg"]];
                [Login doLogout];
                AppDelegate *appledate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:kLoginStatus];
                [appledate setRootViewController];
            } else {
                [NSObject showHudTipStr:data[@"msg"]];
            }
        }];
        
        
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:clearAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (NSString *)getSize {
    NSUInteger tmpSize = [[SDImageCache sharedImageCache] getSize];
    NSString *cacheName;
    if (tmpSize >= 1024 * 1024 * 1024) {
        cacheName = [NSString stringWithFormat:@"%.2fG", tmpSize/(1024.f*1024.f*1024.f)];
    } else if (tmpSize >= 1024 * 1024) {
        cacheName = [NSString stringWithFormat:@"%.2fM", tmpSize/(1024.f*1024.f)];
    } else {
        cacheName = [NSString stringWithFormat:@"%.2fK", tmpSize/1024.f];
    }
    return cacheName;
}

- (void)onlyWifi {
    [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/user/editUseriswifiToYes" withParams:@{@"uid": @([Login curLoginUserID])} withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        if ([data[@"is"] integerValue]) {
            [Login curLoginUser].useriswifi = 1;
        } else {
            [NSObject showHudTipStr:data[@"msg"]];
        }
    }];
}

- (void)use4G {
    [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/user/editUseriswifiToNo" withParams:@{@"uid": @([Login curLoginUserID])} withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        if ([data[@"is"] integerValue]) {
            [Login curLoginUser].useriswifi = 0;
        } else {
            [NSObject showHudTipStr:data[@"msg"]];
        }
    }];
}

@end
