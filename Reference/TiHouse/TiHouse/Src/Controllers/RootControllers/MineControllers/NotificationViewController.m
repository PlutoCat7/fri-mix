//
//  NotificationViewController.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "NotificationViewController.h"
#import "MineTableFooter.h"
#import "NotificationTableViewCell.h"
#import "HouseNewsViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "Login.h"

@interface NotificationViewController ()<UITableViewDelegate, UITableViewDataSource, NotificationDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *UIModels;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息通知";
    [self tableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.UIModels = [UIHelp getNotificationUI];
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
    return [self.UIModels count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.UIModels[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId;
    if (indexPath.section == 0) {
        cellId = @"openNotificationCellId";
    } else if (!(indexPath.section == 1 && indexPath.row == 0)) {
        cellId = @"switchCellId";
    } else {
        cellId = @"cellId";
    }
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[NotificationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.titleLabel.text = [self.UIModels[indexPath.section][indexPath.row] Title];
    if (indexPath.section == 0) {
        cell.subLabel.text = [self notificationStatus] ?  @"已开启": @"未开启";
    }
    User *user = [Login curLoginUser];
    if (indexPath.section == 1 && indexPath.row == 1) {
        cell.switchControl.on = user.userisreceiinte;
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        cell.switchControl.on = user.userisvoice;
    }
    if (indexPath.section == 2 && indexPath.row == 1) {
        cell.switchControl.on = user.userisshake;
    }
    if (indexPath.section == 3) {
        cell.switchControl.on = user.userisreceiknow;
    }
    
    if ([cell.reuseIdentifier isEqualToString:@"switchCellId"]) {
        cell.delegate = self;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 70;
    } else if (section == 2) {
        return 40;
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return [[MineTableFooter alloc] initWithFrame:CGRectMake(0, 0, 0, 50) title:@"如果您要开启或关闭有数啦的消息通知，请在iPhone\n的“设置”-“通知”-“有数啦”中进行更改"];
    } else if (section == 1) {
        return [[MineTableFooter alloc] initWithFrame:CGRectMake(0, 0, 0, 50) title:@"关闭后，相应模块有新消息时，将不再发送系统通知。"];
    } else if (section == 3) {
        return [[MineTableFooter alloc] initWithFrame:CGRectMake(0, 0, 0, 50) title:@"关闭后，相应模块有新内容时，将不再出现红点提示"];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self.navigationController pushViewController:[HouseNewsViewController new] animated:YES];
    } else if (indexPath.section == 0) {
        NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingURL];
    }
}

#pragma mark - NotificationDelegate
- (void)modifyNotificationStatus:(BOOL)b title:(NSString *)title{
    User *user = [Login curLoginUser];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *loginData = [defaults objectForKey:@"user_dict"];
    NSMutableDictionary *newLoginData = [NSMutableDictionary dictionaryWithDictionary:loginData];
    if ([title isEqualToString:@"互动消息"]) {
        
        if (b) {
            [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/user/editIsreceiinteOpen" withParams:@{@"uid": @(user.uid)} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
                if ([data[@"is"] intValue]) {
                    user.userisreceiinte = 1;
                    newLoginData[@"userisreceiinte"] = @1;
                }
            }];
        } else {
            [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/user/editIsreceiinteClose" withParams:@{@"uid": @(user.uid)} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
                if ([data[@"is"] intValue]) {
                    user.userisreceiinte = 0;
                    newLoginData[@"userisreceiinte"] = @0;
                }
            }];

        }
        
    } else if ([title isEqualToString:@"声音提醒"]){
        if (b) {
            [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/user/editIsvoiceOpen" withParams:@{@"uid": @(user.uid)} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
                if ([data[@"is"] intValue]) {
                    user.userisvoice = 1;
                    newLoginData[@"userisvoice"] = @1;
                }
            }];

        } else {
            [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/user/editIsvoiceClose" withParams:@{@"uid": @(user.uid)} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
                if ([data[@"is"] intValue]) {
                    user.userisvoice = 0;
                    newLoginData[@"userisvoice"] = @0;
                }
            }];

        }
    } else if ([title isEqualToString:@"振动提醒"]) {
        if (b) {
            [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/user/editIsshakeOpen" withParams:@{@"uid": @(user.uid)} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
                if ([data[@"is"] intValue]) {
                    user.userisshake = 1;
                    newLoginData[@"userisshake"] = @1;
                }
            }];
        } else {
            [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/user/editIsshakeClose" withParams:@{@"uid": @(user.uid)} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
                if ([data[@"is"] intValue]) {
                    user.userisshake = 0;
                    newLoginData[@"userisshake"] = @0;
                }
            }];

        }
    } else {
        if (b) {
            [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/user/editIsreceiknowOpen" withParams:@{@"uid": @(user.uid)} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
                if ([data[@"is"] intValue]) {
                    user.userisreceiknow = 1;
                    newLoginData[@"userisreceiknow"] = @1;
                }
            }];

        } else {
            [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/user/editIsreceiknowClose" withParams:@{@"uid": @(user.uid)} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
                if ([data[@"is"] intValue]) {
                    user.userisreceiknow = 0;
                    newLoginData[@"userisreceiknow"] = @0;
                }
            }];
        }
    }
    [defaults setObject:newLoginData forKey:@"user_dict"];
    [defaults synchronize];

}

- (BOOL)notificationStatus {
    UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        NSLog(@"current %lu", (unsigned long)settings.types);
    if (settings.types != UIUserNotificationTypeNone) {
        NSLog(@"------已开启");
        return YES;
    }
    NSLog(@"------未开启");
    return NO;
}

@end
