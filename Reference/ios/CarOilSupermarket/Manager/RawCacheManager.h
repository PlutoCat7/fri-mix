//
//  RawCacheManager.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/9.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserResponseInfo.h"
#import "AreaInfo.h"
#import "COSConfigResponse.h"

@interface RawCacheManager : NSObject

@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, strong) COSConfigInfo *config;

+ (RawCacheManager *)sharedRawCacheManager;

- (void)loadCache;

//--------------缓存登录----------------//
@property (nonatomic, copy) NSString *lastAccount;
//@property (nonatomic, assign) BOOL isLastLogined;    //上次是否登录了

@property (nonatomic, strong) NSArray<AreaInfo *> *areaList;

/**
 清除登录缓存
 */
- (void)clearLoginCache;

@end
