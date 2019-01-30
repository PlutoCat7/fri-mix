//
//  ColorManager.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/1.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "ColorManager.h"

@implementation ColorManager

+ (UIColor *)styleColor {
    
    return [UIColor colorWithHex:0x17b0ff];
}

+ (UIColor *)defaultLineColor {
    
    return [UIColor colorWithHex:0xe1e0e6];
}

+ (UIColor *)viewControllerBackgroundColor {
    
    return [UIColor colorWithHex:0xefeff6];
}

+ (UIColor *)buttonDisableColor {

    return [UIColor grayColor];
}

@end
