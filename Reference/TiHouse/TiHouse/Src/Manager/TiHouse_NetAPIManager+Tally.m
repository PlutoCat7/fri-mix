//
//  TiHouse_NetAPIManager+Tally.m
//  TiHouse
//
//  Created by AlienJunX on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "TiHouse_NetAPIManager+Tally.h"
#import "TallyCategory.h"
#import "TallyDetail.h"
#import "MultiImageUploadManager.h"
#import "User.h"
#import "Login.h"
#import "Location.h"
#import "BrandModel.h"
#import "TimerShaft.h"

@implementation TiHouse_NetAPIManager (Tally)

- (void)request_TallyTempletWithPath:(NSString *)path
                              Params:(id)params
                               Block:(void (^)(id data, NSError *error))block {
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue] && data[@"data"]) {
            NSArray *categoryArray = [TallyCategory mj_objectArrayWithKeyValuesArray:data[@"data"]];
            block(categoryArray,nil);
        }else{
            block(nil,nil);
        }
    }];
}

- (void)request_AddTallyPro:(TallyDetail *)tallyDetail Block:(void (^)(id data, NSError *error))block {
    NSString *path = tallyDetail.isEdit?@"api/inter/tallypro/edit":@"api/inter/tallypro/add";
    
    // 保存记账数据
    void (^postBlock)(void) = ^{
        [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:path withParams:[tallyDetail addTallDetailtoParams] withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
            
            [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/logtimeaxis/getTally" withParams:@{@"tallyid": @(tallyDetail.tallyid)} withMethodType:Post autoShowError:NO andBlock:^(id tallyData, NSError *error) {
                if ([tallyData[@"is"] integerValue]) {
                    // send notification
                    TimerShaft *timerShaft = [TimerShaft mj_objectWithKeyValues:tallyData[@"data"]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:TALLY_RELOAD_NOTIFICATION object:timerShaft userInfo:@{@"isEdit": @NO}];
                }
            }];

            block(data[@"is"], nil);
        }];
    };
    
    // 上传图片
    __block NSString *imgurlArray = @"";
    if (tallyDetail.imageArray.count > 0) {
        [[MultiImageUploadManager new] uploadImages:tallyDetail.imageArray path:@"api/outer/upload/uploadfile" successBlock:^(NSMutableArray *responseObject) {
            // 全部上传完成
            for (NSDictionary *dic in responseObject) {
                NSString *url = dic[@"halfpath"];
                imgurlArray = [imgurlArray stringByAppendingString:[NSString stringWithFormat:@"%@,",url]];
            }
            tallyDetail.arrurlcert = imgurlArray;
            // 提交保存
            postBlock();
            
        } failureBlock:^(NSError *error) {
            NSLog(@"%@",error);
        } progerssBlock:^(CGFloat progressValue) {
            NSLog(@"%f", progressValue);
        }];
    } else {
        // 提交保存
        postBlock();
    }
}

- (void)request_RemoveTallyProWithId:(NSInteger)tallyproid tallyId:(NSInteger)tallyId Block:(void (^)(id data, NSError *error))block {
    NSDictionary *params = @{@"tallyproid":@(tallyproid)};
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/tallypro/remove" withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue]) {
            [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/logtimeaxis/getTally" withParams:@{@"tallyid": @(tallyId)} withMethodType:Post autoShowError:NO andBlock:^(id tallyData, NSError *error) {
                if ([tallyData[@"is"] integerValue]) {
                    // send notification
                    TimerShaft *timerShaft = [TimerShaft mj_objectWithKeyValues:tallyData[@"data"]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:TALLY_RELOAD_NOTIFICATION object:timerShaft userInfo:@{@"isEdit": @NO}];
                }
            }];
            block(data[@"is"], nil);
        } else {
            block(nil,nil);
        }
    }];
}

- (void)request_AddTallyTempletWidthParams:(id)params Block:(void (^)(id data, NSError *error))block {
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/tallytemplet/add" withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue]) {
            block(data[@"is"], nil);
        } else {
            block(nil, [NSError errorWithDomain:@"" code:-101 userInfo:@{@"msg":data[@"msg"]}]);
        }
    }];
}

- (void)request_RecognSynchronWidthParams:(id)params BlocRk:(void (^)(id data, NSError *error))block {
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/outer/auto/identifyTextToSchedule" withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue]) {
            block(data[@"data"], nil);
        } else {
            block(nil, [NSError errorWithDomain:@"" code:-101 userInfo:@{@"msg":data[@"msg"]}]);
        }
    }];
}

- (void)uploadVoiceFile:(NSData *)data name:(NSString *)name
           successBlock:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
           failureBlock:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure
          progerssBlock:(void (^)(CGFloat progressValue))progress {
    NSString *path = @"api/outer/auto/identifyByVoid";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *nameStr = [NSString stringWithFormat:@"%@%@.caf",name,str];
    XWLog(@"\n===========request===========\n%@:\n%@",path, name);
    [[TiHouseNetAPIClient changeJsonClient] POST:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"voidfile" fileName:nameStr mimeType:@"audio/x-wav"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        CGFloat i = (float)uploadProgress.completedUnitCount/(float)uploadProgress.totalUnitCount;
        if (progress) {
            progress(i);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        XWLog(@"======%@",responseObject);
        if (success) {
            if ([responseObject[@"is"] integerValue]) {
                success(task,responseObject[@"data"]);
                return;
            }
            success(task,nil);
            [NSObject showHudTipStr:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        XWLog(@"======%@",error);
        if (failure) {
            failure(task,error);
        }
    }];
}


- (void)requestLocationList:(NSInteger )num
                      limit:(NSInteger)limit
                        lng:(CGFloat)lng
                        lat:(CGFloat)lat
                     keyStr:(NSString *)keyStr
                   cityName:(NSString *)cityName
                      Block:(void (^)(id data, NSError *error))block {
    User *u = [Login curLoginUser];
    NSDictionary *params = @{
                          @"start": @(num==1?0:num*limit),//翻页按条数计算 页码*每页数
                          @"limit": @(limit),
                          @"uid": @(u.uid),
                          @"locationlng":@(lng),
                          @"locationlat":@(lat),
                          @"keyStr":keyStr?keyStr:@"",
                          @"cityname":cityName?cityName:@""
                          };
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/location/pageByDistance" withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue] && data[@"data"]) {
            NSArray *locationArray = [Location mj_objectArrayWithKeyValuesArray:data[@"data"]];
            block(locationArray,nil);
        } else {
            block(nil,error);
        }
    }];
}


- (void)requestBrand:(NSString *)name Block:(void (^)(id data, NSError *error))block {
    NSDictionary *params = @{
                             @"searchName": name
                             };
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/outer/brand/listBySearch" withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue] && data[@"data"]) {
            NSArray *array = [BrandModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            block(array,nil);
        } else {
            block(nil,error);
        }
    }];
}

// 获取预算列表
- (void)requestBudgetlist:(NSInteger )houseid
                    Block:(void (^)(id data, NSError *error))block{
    
    NSDictionary *params = @{
                             @"houseid": @(houseid)
                             };
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/budget/listByHouseid" withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue] && data[@"data"]) {

            block(data[@"data"],nil);
        } else {
            block(nil,error);
        }
    }];
}

@end
