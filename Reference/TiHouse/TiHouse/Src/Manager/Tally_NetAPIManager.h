//
//  Tally_NetAPIManager.h
//  TiHouse
//
//  Created by gaodong on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tally_NetAPIManager : NSObject

+ (instancetype)sharedManager;

//获取账本列表（带翻页）
-(void)request_TallyHousesListWithStartNum:(long)sNum Limit:(long)limit Houseid:(long)hid Block:(void (^)(id data, NSError *error))block;

//获取账本修改记录（带翻页）
-(void)request_TallyRecordsWithStartNum:(long)sNum Limit:(long)limit Tallyid:(long)hid Block:(void (^)(id data, NSError *error))block;

//添加账本
-(void)request_TallyAddWithName:(NSString *)name Houseid:(long)hid Budgetid:(long)bid Block:(void (^)(id data, NSError *error))block;

//获取账本详细
-(void)request_TallyDetailWithTallyID:(long)tid Block:(void (^)(id data, NSError *error))block;

//获取添加账本时的模板
-(void)request_TallyTempletWithHouseID:(long)hid Block:(void (^)(id data, NSError *error))block;

//获取账本详细内容列表
-(void)request_TallyInfoListWithTallyID:(long)tid Block:(void (^)(id data, NSError *error))block;

//保存总预算
-(void)request_TallySaveAmountWithTallyID:(long)tid Amount:(double)amount Block:(void (^)(id data, NSError *error))block;

//编辑账本名称
-(void)request_TallyEditWithTallyID:(long)tid TallyName:(NSString *)name Block:(void (^)(id data, NSError *error))block;

//删除账本
-(void)request_TallyDeleteWithTallyID:(long)tid Block:(void (^)(id data, NSError *error))block;

//智能文字识别
-(void)request_TallyTransWithWord:(NSString *)word Block:(void (^)(id data, NSError *error))block;

@end
