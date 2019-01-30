//
//  RawCacheManager.m
//  GB_Team
//
//  Created by weilai on 16/9/8.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "RawCacheManager.h"

NSString *const kLastUserLoginAccountKey = @"kLastUserLoginAccountKey";

NSString *const kHasLoginKey = @"kHasLoginKey";

NSString *const kIsNolongerRemindKey = @"kIsNolongerRemindKey";

NSString *const kIsNoLocationRemindKey = @"kIsNoLocationRemindKey";

@implementation RawCacheManager

+ (RawCacheManager *)sharedRawCacheManager {
    
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[RawCacheManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _lastAccount = [RawCacheManager getLastLoginAccount];
        _lastPassword = [RawCacheManager getLastLoginPassword];
        _isLastLogined = [RawCacheManager hasUserLogin];
        
        self.userInfo = [UserInfo loadCache];

    }
    return self;
}

- (void)clearCache {
    [self.userInfo clearCache];  //清除本地缓存
    self.userInfo = nil;
    
    self.isLastLogined = NO;
}

- (void)setDoingMatchId:(NSInteger)matchId {
    
    self.userInfo.matchId = matchId;
    [self.userInfo saveCache];
}

#pragma mark - Getter and Setter

//--------------用户信息-------------------//
- (void)setUserInfo:(UserInfo *)userInfo {
    
    _userInfo = userInfo;
    [_userInfo saveCache];
}

- (void)setLastAccount:(NSString *)lastAccount {
    
    _lastAccount = lastAccount;
    
    if ([NSString stringIsNullOrEmpty:lastAccount]) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:lastAccount forKey:kLastUserLoginAccountKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setLastPassword:(NSString *)lastPassword {
    
    _lastPassword = lastPassword;
    
    NSString *account = self.lastAccount;
    if (!account) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:lastPassword forKey:account];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setIsLastLogined:(BOOL)isLastLogined {
    
    _isLastLogined = isLastLogined;
    
    [[NSUserDefaults standardUserDefaults] setBool:isLastLogined forKey:kHasLoginKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//--------------缓存登录密码----------------//
#pragma mark -

+ (NSString *)getLastLoginAccount {
    return [[NSUserDefaults standardUserDefaults] stringForKey:kLastUserLoginAccountKey];
}

+ (NSString *)getLastLoginPassword {
    NSString *account = [self getLastLoginAccount];
    if (!account) {
        return @"";
    }
    return [[NSUserDefaults standardUserDefaults] stringForKey:account];
}

+ (BOOL)hasUserLogin {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kHasLoginKey];
}

//--------------比赛----------------//
- (void)setIsNoLongerRemind:(BOOL)isNoLongerRemind {
    
    [[NSUserDefaults standardUserDefaults] setBool:isNoLongerRemind forKey:kIsNolongerRemindKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isNoLongerRemind {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:kIsNolongerRemindKey];
}

//--------------四点定位------------//
- (void)setIsNoLocationRemind:(BOOL)isNoLocationRemind {
    
    [[NSUserDefaults standardUserDefaults] setBool:isNoLocationRemind forKey:kIsNoLocationRemindKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isNoLocationRemind {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:kIsNoLocationRemindKey];
}

@end
