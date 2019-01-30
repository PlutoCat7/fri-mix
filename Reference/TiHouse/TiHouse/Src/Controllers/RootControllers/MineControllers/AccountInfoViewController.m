//
//  AccountInfoViewController.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AccountInfoViewController.h"
#import "AccountInfoTableViewCell.h"
#import "ChangePasswordViewController.h"
#import "MineTableFooter.h"
#import "BindNewPhoneController.h"
#import "Login.h"
#define kLoginUserDict @"user_dict"

@interface AccountInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *UIModels;
@property (nonatomic, strong) User *user;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *bindingPath;
@property (nonatomic, assign) NSNumber *bindType;

@end

@implementation AccountInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"账号信息";
    _user = [Login curLoginUser];
    self.UIModels = [UIHelp getAccountInfoUI];
    [self tableView];
    [self addObserverForEditMobile];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetWXXode:) name:@"GETWXCode2" object:nil];
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
        _tableView.scrollEnabled = NO;
        [self.view addSubview:_tableView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    
    static NSString *cellId = @"cellId";
    AccountInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[AccountInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.titleLabel.text = [_UIModels[indexPath.section][indexPath.row] Title];
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.subLabel.text = [NSString stringWithFormat:@"%@****%@",[[[Login curLoginUser] mobile] substringToIndex:3], [[[Login curLoginUser] mobile] substringFromIndex:7]];
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        cell.subLabel.text = [[[Login curLoginUser] password] length] == 0 ? @"未设置": @"已设置";
    }
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0: {
                cell.subLabel.text = _user.openidwechat.length == 0 ? @"未绑定": @"已绑定";
                cell.subLabel.textColor = _user.openidwechat.length == 0 ? kColor999 : kColorBrandGreen;
            }
                break;
            case 1: {
                cell.subLabel.text = _user.openidweibo.length == 0 ? @"未绑定": @"已绑定";
                cell.subLabel.textColor = _user.openidweibo.length == 0 ? kColor999 : kColorBrandGreen;
            }
                break;
            default: {
                cell.subLabel.text = _user.openidqq.length == 0 ? @"未绑定": @"已绑定";
                cell.subLabel.textColor = _user.openidqq.length == 0 ? kColor999 : kColorBrandGreen;
            }
                break;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 1) {
        [self.navigationController pushViewController:[ChangePasswordViewController new] animated:YES];
    } else if (indexPath.section == 0 && indexPath.row == 0) {
        WEAKSELF
        [self showAlerts:^{
            [weakSelf.navigationController pushViewController:[BindNewPhoneController new] animated:YES];
        }];
    } else {
        [self toggleBindingStatus:indexPath.row];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return [[MineTableFooter alloc] initWithFrame:CGRectMake(0, 0, 0, 50) title:@"设置以后，可以使用手机号码+密码登陆有数啦"];
    }
    return [[MineTableFooter alloc] initWithFrame:CGRectMake(0, 0, 0, 50) title:@"绑定以后，可以使用绑定账号登陆有数啦"];
}

#pragma mark - private method
- (void)showAlerts:(void(^)(void))completion {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否要更换手机号" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *clearAction = [UIAlertAction actionWithTitle:@"更换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completion();
    }];
    [clearAction setValue:XWColorFromHex(0x5186aa) forKey:@"_titleTextColor"];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [cancelAction setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
    
    [alertController addAction:clearAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)addObserverForEditMobile {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAfterEdit) name:editMobileSuccessNotification object:nil];
}

- (void)reloadAfterEdit {
    [_tableView reloadData];
}

- (void)toggleBindingStatus:(NSInteger)type {

    
    switch (type) {
        case 0: {
            _bindType = @1;
            if (_user.openidwechat.length == 0) {
                [self bindingWechat];
                _path = @"/api/inter/user/bindWechat";
            } else {
                [self unBinding:[self thirdArray][type]];
                _path = @"/api/inter/user/bindcancel";
            }
        }
            break;
        case 1: {
            _bindType = @3;
            if (_user.openidweibo.length == 0) {
                [self bindingWeibo];
                _path = @"/api/inter/user/bindWeibo";
            } else {
                [self unBinding:[self thirdArray][type]];
                _path = @"/api/inter/user/bindcancel";
            }
        }
            break;
        case  2: {
            _bindType = @2;
            if (_user.openidqq.length == 0) {
                [self bindingQQ];
                _path = @"/api/inter/user/bindQq";
            } else {
                [self unBinding:[self thirdArray][type]];
                _path = @"/api/inter/user/bindcancel";
            }
        }
            break;
        default:
            break;
    }
}

- (void)unBinding:(NSString *)type {
    [self alertWithType:type isCancel:YES];
}

- (void)bindingWechat {
    _bindingPath = @"/api/inter/user/bindWechat";
    [self alertWithType:@"微信" isCancel:NO];
}

- (void)bindingWeibo {
    _bindingPath = @"/api/inter/user/bindWeibo";
    [self alertWithType:@"微博" isCancel:NO];
}

- (void)bindingQQ {
    _bindingPath = @"/api/inter/user/bindQq";
    [self alertWithType:@"QQ" isCancel:NO];
}

- (void)alertWithType:(NSString *)type isCancel:(BOOL)cancel {
    NSString *title;
    if (cancel) {
        title = [NSString stringWithFormat:@"确认解除绑定%@?", type];
    } else {
        title = [NSString stringWithFormat:@"确认绑定%@?", type];
    }
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        if (cancel) {
            
            NSNumber *uid = @([Login curLoginUserID]);
            [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:_path withParams:@{@"uid": uid, @"bindtype": _bindType }  withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
                if ([data[@"is"] intValue]) {
                    switch ([_bindType intValue]) {
                        case 1:
                            _user.openidwechat = @"";
                            break;
                        case 2:
                            _user.openidqq = @"";
                            break;
                        case 3:
                            _user.openidweibo = @"";
                            break;
                        default:
                            break;
                    }
                    [_tableView reloadData];
                    [self reloadUserInfo];
                } else {
                    [NSObject showHudTipStr:data[@"msg"]];
                }
            }];
        } else if ([type isEqualToString:@"微信"]) {
            [self sendAuthRequest];
        } else if ([type isEqualToString:@"微博"]) {
            [self getUserInfoForPlatform:UMSocialPlatformType_Sina];
        } else if ([type isEqualToString:@"QQ"]){
            [self getUserInfoForPlatform:UMSocialPlatformType_QQ];
        }
        
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:sureAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)sendAuthRequest
{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init ];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //    req.openID = @"wx80adb0396c4f846d";
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

-(void)GetWXXode:(NSNotification *)notification{
    NSDictionary *dic = notification.userInfo;
    NSNumber *uid = @([Login curLoginUserID]);
    [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:_bindingPath withParams:@{@"uid": uid, @"code": dic[@"code"]} withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        if ([data[@"is"] integerValue]) {
            _user.openidwechat = data[@"data"][@"openidwechat"];
            [self reloadUserInfo];
            [_tableView reloadData];
        } else {
            [NSObject showHudTipStr:data[@"msg"]];
        }
    }];
}

- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType {
    NSNumber *uid = @([Login curLoginUserID]);

    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
        
        if (error) {
            [NSObject showHudTipStr:@"绑定失败"];
        }else{
            UMSocialUserInfoResponse *resp = result;
            // 授权数据
            [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:_bindingPath withParams:@{@"uid": uid, @"access_token": resp.accessToken} withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
                if ([data[@"is"] integerValue]) {
                    if (platformType == UMSocialPlatformType_Sina) {
                        _user.openidweibo = data[@"data"][@"openidweibo"];
                        [_tableView reloadData];
                        [self reloadUserInfo];
                    } else {
                        _user.openidqq = data[@"data"][@"openidqq"];
                        [_tableView reloadData];
                        [self reloadUserInfo];
                    }
                } else {
                    [NSObject showHudTipStr:data[@"msg"]];
                }
            }];
        }
    }];
}

- (void)reloadUserInfo {
    NSDictionary *loginData = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginUserDict];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:loginData];
    dic[@"openidqq"] = _user.openidqq;
    dic[@"openidwechat"] = _user.openidwechat;
    dic[@"openidweibo"] = _user.openidweibo;
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:kLoginUserDict];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)thirdArray {
    return @[@"微信", @"微博", @"QQ"];
}


@end
