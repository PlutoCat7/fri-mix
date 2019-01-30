//
//  RawCacheManager.h
//  GB_Football
//
//  Created by wsw on 16/7/12.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "CLPlayerView.h"
#import "UserResponse.h"
#import "AreaInfo.h"

@interface RawCacheManager : NSObject

+ (RawCacheManager *)sharedRawCacheManager;

@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, strong, readonly) NSArray<AreaInfo *> *areaList;

//--------------缓存登录密码----------------//
@property (nonatomic, copy) NSString *lastAccount;
@property (nonatomic, copy) NSString *lastPassword;
@property (nonatomic, assign) BOOL isLastLogined;    //上次是否登录了
@property (nonatomic, assign) BOOL isLogined;

//--------------是否非wifi下使用----------------//
@property (nonatomic, assign) BOOL isNoWifi;

@property (nonatomic, strong) CLPlayerView *playerView;
- (void)retainPlayerView;
- (void)releasePlayerView;

/**
 清除登录缓存
 */
- (void)clearLoginCache;

+ (NSString *)getLastLoginAccount;

+ (NSString *)cacheWithKey:(NSString *)key;

+ (void)saveCacheWithObject:(NSString *)object key:(NSString *)key;


@end
