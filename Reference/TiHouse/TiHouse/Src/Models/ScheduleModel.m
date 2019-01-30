//
//  ScheduleModel.m
//  TiHouse
//
//  Created by cuiPeng on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ScheduleModel.h"

@implementation ScheduleModel

- (instancetype)init
{
    if (self = [super init])
    {
        self.type = SCHEDULEMODELTYPE_SCHEDULE;
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
