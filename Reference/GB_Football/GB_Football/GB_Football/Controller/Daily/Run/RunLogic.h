//
//  RunLogic.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/6.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RunLogic : NSObject

+ (void)startAsyncRunData:(void(^)(BOOL success, NSInteger runBeginTime))completeBlock;

//手环跑步开始时间转化为时间戳
+ (NSInteger)runBeginTime:(NSDictionary *)dataDict;

@end
