//
//  THDevice.h
//  TiHouse
//
//  Created by Charles Zou on 2018/4/23.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THDevice : NSObject

+ (CGFloat)screenWidth;

+ (CGFloat)screenHeight;

+ (CGFloat)navHeight;

+ (CGFloat)safeBottomHeight;

+ (CGFloat)availableHeight;

+ (CGFloat)safeAreaHeight;

+ (CGFloat)tabbarHeight;

+ (BOOL)isUnderiPhone6;
+ (BOOL)isStandardSizeDevice;
+ (BOOL)isOverStandardSizeDevice;

+ (BOOL)isiPhoneX;

@end
