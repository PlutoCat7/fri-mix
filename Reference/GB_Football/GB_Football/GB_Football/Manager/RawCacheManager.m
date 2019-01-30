//
//  RowCachemanager.m
//  GB_Football
//
//  Created by wsw on 16/7/12.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "RawCacheManager.h"
#import "GDataXMLNode.h"

NSString *const kLastUserLoginAccountKey = @"kLastUserLoginAccountKey";

NSString *const kHasLoginKey = @"kHasLoginKey";

NSString *const KBindDeviceKey = @"KBindDeviceKey";

NSString *const kIsNoLocationRemindKey = @"kIsNoLocationRemindKey";

NSString *const kLastUpdateMessageListKey = @"kLastUpdateMessageListKey";

NSString *const kLastUpdateInviteMessageListKey = @"kLastUpdateInviteMessageListKey";

NSString *const kLastUpdateTeamMessageListKey = @"kLastUpdateTeamMessageListKey";

NSString *const kSelectMapTypeKey = @"kSelectMapTypeKey";


@interface RawCacheManager ()

@property (nonatomic, strong) NSArray<AreaInfo *> *areaList;

@end

@implementation RawCacheManager

+ (RawCacheManager *)sharedRawCacheManager {
    
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[RawCacheManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        @try {
            self.userInfo = [UserInfo loadCache];
            self.appConfigInfo = [AppConfigInfo loadCache];
        } @catch (NSException *exception) {
            
        }
    }
    return self;
}

#pragma mark - Public

- (BOOL)isBindWristband {
    
    return (self.userInfo.wristbandInfo != nil && ![NSString stringIsNullOrEmpty:self.userInfo.wristbandInfo.number]);
}

- (void)clearLoginCache {
    
    [self.userInfo clearCache];  //清除本地缓存
    self.userInfo = nil;
    self.isLastLogined = NO;
}

+ (NSString *)getLastLoginAccount {
    
    return [[NSUserDefaults standardUserDefaults] stringForKey:kLastUserLoginAccountKey];
}

+ (NSString *)cacheWithKey:(NSString *)key {
    
    return [[NSUserDefaults standardUserDefaults] stringForKey:key];
}

+ (void)saveCacheWithObject:(NSString *)object key:(NSString *)key {
    
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Private

- (NSArray<AreaInfo *> *)areaList {
    
    if (!_areaList) {
        
        // 读取province.xml文件
        NSMutableArray *tmpAreaList = [[NSMutableArray alloc] initWithCapacity:1];
        NSString *filepath=[[NSBundle mainBundle] pathForResource:@"province" ofType:@"xml"];
        NSData *data=[[NSData alloc]initWithContentsOfFile:filepath];
        GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithData:data encoding:NSUTF8StringEncoding error:nil];
        GDataXMLElement *xmlEle = [xmlDoc rootElement];
        NSArray *array = [xmlEle children];
        //读取省
        for (int i = 0; i < [array count]; i++) {
            GDataXMLElement *ele = [array objectAtIndex:i];
            // 根据标签名判断
            if ([[ele name] isEqualToString:@"province"]) {
                AreaInfo *provinceObj = [[AreaInfo alloc]init];
                provinceObj.areaID = [[[ele attributeForName:@"id"] stringValue] integerValue];
                provinceObj.areaName = [[ele attributeForName:@"name"] stringValue];
                provinceObj.areaChidlArray = [NSMutableArray new];
                
                // 读取市
                NSArray *cityArray = [ele children];
                for (int j = 0; j < [cityArray count]; j++) {
                    GDataXMLElement *cityEle = [cityArray objectAtIndex:j];
                    if ([[cityEle name] isEqualToString:@"city"]) {
                        AreaInfo *cityObj = [[AreaInfo alloc] init];
                        cityObj.superAreaInfo = provinceObj;
                        cityObj.areaID = [[[cityEle attributeForName:@"id"] stringValue] integerValue];
                        cityObj.areaName = [[cityEle attributeForName:@"name"] stringValue];
                        cityObj.areaChidlArray = [NSMutableArray new];
                        [provinceObj.areaChidlArray addObject:cityObj];
                        
                        // 读取区
                        NSArray *areaArray = [cityEle children];
                        for (int m = 0; m < [areaArray count]; m++) {
                            GDataXMLElement *areaEle = [areaArray objectAtIndex:m];
                            if ([[areaEle name] isEqualToString:@"region"]) {
                                AreaInfo *areaObj = [[AreaInfo alloc] init];
                                areaObj.superAreaInfo = cityObj;
                                areaObj.areaID = [[[areaEle attributeForName:@"id"] stringValue] integerValue];
                                areaObj.areaName = [[areaEle attributeForName:@"name"] stringValue];
                                [cityObj.areaChidlArray addObject:areaObj];
                            }
                        }
                    }
                }
                
                [tmpAreaList addObject:provinceObj];
            }
        }
        _areaList = [tmpAreaList copy];
    }
    return _areaList;
}

#pragma mark - Getter and Setter

- (void)setUserInfo:(UserInfo *)userInfo {
    
    _userInfo = userInfo;
    [_userInfo saveCache];
}

- (void)setAppConfigInfo:(AppConfigInfo *)appConfigInfo {
    _appConfigInfo = appConfigInfo;
    [_appConfigInfo saveCache];
}

- (NSInteger)stepNumberGoal {
    
    NSInteger setupNumer = self.userInfo.config.stepNumberGoal;
    if (setupNumer == 0) {
        return 1000;
    }
    return setupNumer;
}

- (void)setLastAccount:(NSString *)lastAccount {
    
    if ([NSString stringIsNullOrEmpty:lastAccount]) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:lastAccount forKey:kLastUserLoginAccountKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)lastAccount {
    
    return [[NSUserDefaults standardUserDefaults] stringForKey:kLastUserLoginAccountKey];
}

- (void)setLastPassword:(NSString *)lastPassword {
    
    NSString *account = self.lastAccount;
    if (!account) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:lastPassword forKey:account];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)lastPassword {
    
    NSString *account = self.lastAccount;
    if (!account) {
        return @"";
    }
    return [[NSUserDefaults standardUserDefaults] stringForKey:account];
}

- (void)setIsLastLogined:(BOOL)isLastLogined {
    
    [[NSUserDefaults standardUserDefaults] setBool:isLastLogined forKey:kHasLoginKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isLastLogined {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:kHasLoginKey];
}

- (void)setIsNoLocationRemind:(BOOL)isNoLocationRemind {
    
    [[NSUserDefaults standardUserDefaults] setBool:isNoLocationRemind forKey:kIsNoLocationRemindKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isNoLocationRemind {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:kIsNoLocationRemindKey];
}

- (void)setLastGetMessageTime:(NSInteger)lastGetMessageTime {
    
    NSString *cacheKey = [NSString stringWithFormat:@"%td-%@", self.userInfo.userId, kLastUpdateMessageListKey];
    [[NSUserDefaults standardUserDefaults] setInteger:lastGetMessageTime forKey:cacheKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)lastGetMessageTime {
    
    NSString *cacheKey = [NSString stringWithFormat:@"%td-%@", self.userInfo.userId, kLastUpdateMessageListKey];
    NSInteger time = [[NSUserDefaults standardUserDefaults] integerForKey:cacheKey];
    if (time == 0) {
        time = [NSDate date].timeIntervalSince1970;
        self.lastGetMessageTime = time;
    }
    return time;
}

- (void)setLastGetInviteMessageTime:(NSInteger)lastGetInviteMessageTime {
    
    NSString *cacheKey = [NSString stringWithFormat:@"%td-%@", self.userInfo.userId, kLastUpdateInviteMessageListKey];
    [[NSUserDefaults standardUserDefaults] setInteger:lastGetInviteMessageTime forKey:cacheKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)lastGetInviteMessageTime {
    
    NSString *cacheKey = [NSString stringWithFormat:@"%td-%@", self.userInfo.userId, kLastUpdateInviteMessageListKey];
    NSInteger time = [[NSUserDefaults standardUserDefaults] integerForKey:cacheKey];
    if (time == 0) {
        time = [NSDate date].timeIntervalSince1970;
        self.lastGetInviteMessageTime = time;
    }
    return time;
}

- (void)setLastGetTeamMessageTime:(NSInteger)lastGetTeamMessageTime {
    
    NSString *cacheKey = [NSString stringWithFormat:@"%td-%@", self.userInfo.userId, kLastUpdateTeamMessageListKey];
    [[NSUserDefaults standardUserDefaults] setInteger:lastGetTeamMessageTime forKey:cacheKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)lastGetTeamMessageTime {
    
    NSString *cacheKey = [NSString stringWithFormat:@"%td-%@", self.userInfo.userId, kLastUpdateTeamMessageListKey];
    NSInteger time = [[NSUserDefaults standardUserDefaults] integerForKey:cacheKey];
    if (time == 0) {
        time = [NSDate date].timeIntervalSince1970;
        self.lastGetTeamMessageTime = time;
    }
    return time;
}


- (void)setMapType:(MapType)mapType {
    
    NSString *cacheKey = [NSString stringWithFormat:@"%td-%@", self.userInfo.userId, kSelectMapTypeKey];
    [[NSUserDefaults standardUserDefaults] setInteger:mapType forKey:cacheKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (MapType)mapType {
    
    NSString *cacheKey = [NSString stringWithFormat:@"%td-%@", self.userInfo.userId, kSelectMapTypeKey];
    return [[NSUserDefaults standardUserDefaults] integerForKey:cacheKey];
}

/////
NSString *const kHoneKongKey = @"kHoneKongKey";
- (void)setIsHongKong:(BOOL)isHongKong {
    
    [[NSUserDefaults standardUserDefaults] setBool:isHongKong forKey:kHoneKongKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isHongKong {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:kHoneKongKey];
}

NSString *const kMacaoKey = @"kMacaoKey";
- (void)setIsMacao:(BOOL)isMacao {
    
    [[NSUserDefaults standardUserDefaults] setBool:isMacao forKey:kMacaoKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isMacao {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:kMacaoKey];
}


@end
