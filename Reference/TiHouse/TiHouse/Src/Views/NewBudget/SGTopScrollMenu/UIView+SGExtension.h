//
//  UIView+SGExtension.h
//  UIView+SGExtension
//
//  Created by Sorgle on 15/6/21.
//  Copyright © 2015年 Sorgle. All rights reserved.
//

// 欢迎来Github上下载最完整的Demo
// Github下载地址 https://github.com/Hanymore/SGTopScrollMenu.git


#import <UIKit/UIKit.h>

@interface UIView (SGExtension)
@property (nonatomic ,assign) CGFloat SG_x;
@property (nonatomic ,assign) CGFloat SG_y;
@property (nonatomic ,assign) CGFloat SG_width;
@property (nonatomic ,assign) CGFloat SG_height;
@property (nonatomic ,assign) CGFloat SG_centerX;
@property (nonatomic ,assign) CGFloat SG_centerY;

@property (nonatomic ,assign) CGSize SG_size;

@property (nonatomic, assign) CGFloat SG_right;
@property (nonatomic, assign) CGFloat SG_bottom;

+ (instancetype)SG_viewFromXib;
/** 在分类中声明@property， 只会生成方法的声明， 不会生成方法的实现和带有_线成员变量 */
@end
