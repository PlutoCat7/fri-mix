//
//  CourtRequest.h
//  GB_Football
//
//  Created by wsw on 16/7/18.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "BaseNetworkRequest.h"
#import "CourtResponseInfo.h"
#import "CourtPreViewInfo.h"
#import "CourtAddResponseInfo.h"

@interface CourtRequest : BaseNetworkRequest

// 获取球场列表
+ (void)getCourtList:(NSString *)name type:(CourtType)courtType cityName:(NSString *)cityName handler:(RequestCompleteHandler)handler;

// 添加球场
+ (void)addCourt:(CourtInfo *)courtObj handler:(RequestCompleteHandler)handler;

// 删除自定义球场
+ (void)deleteDefineCourt:(NSInteger)courtId handler:(RequestCompleteHandler)handler;

// 预览球场
+ (void)preViewCourt:(CourtInfo *)courtObj handler:(RequestCompleteHandler)handler;

@end
