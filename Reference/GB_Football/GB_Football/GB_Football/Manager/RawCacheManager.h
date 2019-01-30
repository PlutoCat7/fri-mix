//
//  RawCacheManager.h
//  GB_Football
//
//  Created by wsw on 16/7/12.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "UserResponseInfo.h"
#import "AppConfigResponseInfo.h"
#import "AreaInfo.h"

@interface RawCacheManager : NSObject

+ (RawCacheManager *)sharedRawCacheManager;

@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, assign) NSInteger stepNumberGoal;
@property (nonatomic, strong, readonly) NSArray<AreaInfo *> *areaList;

//--------------云配置信息----------------//
@property (nonatomic, strong) AppConfigInfo *appConfigInfo;

//--------------缓存登录密码----------------//
@property (nonatomic, copy) NSString *lastAccount;
@property (nonatomic, copy) NSString *lastPassword;
@property (nonatomic, assign) BOOL isLastLogined;    //上次是否登录了

//--------------是否绑定了手环----------------//
@property (nonatomic, assign) BOOL isBindWristband;

//--------------四点定位提示------------//
@property (nonatomic, assign) BOOL isNoLocationRemind;  //四点定位提示

//--------------上次获取系统消息的时间------------//
@property (nonatomic, assign) NSInteger lastGetMessageTime;
//--------------上次获取邀请消息的时间------------//
@property (nonatomic, assign) NSInteger lastGetInviteMessageTime;
//--------------上次获取球队消息的时间------------//
@property (nonatomic, assign) NSInteger lastGetTeamMessageTime;

//--------------用户选择的地图类型------------//
@property (nonatomic, assign) MapType mapType;

@property (nonatomic, assign) BOOL isHongKong;

@property (nonatomic, assign) BOOL isMacao;

/**
 清除登录缓存
 */
- (void)clearLoginCache;

+ (NSString *)getLastLoginAccount;

+ (NSString *)cacheWithKey:(NSString *)key;

+ (void)saveCacheWithObject:(NSString *)object key:(NSString *)key;

@end
