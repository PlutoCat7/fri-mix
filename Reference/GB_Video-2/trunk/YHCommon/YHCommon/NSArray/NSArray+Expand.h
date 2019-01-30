//
//  NSArray+Expand.h
//  GB_Football
//
//  Created by 王时温 on 2017/8/10.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSArray (Expand)

//获取成员某个属性的集合
- (NSArray *)subValueListWithKey:(NSString *)key;

//获取成员某个属性的的总数
- (CGFloat)subValueCountWithKey:(NSString *)key;

//获取成员某个属性的的平均值
- (CGFloat)subValueAvgWithKey:(NSString *)key;

//获取成员某个属性的最大值
- (CGFloat)subValueMaxWithKey:(NSString *)key;

//获取成员某个属性的最小值
- (CGFloat)subValueMinWithKey:(NSString *)key;


//对某一元素进行排序
//降序
- (NSArray *)sortDescWithKey:(NSString *)key;

@end
