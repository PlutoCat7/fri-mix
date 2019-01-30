//
//  UpdateManager.h
//  GB_Football
//
//  Created by 王时温 on 2016/11/8.
//  Copyright © 2016年 Go Brother. All rights reserved.
//  app及固件升级管理

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    MessageType_None = -1,        //不操作
    MessageType_Friend = 1,       //好友
    MessageType_MatchData = 2,    //比赛数据
    MessageType_InsideWeb = 3,    //内部浏览器
    MessageType_OutsideWeb = 4,   //外部浏览器
} MessageType;

@interface UpdateManager : NSObject

+ (instancetype)shareInstance;

- (void)startMonitoring;

- (void)stopMonitoring;

- (void)checkAppAndFirewareUpdate;

- (void)checkAppUpdate:(void(^)(NSString *url, NSError *error))complete;

- (void)checkFirewareUpdate:(void(^)(NSString *url, NSError *error))complete;

//消息是否在已知的类型中，  如果不是就需要更新
- (void)checkAppUpdateWithMessageType:(MessageType)type;

//检测推送类型是否是已知类型  如果不是就需要更新APP
- (BOOL)checkNeedAppUpdateWithPushType:(PushType)type;

@end
