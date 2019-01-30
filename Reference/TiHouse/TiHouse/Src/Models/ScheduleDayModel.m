//
//  ScheduleDayModel.m
//  TiHouse
//
//  Created by apple on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ScheduleDayModel.h"

@implementation ScheduleDayModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [ScheduleDayListModel class]
             };
}
@end
