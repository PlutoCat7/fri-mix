//
//  UIImage+RoundCorner.h
//  YHImagePicker
//
//  Created by wangshiwen on 15/9/6.
//  Copyright (c) 2015年 yahua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YAHRoundCorner)

/**
 *    使用指定的颜色、大小创建一个UIImage对象
 *
 *    @param color 颜色
 *    @param size  大小
 *
 *    @return 返回创建号的UIImage对象
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 *    使用圆角大小与边框大小创建一个UIimage对象
 *
 *    @param cornerSize 圆角半径
 *    @param borderSize 边框粗细
 *
 *    @return 返回创建好的实例
 */
- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize;

/**
 *    给实例添加一个指定大小的路径
 */
- (void)addRoundedRectToPath:(CGRect)rect context:(CGContextRef)context ovalWidth:(CGFloat)ovalWidth ovalHeight:(CGFloat)ovalHeight;

@end
