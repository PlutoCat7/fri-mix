//
//  ScheduleDayListViewModel.m
//  TiHouse
//
//  Created by apple on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ScheduleDayListViewModel.h"
#import "Login.h"
#import "NSDate+Extend.h"

@implementation ScheduleDayListViewModel
    
@synthesize loadDate = _loadDate;

- (RACSubject *)addSchedule{
    if (!_addSchedule) {
        _addSchedule = [RACSubject subject];
    }
    return _addSchedule;
}

- (NSDictionary *)params{
    
    User *user = [Login curLoginUser];
    
    return @{@"schedulesubmonth":self.loadDate,
             @"houseid":@(self.houseId),
             @"uid":@(user.uid)
             };
}

- (void)setLoadDate:(NSString *)loadDate{
    _loadDate = loadDate;
    _lastMonthDate = [NSDate getLastMonthWithDateString:JString(@"%@-01",_loadDate)];
    _nextMonthDate = [NSDate getNextMonthWithDateString:JString(@"%@-01",_loadDate)];
}

- (NSString *)loadDate{
    if (!_loadDate) {
        _loadDate = [NSDate stringWithDate:[NSDate date] format:@"yyyy-MM"];
        _lastMonthDate = [NSDate getLastMonthWithDateString:JString(@"%@-01",_loadDate)];
        _nextMonthDate = [NSDate getNextMonthWithDateString:JString(@"%@-01",_loadDate)];
        
    }
    return _loadDate;
}


- (void)requestScheduleList{
    WS(weakSelf);
    __block   AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window beginLoading];

    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:URL_Schedule_List_By_Date withParams:[self params] withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        [appDelegate.window endLoading];
        if ([data[@"is"] intValue]) {
            weakSelf.scheduleDay = [ScheduleDayModel yy_modelWithDictionary:data[@"data"]];
            [weakSelf.successSubject sendNext:nil];
            
        }else{
        
            [NSObject showError:error];
        }
        
    }];
}

@end
