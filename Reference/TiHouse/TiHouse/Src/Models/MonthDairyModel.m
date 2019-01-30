//
//  MonthDairyModel.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/4/16.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "MonthDairyModel.h"

@implementation MonthDairyFile

@end

@implementation MonthDairyModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"dairymonthfileJA" : [MonthDairyFile class]
             };
}
@end
