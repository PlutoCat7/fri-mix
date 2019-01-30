//
//  DarkColorStyle.m
//  GB_Football
//
//  Created by wsw on 16/8/5.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "DarkColorStyle.h"

@implementation DarkColorStyle

- (UIColor *)styleColor {
    
    return [UIColor colorWithHex:0x01ff00];
}

- (UIColor *)styleColor_50 {
    
    return [UIColor colorWithHex:0x01ff00 andAlpha:0.5];
}

- (UIColor *)bgColor {
    
    return [UIColor colorWithHex:0x171717];
}

- (UIColor *)textColor {
    
    return [UIColor whiteColor];
}

- (UIColor *)placeholderColor {
    
    return [UIColor colorWithRed:144/255.f green:144/255.f blue:144/255.f alpha:1];
}

- (UIColor *)inputBgColor {
    
    return [UIColor colorWithHex:0x2f2f2f];
}

- (UIColor *)disableColor {
    
    return [UIColor colorWithHex:0x3f3f3f];
}

@end
