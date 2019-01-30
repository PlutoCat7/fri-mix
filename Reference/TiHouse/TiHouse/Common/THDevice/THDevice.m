
//
//  THDevice.m
//  TiHouse
//
//  Created by Charles Zou on 2018/4/23.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "THDevice.h"

@implementation THDevice

+ (CGFloat)screenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)screenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGFloat)navHeight {
    return ([self isiPhoneX] ? 88 : 64);
}

+ (CGFloat)availableHeight {
    return [self screenHeight] - [self navHeight];
}

+ (CGFloat)safeAreaHeight {
    return [self screenHeight] - [self navHeight] - [self safeBottomHeight];
}

+ (CGFloat)tabbarHeight {
    return 49 + [self safeBottomHeight];
}

+ (CGFloat)safeBottomHeight {
    return ([self isiPhoneX] ? 34 : 0);
}

+ (BOOL)isUnderiPhone6 {
    return ([self screenWidth] < 370);
}

+ (BOOL)isStandardSizeDevice {
    return ([self screenHeight] > 660 && [self screenHeight] < 680);
}

+ (BOOL)isOverStandardSizeDevice {
    return ([self screenHeight] > 680);
}

+ (BOOL)isiPhoneX {
    static NSNumber *isiPhoneX = nil;
    if (isiPhoneX == nil) {
        isiPhoneX = @(([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO));
    }
    return [isiPhoneX boolValue];
}

@end
