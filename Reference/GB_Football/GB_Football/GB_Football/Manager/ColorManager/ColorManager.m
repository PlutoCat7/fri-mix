//
//  ColorManager.m
//  GB_Football
//
//  Created by wsw on 16/8/5.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "ColorManager.h"
#import "DarkColorStyle.h"

@interface ColorManager ()

@property (nonatomic, strong) DarkColorStyle *darkColorStyle;
@property (nonatomic, weak) id<AppColor> colorHandle;

@end

@implementation ColorManager

+ (ColorManager *)sharedRawCacheManager {
    
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[ColorManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.darkColorStyle = [[DarkColorStyle alloc] init];
        self.colorHandle = self.darkColorStyle;
    }
    return self;
}

+ (UIColor *)styleColor {
    
    return [[ColorManager sharedRawCacheManager].colorHandle styleColor];
}

+ (UIColor *)styleColor_50 {
    
    return [[ColorManager sharedRawCacheManager].colorHandle styleColor_50];
}

+ (UIColor *)bgColor {
    
    return [[ColorManager sharedRawCacheManager].colorHandle bgColor];
}

+ (UIColor *)textColor {
    
    return [[ColorManager sharedRawCacheManager].colorHandle textColor];
}

+ (UIColor *)placeholderColor {
    
    return [[ColorManager sharedRawCacheManager].colorHandle placeholderColor];
}

+ (UIColor *)inputBgColor {
    
    return [[ColorManager sharedRawCacheManager].colorHandle inputBgColor];
}

+ (UIColor *)disableColor {
    
    return [[ColorManager sharedRawCacheManager].colorHandle disableColor];
}

@end
