//
//  LogicManager.h
//  GB_Football
//
//  Created by wsw on 16/8/5.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogicManager : NSObject

//场上位置中文名
+ (NSString *)chinesePositonWithIndex:(NSInteger)index;

//场上位置英文名
+ (NSString *)englishPositonWithIndex:(NSInteger)index;

//根据位置索引获取颜色
+ (UIColor *)positonColorWithIndex:(NSInteger)index;

// 热点图坐标转换
+ (NSArray *)transformPointArray:(NSArray *)fourPoints origPoints:(NSArray *)origPoints size:(CGSize)size tansX:(BOOL)tansX tansY:(BOOL)transY;

+ (iBeaconVersion)beaconVersionWithVersionString:(NSString *)version;

@end
