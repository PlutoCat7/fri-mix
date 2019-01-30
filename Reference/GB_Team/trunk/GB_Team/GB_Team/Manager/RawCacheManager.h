//
//  RawCacheManager.h
//  GB_Team
//
//  Created by weilai on 16/9/8.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserResponseInfo.h"

@interface RawCacheManager : NSObject

+ (RawCacheManager *)sharedRawCacheManager;

- (void)clearCache;

//--------------用户信息-------------------//
@property (nonatomic, strong) UserInfo *userInfo;
//设置待完成的比赛id
- (void)setDoingMatchId:(NSInteger)matchId;

//--------------缓存登录密码----------------//
@property (nonatomic, copy) NSString *lastAccount;
@property (nonatomic, copy) NSString *lastPassword;
@property (nonatomic, assign) BOOL isLastLogined;    //上次是否登录了

//--------------比赛----------------//
@property (nonatomic, assign) BOOL isNoLongerRemind;   //赛前提示是否不再提醒

//--------------四点定位------------//
@property (nonatomic, assign) BOOL isNoLocationRemind;  //四点定位提示

@end
