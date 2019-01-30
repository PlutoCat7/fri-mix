//
//  AttendanceCellModel.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/20.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttendanceCellModel : NSObject

@property (nonatomic, assign) NSInteger day;
@property (nonatomic, copy) NSString *dayString;
@property (nonatomic, assign) BOOL isAttendance; //是否已签到
@property (nonatomic, assign) BOOL isToday;  //是否是今天

@end
