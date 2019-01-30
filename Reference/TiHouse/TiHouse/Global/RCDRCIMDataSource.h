//
//  RCDRCIMDataSource.h
//  TiHouse
//
//  Created by admin on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>

#define RCDDataSource [RCDRCIMDataSource shareInstance]

/**
 *  此类写了一个provider的具体示例，开发者可以根据此类结构实现provider
 *  用户信息和群组信息都要通过回传id请求服务器获取，参考具体实现代码。
 */
@interface RCDRCIMDataSource
: NSObject <RCIMUserInfoDataSource>

+ (RCDRCIMDataSource *)shareInstance;

@end
