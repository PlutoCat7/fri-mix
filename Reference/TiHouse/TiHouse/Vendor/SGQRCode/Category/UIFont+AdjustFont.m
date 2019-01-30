//
//  UIFont+AdjustFont.m
//  HotelGGDBEnterprise
//
//  Created by MaTeen on 15/9/16.
//  Copyright (c) 2015年 MaTeen. All rights reserved.
//

#import "UIFont+AdjustFont.h"

@implementation UIFont (AdjustFont)

+ (CGFloat)adjustFontFromFontSize:(CGFloat)size
{
    if ([[UIScreen mainScreen]bounds].size.width < 375.0)
    {
        return size * [[UIScreen mainScreen]bounds].size.width/375.0;
    }
    else
    {
        return size * 1;
    }
}

@end
