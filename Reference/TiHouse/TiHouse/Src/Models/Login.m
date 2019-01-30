//
//  Login.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/3.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "Login.h" 

#define kLoginStatus @"login_status"
#define kLoginPreUserPhone @"pre_user_phone"
#define kLoginUserDict @"user_dict"
#define kLoginDataListPath @"login_data_list_path.plist"
#define kLoginForTheFirstTime @"login_for_the_first_time"



@implementation Login

static User *curLoginUser;

-(instancetype)init{
    
    if (self = [super init]) {
        self.access_token = @"";
        self.code = @"";
    }
    return self;
}


- (NSString *)toPath{
    
    NSString *toPathStr;
    switch (_goToPath) {
        case GoToPathTypeLogin:
            toPathStr = @"api/outer/user/loginByMobile";
            break;
        case GoToPathTypeRegister:
            toPathStr = @"api/outer/user/regist";
            break;
        case GoToPathTypeWechat:
            if (_isOpenIDOAuth) {
                toPathStr = @"api/outer/wechat/getByCode";
            }else{
                toPathStr = @"api/outer/user/loginByWechat";
            }
            break;
        case GoToPathTypeWeibo:
            if (_isOpenIDOAuth) {
                toPathStr = @"api/outer/weibo/getByAccessToken";
            }else{
                toPathStr = @"api/outer/user/loginByWeibo";
            }
            break;
        case GoToPathTypeQQ:
            if (_isOpenIDOAuth) {
                toPathStr = @"api/outer/qq/getByAccessToken";
            }else{
                toPathStr = @"api/outer/user/loginByQq";
            }
            break;
        default:
            break;
    }
    return toPathStr;
}

- (NSString *)toMessagePath{
    
    NSString *toPathStr;
    switch (_goToPath) {
        case GoToPathTypeRegister:
            toPathStr = @"api/outer/sms/sendWhenRegist";
            break;
        case GoToPathTypeWechat:
            toPathStr = @"api/outer/sms/sendWhenWechatBind";
            break;
        case GoToPathTypeWeibo:
            toPathStr = @"api/outer/sms/sendWhenWeiboBind";
            break;
        case GoToPathTypeQQ:
            toPathStr = @"api/outer/sms/sendWhenQqBind";
            break;
        default:
            break;
    }
    return toPathStr;
}

- (NSDictionary *)toMessageParams{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_phone forKey:@"mobile"];
    if (_picturecodevalue) {
        [params setObject:_picturecodevalue forKey:@"picturecodevalue"];
    }
    if (_picturecodeid) {
        [params setObject:@(_picturecodeid) forKey:@"picturecodeid"];
    }
    return params;
}

- (NSMutableDictionary *)toParams{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    switch (_goToPath) {
        case GoToPathTypeLogin:
        {
            [params removeAllObjects];
//            [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"devicetoken"] forKey:@"userdevicetoken"];
            [params setObject:_phone forKey:@"mobile"];
            [params setObject:[[_password md5Str] uppercaseString] forKey:@"password"];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"devicetoken"]) {
                [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"devicetoken"] forKey:@"userdevicetoken"];
            }

        }
            break;
        case GoToPathTypeRegisterSMS:
        {
            [params removeAllObjects];
            [params setObject:_phone forKey:@"mobile"];
        }
            break;
        case GoToPathTypeRegister:
        {
            [params removeAllObjects];
            [params setObject:_phone forKey:@"mobile"];
            [params setObject:[[_password md5Str] uppercaseString] forKey:@"password"];
            [params setObject:_messageCode forKey:@"smsCode"];
            [params setObject:_urlhead.length<=0?@"/upload/2018/01/23/115400001.jpg":_urlhead forKey:@"urlhead"];
            [params setObject:_nickname forKey:@"username"];
        }
            break;
        case GoToPathTypeWechat:
        {
            if (_isOpenIDOAuth) {
                [params removeAllObjects];
                [params setObject:_code forKey:@"code"];
                if ([[NSUserDefaults standardUserDefaults] objectForKey:@"devicetoken"]) {
                    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"devicetoken"] forKey:@"userdevicetoken"];
                }
            }else{
                [params removeAllObjects];
                [params setObject:_phone forKey:@"mobile"];
                [params setObject:_messageCode forKey:@"smsCode"];
                [params setObject:_openid forKey:@"openidwechat"];
            }
        }
            break;
        case GoToPathTypeWeibo:
        {
            if (_isOpenIDOAuth) {
                [params removeAllObjects];
                [params setObject:_access_token forKey:@"access_token"];
                if ([[NSUserDefaults standardUserDefaults] objectForKey:@"devicetoken"]) {
                    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"devicetoken"] forKey:@"userdevicetoken"];
                }
            }else{
                [params removeAllObjects];
                [params setObject:_phone forKey:@"mobile"];
                [params setObject:_messageCode forKey:@"smsCode"];
                [params setObject:_openid forKey:@"openidweibo"];
            }
        }
            break;
        case GoToPathTypeQQ:
        {
            if (_isOpenIDOAuth) {
                [params removeAllObjects];
                [params setObject:_access_token forKey:@"access_token"];
                if ([[NSUserDefaults standardUserDefaults] objectForKey:@"devicetoken"]) {
                    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"devicetoken"] forKey:@"userdevicetoken"];
                }
            }else{
                [params removeAllObjects];
                [params setObject:_phone forKey:@"mobile"];
                [params setObject:_messageCode forKey:@"smsCode"];
                [params setObject:_openid forKey:@"openidqq"];
            }
        }
            break;
        default:
            break;
    }
    return params;
}

+ (BOOL)isLogin{
    NSNumber *loginStatus = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginStatus];
    if (loginStatus.boolValue && [Login curLoginUser]) {
        User *loginUser = [Login curLoginUser];
        if (loginUser.status && loginUser.status.integerValue == 0) {
            return NO;
        }
        return YES;
    }else{
        return NO;
    }
}

+ (User *)curLoginUser{
    if (!curLoginUser) {
        NSDictionary *loginData = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginUserDict];
        curLoginUser = loginData? [NSObject objectOfClass:@"User" fromJSON:loginData]: nil;
    }
    return curLoginUser;
}


+ (long)curLoginUserID{
    if (!curLoginUser) {
        NSDictionary *loginData = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginUserDict];
        curLoginUser = loginData? [NSObject objectOfClass:@"User" fromJSON:loginData]: nil;
    }
    return curLoginUser.uid;
}

+ (void)doLogin:(NSDictionary *)loginData{
    
    //    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    //    [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //        NSLog(@"cookies : %@", obj.description);
    //    }];
    
    if (loginData) {
        NSMutableDictionary *tmpDic = [[[NSMutableDictionary alloc] initWithDictionary:loginData] mutableCopy];
        if ([loginData[@"token"] length] == 0)
        {
            if (curLoginUser.token.length > 0)
            {
                [tmpDic setObject:curLoginUser.token forKey:@"token"];
            }
        }
        if ([loginData[@"rongcloudToken"] length] == 0)
        {
            if (curLoginUser.rongcloudToken.length > 0)
            {
                [tmpDic setObject:curLoginUser.rongcloudToken forKey:@"rongcloudToken"];
            }
        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSNumber numberWithBool:YES] forKey:kLoginStatus];
        [defaults setObject:tmpDic forKey:kLoginUserDict];
        curLoginUser = [NSObject objectOfClass:@"User" fromJSON:tmpDic];
        [defaults synchronize];
        
        [self saveLoginData:tmpDic];
    }else{
        [Login doLogout];
    }
}

+ (NSMutableDictionary *)readLoginDataList{
    NSMutableDictionary *loginDataList = [NSMutableDictionary dictionaryWithContentsOfFile:[self loginDataListPath]];
    if (!loginDataList) {
        loginDataList = [NSMutableDictionary dictionary];
    }
    return loginDataList;
}

+ (BOOL)saveLoginData:(NSDictionary *)loginData{
    BOOL saved = NO;
    if (loginData) {
        NSMutableDictionary *loginDataList = [self readLoginDataList];
        User *curUser = [NSObject objectOfClass:@"User" fromJSON:loginData];
        if (curUser.mobile.length > 0) {
            [loginDataList setObject:loginData forKey:curUser.mobile];
            saved = YES;
        }
        if (saved) {
            saved = [loginDataList writeToFile:[self loginDataListPath] atomically:YES];
        }
    }
    return saved;
}

+ (NSString *)loginDataListPath{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [documentPath stringByAppendingPathComponent:kLoginDataListPath];
}

+ (void)doLogout{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:NO] forKey:kLoginStatus];
    [defaults setObject:0 forKey:@"RecordHouse"];
    
    [defaults synchronize];
    //删掉   cookie
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.domain hasSuffix:@".coding.net"]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:obj];
        }
    }];
}

+ (void)setPreUserPhone:(NSString *)phoneStr{
    if (phoneStr.length <= 0) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:phoneStr forKey:kLoginPreUserPhone];
    [defaults synchronize];
}

+ (NSString *)preUserPhone{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:kLoginPreUserPhone];
}

+(BOOL)isFirst{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isFirst = [defaults objectForKey:kLoginForTheFirstTime];
    if (!isFirst) {
        [defaults setObject:[NSNumber numberWithBool:YES] forKey:kLoginForTheFirstTime];
        [defaults synchronize];
    }
    return isFirst;
}


+ (BOOL)refreshLoginData:(NSDictionary *)loginData
{
    BOOL saved = NO;
    if (loginData) {
        NSMutableDictionary *loginDataList = [self readLoginDataList];
        User *curUser = [NSObject objectOfClass:@"User" fromJSON:loginData];
        if (curUser.mobile.length > 0) {
            [loginDataList setObject:loginData forKey:curUser.mobile];
            saved = YES;
        }
        if (saved) {
            saved = [loginDataList writeToFile:[self loginDataListPath] atomically:YES];
        }
    }
    return saved;
}


@end
