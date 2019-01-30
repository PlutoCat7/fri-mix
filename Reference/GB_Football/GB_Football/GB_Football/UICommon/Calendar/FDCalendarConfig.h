//
//  FDCalendarConfig.h
//  GB_Football
//
//  Created by gxd on 17/6/8.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDCalendarConfig : NSObject

//background color
+ (UIColor *)backgroundColor;
//heightlight color
+ (UIColor *)heightLightColor;
//invalid color
+ (UIColor *)invalidFontColor;
//week color
+ (UIColor *)weekFontColor;
//select background color
+ (UIColor *)selectBackgroundColor;

//cell height
+ (NSInteger)calendarCellHeight;
+ (NSInteger)calendarMonthCellHeight;
@end
