//
//  Tally_NetAPIManager.m
//  TiHouse
//
//  Created by gaodong on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "Tally_NetAPIManager.h"
#import "Tally.h"
#import "User.h"
#import "Login.h"
#import "TimerShaft.h"
#import "modelTallys.h"

@implementation Tally_NetAPIManager

+ (instancetype)sharedManager {
    static Tally_NetAPIManager *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}

-(void)request_TallyHousesListWithStartNum:(long)sNum Limit:(long)limit Houseid:(long)hid Block:(void (^)(id data, NSError *error))block{
    
    
    NSDictionary *par = @{
                          @"start": @(sNum==1?0:sNum*limit),//翻页按条数计算 页码*每页数
                          @"limit": @(limit),
                          @"houseid": @(hid),
                          };
    
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/tally/pageByHouseid" withParams:par withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        
        if ([data[@"is"] intValue]) {
            
            NSArray *list = [Tally mj_objectArrayWithKeyValuesArray:data[@"data"]];
            
            block(list,nil);
        }else{
            if ([data[@"msg"] isEqualToString:@"您没有权限查看此房屋"]) {
                block(data[@"msg"],error);
            } else {
                block(nil, error);
            }
        }
    }];
    
}

//获取账本修改记录（带翻页）
-(void)request_TallyRecordsWithStartNum:(long)sNum Limit:(long)limit Tallyid:(long)tid Block:(void (^)(id data, NSError *error))block{
    
    NSDictionary *par = @{
                          @"start": @(sNum==1?0:sNum*limit),//翻页按条数计算 页码*每页数
                          @"limit": @(limit),
                          @"tallyid": @(tid),
                          };
    
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/logtallyope/pageByTallyid" withParams:par withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        
        if ([data[@"is"] intValue]) {
            
            block(data[@"data"],nil);
        }else{
            block(nil, nil);
        }
    }];
    
}

-(void)request_TallyAddWithName:(NSString *)name Houseid:(long)hid Budgetid:(long)bid Block:(void (^)(id data, NSError *error))block{
    
    User *u = [Login curLoginUser];
    NSDictionary *par = @{@"uid": @(u.uid),
                          @"houseid": @(hid),
                          @"tallyname": name,
                          @"budgetid": @(bid),
                          @"type": @(bid>0?1:0),//根据模板id判断是 默认or 已有模板
                          };
    
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/tally/add" withParams:par withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        
        if ([data[@"is"] intValue]) {
            
            
            [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/logtimeaxis/getTally" withParams:@{@"tallyid": data[@"data"][@"tallyid"]} withMethodType:Post autoShowError:NO andBlock:^(id tallyData, NSError *error) {
                if ([tallyData[@"is"] integerValue]) {
                    // send notification
                    TimerShaft *timerShaft = [TimerShaft mj_objectWithKeyValues:tallyData[@"data"]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:TALLY_RELOAD_NOTIFICATION object:timerShaft userInfo:@{@"isEdit": @NO}];
                }
            }];
            
            block(data[@"data"],nil);
        }else{
            block(nil, nil);
        }
    }];
};

-(void)request_TallyDetailWithTallyID:(long)tid Block:(void (^)(id data, NSError *error))block{
    
    NSDictionary *par = @{@"tallyid": @(tid)};
    
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/tally/get" withParams:par withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        
        Tally *detail = [Tally mj_objectWithKeyValues:data[@"data"]];
        
        if ([data[@"is"] intValue]) {
            block(detail,nil);
        }else{
            block(nil, nil);
        }
    }];
    
}

-(void)request_TallyTempletWithHouseID:(long)hid Block:(void (^)(id data, NSError *error))block{
    
    NSDictionary *par = @{@"houseid": @(hid)};
    
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/budget/listByHouseid" withParams:par withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        
        if ([data[@"is"] intValue]) {
            block(data[@"data"],nil);
        }else{
            block(nil, nil);
        }
    }];
}

-(void)request_TallyInfoListWithTallyID:(long)tid Block:(void (^)(id data, NSError *error))block{
    
    NSDictionary *par = @{@"tallyid": @(tid)};
    
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/tallypro/listByTallyid" withParams:par withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        
        if ([data[@"is"] intValue]) {
            block(data[@"data"],nil);
        }else{
            block(nil, nil);
        }
    }];
}


-(void)request_TallySaveAmountWithTallyID:(long)tid Amount:(double)amount Block:(void (^)(id data, NSError *error))block{
    
    NSDictionary *par = @{
                          @"tallyid": @(tid),
                          @"amountzys": @(amount),
                          };
    
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/tally/editYsje" withParams:par withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        
        if ([data[@"is"] intValue]) {
            
            [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/logtimeaxis/getTally" withParams:@{@"tallyid": @(tid)} withMethodType:Post autoShowError:NO andBlock:^(id tallyData, NSError *error) {
                if ([tallyData[@"is"] integerValue]) {
                    // send notification
                    TimerShaft *timerShaft = [TimerShaft mj_objectWithKeyValues:tallyData[@"data"]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:TALLY_RELOAD_NOTIFICATION object:timerShaft userInfo:@{@"isEdit": @YES}];
                }
            }];
            block(data[@"data"],nil);
        }else{
            block(nil, nil);
        }
    }];
}


-(void)request_TallyEditWithTallyID:(long)tid TallyName:(NSString *)name Block:(void (^)(id data, NSError *error))block{
    
    NSDictionary *par = @{
                          @"tallyid": @(tid),
                          @"tallyname": name,
                          };
    
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/tally/editZbmc" withParams:par withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        
        if ([data[@"is"] intValue]) {
            
            [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/logtimeaxis/getTally" withParams:@{@"tallyid": @(tid)} withMethodType:Post autoShowError:NO andBlock:^(id tallyData, NSError *error) {
                if ([tallyData[@"is"] integerValue]) {
                    // send notification
                    TimerShaft *timerShaft = [TimerShaft mj_objectWithKeyValues:tallyData[@"data"]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:TALLY_RELOAD_NOTIFICATION object:timerShaft userInfo:@{@"isEdit": @YES}];
                }
            }];

            block(data[@"data"],nil);
        }else{
            block(nil, nil);
        }
    }];
}


-(void)request_TallyDeleteWithTallyID:(long)tid Block:(void (^)(id data, NSError *error))block{
    
    NSDictionary *par = @{
                          @"tallyid": @(tid)
                          };
    
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/tally/remove" withParams:par withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        
        if ([data[@"is"] intValue]) {
            modelTallys *modelTally = [[modelTallys alloc] init];
            modelTally.tallyid = tid;
            TimerShaft *timerShaft = [[TimerShaft alloc] init];
            timerShaft.modelTally = modelTally;
            [[NSNotificationCenter defaultCenter] postNotificationName:TALLY_RELOAD_NOTIFICATION object:timerShaft userInfo:@{@"isEdit": @NO, @"isDelete": @YES}];

            block(data[@"data"],nil);
        }else{
            block(nil, nil);
        }
    }];
}

//智能文字识别
-(void)request_TallyTransWithWord:(NSString *)word Block:(void (^)(id data, NSError *error))block{
    
    NSDictionary *par = @{
                          @"word": word
                          };
    
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/outer/auto/identifyByWord" withParams:par withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        
        if ([data[@"is"] intValue]) {
            block(data[@"data"],nil);
        }else{
            block(nil, nil);
        }
    }];
}

@end
