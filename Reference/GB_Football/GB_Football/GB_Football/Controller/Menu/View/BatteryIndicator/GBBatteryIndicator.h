//
//  GBBatteryIndicator.h
//  GB_Football
//
//  Created by Pizza on 16/8/11.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    BATTERY_STATE_NULL   = 0,
    BATTERY_STATE_LOW,
    BATTERY_STATE_MIDDLE,
    BATTERY_STATE_HIGH,
    BATTERY_STATE_FULL,
} BATTERY_STATE;

@interface GBBatteryIndicator : UIView
// 电量
@property (assign,nonatomic) NSInteger percent;
@end
