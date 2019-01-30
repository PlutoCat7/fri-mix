//
//  FDCalendarConfig.m
//  GB_Football
//
//  Created by gxd on 17/6/8.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "FDCalendarConfig.h"

@implementation FDCalendarConfig

+ (UIColor *)backgroundColor {
    return [UIColor colorWithHex:0x26272c andAlpha:0.95];
}

+ (UIColor *)heightLightColor {
    return [UIColor colorWithHex:0x01e672];
}

+ (UIColor *)invalidFontColor {
    return [UIColor colorWithHex:0x909090];
}

+ (UIColor *)weekFontColor {
    return [UIColor colorWithHex:0x909090];
}

+ (UIColor *)selectBackgroundColor {
    return [UIColor colorWithHex:0x434343];
}

+ (NSInteger)calendarCellHeight {
    return 30;
}

+ (NSInteger)calendarMonthCellHeight {
    return 40;
}
@end
