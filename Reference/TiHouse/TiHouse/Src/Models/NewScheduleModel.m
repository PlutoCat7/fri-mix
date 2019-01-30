//
//  NewScheduleModel.m
//  TiHouse
//
//  Created by 陈晨昕 on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "NewScheduleModel.h"
#import "Login.h"
#import "NSDate+Extend.h"

@implementation NewScheduleModel

-(RACSubject *)remindPeopleSubject {
    
    if (!_remindPeopleSubject) {
        _remindPeopleSubject = [RACSubject subject];
    }
    return _remindPeopleSubject;
}

-(RACSubject *)remindTimeSubject {
    
    if (!_remindTimeSubject) {
        _remindTimeSubject = [RACSubject subject];
    }
    return _remindTimeSubject;
}

-(RACSubject *)finishSubject {
    if (!_finishSubject) {
        _finishSubject = [RACSubject subject];
    }
    return _finishSubject;
}

/**
 请求删除日程
 */
- (void)requestDeleteSchedule:(void (^)(id data))block {
    
    __block   AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window beginLoading];
    
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:URL_Delete_Schedule withParams:[self getSchduleParam] withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        [appDelegate.window endLoading];
        if ([data[@"is"] intValue]) {
            [NSObject showStatusBarSuccessStr:@"删除成功"];
             block(data[@"msg"]);
            
        } else {
            [NSObject showStatusBarErrorStr:data[@"msg"]];
        }
    }];
}

- (NSDictionary *)getSchduleParam{
    User *user = [Login curLoginUser];
    NSDictionary *dic = @{@"uid":@(user.uid),@"scheduleid":@(self.scheduleM.scheduleid)};
    return dic;
}

@end
