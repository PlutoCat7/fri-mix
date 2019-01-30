//
//  AppDelegate.m
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/15.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "RootTabViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "AFNetworkActivityIndicatorManager.h"
#import "LoginViewController.h"
#import "BaseNavigationController.h"
#import "Advert.h"
#import "Login.h"
#import "RCDRCIMDataSource.h"
#import "UnReadManager.h"

#import <RongIMLib/RongIMLib.h>
#import <RongIMKit/RongIMKit.h>
#import <UMPush/UMessage.h>             // Push组件
#import <UserNotifications/UserNotifications.h>  // Push组件必须的系统库

#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>

#import "LaunchAdvertisementView.h"
#import "LaunchAdvertisementViewModel.h"
#import "AdvertisementsDetailDataModel.h"
#import "WebViewController.h"

#import "KnowledgeAdvertisementsDataModel.h"

#import "CommonDataCenter.h"

#import "NewVersionModel.h"
#import "NewVersionController.h"

#import "Reachability.h"

#define USHARE_DEMO_APPKEY @"5a4b3ce9a40fa37d0a00025c"

#define kLoginForTheFirstTime @"login_for_the_first_time"//判断是不是 第一次启动

//友盟平台
#define kUMAppKey @"5a712f708f4a9d10290000a2"
#define kUMAppChannel @"App Store"

@interface AppDelegate ()<LaunchAdvertisementViewDelegate>

@property (nonatomic, strong) LaunchAdvertisementView *adVertisementView;
@property (nonatomic, strong) LaunchAdvertisementViewModel *adVertisementViewModel;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    // 指定当前版本
    [[NSUserDefaults standardUserDefaults] setObject:@"5" forKey:@"versionno"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //网络
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [reachability startNotifier];

    //键盘弹起遮挡
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].toolbarManageBehaviour = IQAutoToolbarBySubviews;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].shouldShowToolbarPlaceholder = NO;
    
    //sd加载的数据类型zz
    [[[SDWebImageManager sharedManager] imageDownloader] setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:kUMAppKey]; 
    [self configUSharePlatforms:launchOptions];

    RCIM *im = [RCIM sharedRCIM];
    [im initWithAppKey:RY_APP_KEY];
    im.userInfoDataSource = RCDDataSource;
    
    //广告页
    [self LaunchAd];
    
  
    [self.window makeKeyAndVisible];
    
    [self checkKnowledgeAdvertisementsRequest];
    
    
    [WXApi registerApp:@"wx80adb0396c4f846d"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [NewVersionModel checkNewVersion:^(BOOL b, NewVersionModel *model) {
            if (b) {
                NewVersionController *newVersionVC = [[NewVersionController alloc] init];
                newVersionVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                newVersionVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                newVersionVC.currentModel = model;
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:newVersionVC animated:YES completion:nil];
            }
        }];
    });
    
    return YES;
}

- (void)reachabilityChanged:(NSNotification *)notification
{
    Reachability *curReachability = [notification object];
    NSParameterAssert([curReachability isKindOfClass:[Reachability class]]);
    NetworkStatus curStatus = [curReachability currentReachabilityStatus];
    if(curStatus == NotReachable) {
        NSDictionary *dic = @{@"status":@"0"};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isNotReachable" object:nil userInfo:dic];
    }else{
        NSDictionary *dic = @{@"status":@"1"};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"noNotReachable" object:nil userInfo:dic];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    if ([Login isLogin]) {
        [[UnReadManager shareManager] updateUnRead];
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)setRootViewController{
    
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:[LoginViewController new]];
    [self.window setRootViewController:nav];
}

- (void)setupTabViewController{
    
    User *user = [Login curLoginUser];
    
    //如果融云没有连接 就连接融云
    if ([[RCIM sharedRCIM] getConnectionStatus] != ConnectionStatus_Connected)
    {
        [[RCIM sharedRCIM] connectWithToken:user.rongcloudToken success:^(NSString *userId) {
            NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        } error:^(RCConnectErrorCode status) {
            NSLog(@"登陆的错误码为:%ld", (long)status);
        } tokenIncorrect:^{
            NSLog(@"token错误");
        }];
    }
    
    RootTabViewController *rootVC = [[RootTabViewController alloc] init];
    rootVC.tabBar.translucent = YES;
    [self.window setRootViewController:rootVC];
}

-(void)LaunchAd
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kLoginForTheFirstTime])//不是第一次启动，没有引导页，暂时只能这么判断 Login里面得 是直接判断如果是第一次 马上设定为非第一次
    {
        UIViewController *emptyViewController = [[UIViewController alloc] init];
        self.window.rootViewController = emptyViewController;
        
        if (![self.adVertisementView isDescendantOfView:self.window])
        {
            [self.window addSubview:self.adVertisementView];
            [self.window bringSubviewToFront:self.adVertisementView];
        }
        
        //加载图片
        [self.adVertisementView resetViewWithViewModel:self.adVertisementViewModel];
        self.adVertisementView.hidden = NO;
        WEAKSELF
        [[TiHouse_NetAPIManager sharedManager] request_AdvertisementsWithPath:@"api/outer/advert/getDetail" Params:nil Block:^(AdvertisementsDetailDataModel *data, NSError *error) {
            if (!error)
            {
                [self.window bringSubviewToFront:self.adVertisementView];
                self.adVertisementView.hidden = !data.statusshow;
                if (data.statusshow)
                {
                    [weakSelf.window bringSubviewToFront:self.adVertisementView];
                    //加载图片
                    weakSelf.adVertisementViewModel.dataModel = data;
                    weakSelf.adVertisementViewModel.adImageUrl = data.urlpicindex;
                    weakSelf.adVertisementViewModel.duration = [data.remaintime integerValue];
                    
                    [weakSelf.adVertisementView resetViewWithViewModel:self.adVertisementViewModel];
                }
                else
                {
                    [self resetRootViewController];
                }
            }
            else
            {
                weakSelf.adVertisementView.hidden = YES;
                [self resetRootViewController];
            }
        }];
    }
    else
    {
        [self resetRootViewController];
    }
}

- (void)customizeInterface {
    //设置Nav的背景色和title色
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    [navigationBarAppearance setBackgroundImage:[UIImage imageWithColor:YES? kColorNavBG: kColorActionYellow] forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setTintColor:kColorBrandGreen];//返回按钮的箭头颜色
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName: [UIFont systemFontOfSize:kNavTitleFontSize],
                                     NSForegroundColorAttributeName: kRKBNAVBLACK,
                                     };
    [navigationBarAppearance setTitleTextAttributes:textAttributes];

    [[UITextField appearance] setTintColor:kTiMainBgColor];//设置UITextField的光标颜色
    [[UITextView appearance] setTintColor:kTiMainBgColor];//设置UITextView的光标颜色
    [[UISearchBar appearance] setBackgroundImage:[UIImage imageWithColor:kColorTableSectionBg] forBarPosition:0 barMetrics:UIBarMetricsDefault];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSLog(@"===s=s=d==d==f=====%@",url);
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // 微信绑定特殊处理
    if ([url.description hasPrefix:@"wx80adb0396c4f846d"] && [self isAccountInfoBindingOperator]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    // 在第三方登录时由微信SDK处理
    if ([url.description hasPrefix:@"wx80adb0396c4f846d"] && ![Login isLogin]) return [WXApi handleOpenURL:url delegate:self];
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        result = [WXApi handleOpenURL:url delegate:self];
    }
//    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
//    if (!result) {
//        // 其他如支付等SDK的回调
//        result = [WXApi handleOpenURL:url delegate:self];
//    }
    return  result;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    // 微信绑定特殊处理
    if ([url.description hasPrefix:@"wx80adb0396c4f846d"] && [self isAccountInfoBindingOperator]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    // 在第三方登录时由微信SDK处理
    if ([url.description hasPrefix:@"wx80adb0396c4f846d"] && ![Login isLogin]) return [WXApi handleOpenURL:url delegate:self];
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    
    if (!result) {
        // 其他如支付等SDK的回调
        return [WXApi handleOpenURL:url delegate:self];
    }
    return result;
}

-(void)onResp:(BaseResp*)resp{
    /*
     enum  WXErrCode {
     WXSuccess           = 0,    成功
     WXErrCodeCommon     = -1,  普通错误类型
     WXErrCodeUserCancel = -2,    用户点击取消并返回
     WXErrCodeSentFail   = -3,   发送失败
     WXErrCodeAuthDeny   = -4,    授权失败
     WXErrCodeUnsupport  = -5,   微信不支持
     };
     */
    
    if ([resp isKindOfClass:[SendAuthResp class]]) {   //授权登录的类。
        if (resp.errCode == 0) {  //成功。
            //这里处理回调的方法 。 通过代理吧对应的登录消息传送过去。
            SendAuthResp *resp2 = (SendAuthResp *)resp;
            if ([Login isLogin]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"GETWXCode2" object:nil userInfo:@{@"code":resp2.code}];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"GETWXCode" object:nil userInfo:@{@"code":resp2.code}];
            }
        }else{ //失败
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录失败" message:[NSString stringWithFormat:@"reason : %@",resp.errStr] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil,nil];
            [alert show];
        }
    }
    
    /**
     * 分享回调
     */
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (resp.errCode == 0) {  //成功。
            //这里处理回调的方法 。 通过代理吧对应的登录消息传送过去。
            [NSObject showStatusBarSuccessStr:@"分享成功"];
        }else{ //失败
            [NSObject showStatusBarErrorStr:@"分享失败"];
        }
    }
}

#pragma mark -- 第三方配置
- (void)configUSharePlatforms:(NSDictionary *)launchOptions{
    
    //注册deviceToken
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)
    {
        //iOS10特有
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted)
            {
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    NSLog(@"%@", settings);
                }];
            } else {
            }
        }];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
    {
        //iOS8 - iOS10
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    //友盟
    [UMConfigure initWithAppkey:kUMAppKey channel:kUMAppChannel];
    
    //向微信注册
    [WXApi registerApp:@"wx80adb0396c4f846d"];
    //QQ
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"101452514"/*设置QQ平台的appID*/  appSecret:@"b860931a5db802861947410c6a9673e1" redirectURL:@"http://mobile.umeng.com/social"];
    //微博
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3682691179"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"http://wap.usure.com.cn/outer/weibo/callback"];
    //微信
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx80adb0396c4f846d"  appSecret:@"fa4d9c75829e3d81b7d3b65cb617d552" redirectURL:@"http://wap.usure.com.cn/outer/weibo/callback"];
    //微信
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatTimeLine appKey:@"wx80adb0396c4f846d"  appSecret:@"fa4d9c75829e3d81b7d3b65cb617d552" redirectURL:@"http://wap.usure.com.cn/outer/weibo/callback"];
    
    // Push组件基本功能配置
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标等
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert|UMessageAuthorizationOptionSound;
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            // 用户选择了接收Push消息
        }else{
            // 用户拒绝接收Push消息
        }
    }];
    
}
//打印友盟推送的DeviceToken
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [UMessage registerDeviceToken:deviceToken];
    XWLog(@"UmengDeviceToken-%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                   stringByReplacingOccurrencesOfString: @">" withString: @""]
                                  stringByReplacingOccurrencesOfString: @" " withString: @""]);
    
    [[NSUserDefaults standardUserDefaults] setObject:[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                                       stringByReplacingOccurrencesOfString: @">" withString: @""]
                                                      stringByReplacingOccurrencesOfString: @" " withString: @""] forKey:@"devicetoken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
}

- (LaunchAdvertisementView *)adVertisementView
{
    if (!_adVertisementView)
    {
        _adVertisementView = [[LaunchAdvertisementView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        _adVertisementView.delegate = self;
        _adVertisementView.hidden = YES;
    }
    return _adVertisementView;
}

- (LaunchAdvertisementViewModel *)adVertisementViewModel
{
    if (!_adVertisementViewModel)
    {
        _adVertisementViewModel = [[LaunchAdvertisementViewModel alloc] init];
        CGSize viewSize = [[UIScreen mainScreen] bounds].size;
        NSString *viewOrientation = @"Portrait";
        NSString *launchImageName = nil;
        NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
        for (NSDictionary* dict in imagesDict)
        {
            CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
            if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
            {
                launchImageName = dict[@"UILaunchImageName"];
                break;
            }
        }
        _adVertisementViewModel.placeHolderImageView = [UIImage imageNamed:launchImageName];
        _adVertisementViewModel.canTouch = YES;
        _adVertisementViewModel.hasDurationLabel = YES;
    }
    return _adVertisementViewModel;
}

#pragma mark LaunchAdvertisementViewDelegate
- (void)launchAdvertisementView:(LaunchAdvertisementView *)view clickDurationTimerLabelWithViewModel:(LaunchAdvertisementViewModel *)viewModel;
{
    MTWeakBlock(self);
    [UIView animateWithDuration:0.4 animations:^{
        weakself.adVertisementView.alpha = 0.0;
    } completion:^(BOOL finished) {
        weakself.adVertisementView.hidden = YES;
    }];
    
    [self resetRootViewController];
}

- (void)launchAdvertisementView:(LaunchAdvertisementView *)view clickAdImageViewWithViewModel:(LaunchAdvertisementViewModel *)viewModel;
{
    MTWeakBlock(self);
    [UIView animateWithDuration:0.4 animations:^{
        weakself.adVertisementView.alpha = 0.0;
    } completion:^(BOOL finished) {
        weakself.adVertisementView.hidden = YES;
    }];
    
    [self resetRootViewController];
    
    AdvertisementsDetailDataModel *dataModel = viewModel.dataModel;
    if (dataModel)
    {
        if (dataModel.allurllink.length > 0)
        {
            WebViewController *webView = [[WebViewController alloc] init];
            webView.webSite = dataModel.allurllink;
            webView.advertid = dataModel.advertid;
            webView.adverttype = dataModel.adverttype;
            BaseNavigationController *selectedViewController = nil;
            if ([Login isLogin])
            {
                RootTabViewController *rootTabViewController = (RootTabViewController *)self.window.rootViewController;
                selectedViewController = (BaseNavigationController *)rootTabViewController.selectedViewController;
            }
            else
            {
                selectedViewController = (BaseNavigationController *)self.window.rootViewController;
            }
            
            [selectedViewController pushViewController:webView animated:YES];
        }
    }
}

- (void)checkKnowledgeAdvertisementsRequest
{
    WEAKSELF
    [[TiHouse_NetAPIManager sharedManager] request_knowLedgeAdvertisementsWithPath:@"api/outer/advert/getKnowAdvert" Params:nil Block:^(KnowledgeAdvertisementsDataModel *data, NSError *error) {
        if (!error)
        {
            [[CommonDataCenter shareCommonDataCenter] setHasKnowledgeAdvertisements:YES];
            [[CommonDataCenter shareCommonDataCenter] setKnowledgeAdvertisementsModel:data];
        }
    }];
}

- (void)resetRootViewController
{
    self.window.rootViewController = nil;
    if ([Login isLogin]) {
        [self setupTabViewController];
        User *user = [Login curLoginUser];
        [[UnReadManager shareManager] updateUnRead];
        NSLog(@"用户融云token %@", user.rongcloudToken);
        [[RCIM sharedRCIM] connectWithToken:user.rongcloudToken success:^(NSString *userId) {
            NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        } error:^(RCConnectErrorCode status) {
            NSLog(@"登陆的错误码为:%ld", (long)status);
        } tokenIncorrect:^{
            NSLog(@"token错误");
        }];
    }else{
        [self setRootViewController];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
   
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void(^)(UIBackgroundFetchResult))completionHandler {
   
    completionHandler(UIBackgroundFetchResultNewData);
}


- (void)dealloc
{
    if (self.adVertisementView)
    {
        [self.adVertisementView removeFromSuperview];
    }
}

- (BOOL)isAccountInfoBindingOperator {
    RootTabViewController *tabViewController = (RootTabViewController *)self.window.rootViewController;
    if ([[tabViewController viewControllers] count] <= 0) return NO;
    BaseNavigationController *MineNavigationController = [[tabViewController viewControllers] lastObject];
    if (!MineNavigationController || ![MineNavigationController isKindOfClass:NSClassFromString(@"BaseNavigationController")]) return NO;
    UIViewController *currentViewController = [[MineNavigationController viewControllers] lastObject];
    if ([currentViewController isKindOfClass:NSClassFromString(@"AccountInfoViewController")]) {
        return YES;
    }
    return NO;
}
@end
