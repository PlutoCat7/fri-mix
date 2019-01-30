//
//  APNSManager.h
//  GB_Football
//
//  Created by 王时温 on 2016/12/4.
//  Copyright © 2016年 Go Brother. All rights reserved.
//  推送管理

#import <Foundation/Foundation.h>
#import "PushItem.h"

@interface APNSManager : NSObject

+ (instancetype)shareInstance;

- (void)pushNotificationWithDictionary:(NSDictionary *)dic;

@end
