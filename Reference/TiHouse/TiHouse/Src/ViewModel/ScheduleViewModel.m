//
//  ScheduleViewModel.m
//  TiHouse
//
//  Created by apple on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ScheduleViewModel.h"
#import "Login.h"
#import "NSDate+Extend.h"

@implementation ScheduleViewModel
@synthesize urlString = _urlString,arrSysData = _arrSysData;



- (ScheduleOptionsViewModel *)scheduleOptionsViewModel{
    if (!_scheduleOptionsViewModel) {
        _scheduleOptionsViewModel = [ScheduleOptionsViewModel new];
    }
    return _scheduleOptionsViewModel;
}
- (NSString *)urlString{
    
//    if (self.scheduleOptionsViewModel.scheduletype == -1) {
//        _urlString = URL_Get_All_Schedule;
//    } else{
        _urlString = URL_Schedule_ByHouseidUid;
//    }
    return _urlString;
}

- (NSMutableArray <ScheduleModel *>*)arrSysData{
    if (!_arrSysData) {
        _arrSysData = [NSMutableArray new];
    }
    return _arrSysData;
}

- (NSMutableArray *)arrSectionData{
    if (!_arrSectionData) {
        _arrSectionData = [NSMutableArray new];
    }
    return _arrSectionData;
}

- (void)setArrSysData:(NSMutableArray<ScheduleModel *> *)arrSysData{
    
    _arrSysData = arrSysData;
    [self.arrSectionData removeAllObjects];
    //对数据分类
    
    for (ScheduleModel * sModel in arrSysData) {
        
        long dateS = sModel.schedulestarttime/1000;
        NSString *date = [NSDate timeStringFromTimestamp:dateS formatter:@"yyyy-MM-dd"];

        [self setScheduleWithModel:sModel dateKey:date];
  
    }
}

/**
 根据是否同一天分类

 @param model 要分类的事件
 @param key 日期 yyyy-MM-dd
 */
- (void)setScheduleWithModel:(ScheduleModel *)model  dateKey:(NSString *)key{
    
    BOOL isContent = NO;
    
    for (int i = 0; i< self.arrSectionData.count; i++) {
        
        NSMutableDictionary *dic = self.arrSectionData[i];
        
        if ([key isEqualToString:dic[kDate]]) {
            NSMutableArray *arr = dic[kScheduleList];
            [arr addObject:model];
            isContent = YES;
            break;
        }
    }
    
    if (!isContent) {
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:key forKey:kDate];
        NSMutableArray *arr = [NSMutableArray new];
        [arr addObject:model];
        [dic setObject:arr forKey:kScheduleList];
        [self.arrSectionData addObject:dic];
    }
}




- (NSDictionary *)getParamWithPage:(NSInteger)page{
    User *user = [Login curLoginUser];
    
//    if (self.scheduleOptionsViewModel.scheduletype == -1) {
//        self.currentPage = 0;
//        return @{
//                 @"limit":@(kPageSize),
//                 @"start":@(page*kPageSize),
//                 @"uid":@(user.uid),
//                 @"houseid":@(self.houseId),
//                 };
//    }
    
    return @{
//             @"limit":@(kPageSize),
//             @"start":@(page*kPageSize),
             @"uid":@(user.uid),
             @"houseid":@(self.houseId),
             @"scheduletype":@(self.scheduleOptionsViewModel.scheduletype)
             //,
//             @"timetype":@(self.scheduleOptionsViewModel.timeType)
             };
    
}

- (NSDictionary *)getSchduleParam{
    User *user = [Login curLoginUser];
    NSDictionary *dic = @{@"uid":@(user.uid),@"scheduleid":@(self.deleteScheduleId)};
    return dic;
}


#pragma mark - 删除

/**
 请求删除日程
 */
- (void)requestDeleteSchedule:(RequestSuccess)block{

//    WS(weakSelf);
    __block   AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window beginLoading];
    
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:URL_Delete_Schedule withParams:[self getSchduleParam] withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        [appDelegate.window endLoading];
        if ([data[@"is"] intValue]) {

            [NSObject showStatusBarSuccessStr:@"删除成功"];

        }else{
            [NSObject showStatusBarErrorStr:data[@"msg"]];
        }
        block([data[@"is"] boolValue]);
        
    }];
}

/**
 请求完成日程
 */
- (void)requestFinishSchedule:(RequestSuccess)block{
    __block   AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window beginLoading];

    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:URL_Edit_Finish_Schedule withParams:[self getSchduleParam] withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        [appDelegate.window endLoading];
        if ([data[@"is"] intValue]) {
            
            [NSObject showStatusBarSuccessStr:@"修改成功"];

        }else{
            [NSObject showStatusBarErrorStr:data[@"msg"]];
        }
        block([data[@"is"] boolValue]);
    }];
}



@end

