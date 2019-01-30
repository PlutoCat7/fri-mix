//
//  TiHouse_NetAPIManager+Tally.h
//  TiHouse
//
//  Created by AlienJunX on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "TiHouse_NetAPIManager.h"

@class TallyDetail;

@interface TiHouse_NetAPIManager (Tally)

// 获取记账模板
- (void)request_TallyTempletWithPath:(NSString *)path Params:(id)params Block:(void (^)(id data, NSError *error))block;

// 添加记账明细
- (void)request_AddTallyPro:(TallyDetail *)tallyDetail Block:(void (^)(id data, NSError *error))block;

// 删除明细
- (void)request_RemoveTallyProWithId:(NSInteger)tallyproid  tallyId:(NSInteger)tallyId Block:(void (^)(id data, NSError *error))block;

// 添加记账模板标签
- (void)request_AddTallyTempletWidthParams:(id)params Block:(void (^)(id data, NSError *error))block;

// 是否文字中是否有日期
- (void)request_RecognSynchronWidthParams:(id)params BlocRk:(void (^)(id data, NSError *error))block;

// 上传音频文件
- (void)uploadVoiceFile:(NSData *)data name:(NSString *)name
           successBlock:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
           failureBlock:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure
          progerssBlock:(void (^)(CGFloat progressValue))progress;

// 添加记账明细
- (void)requestLocationList:(NSInteger )num
                      limit:(NSInteger)limit
                        lng:(CGFloat)lng
                        lat:(CGFloat)lat
                     keyStr:(NSString *)keyStr
                   cityName:(NSString *)cityName
                      Block:(void (^)(id data, NSError *error))block;

// 品牌搜索
- (void)requestBrand:(NSString *)name
               Block:(void (^)(id data, NSError *error))block;

// 获取预算列表
- (void)requestBudgetlist:(NSInteger )houseid
               Block:(void (^)(id data, NSError *error))block;

@end

