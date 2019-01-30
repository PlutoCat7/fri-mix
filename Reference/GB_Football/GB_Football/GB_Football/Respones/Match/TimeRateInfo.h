//
//  TimeRateInfo.h
//  GB_Football
//
//  Created by gxd on 17/9/21.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "YAHActiveObject.h"

@interface TimeRateInfo : YAHActiveObject

@property (nonatomic, strong) NSArray<NSNumber *> *ceil3; //3区
@property (nonatomic, strong) NSArray<NSNumber *> *ceil6; //3区
@property (nonatomic, strong) NSArray<NSNumber *> *ceil9; //3区

@end
