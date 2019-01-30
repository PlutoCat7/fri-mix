//
//  CMenuConfiguration.m
//  GB_Football
//
//  Created by gxd on 17/6/8.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "CMenuConfiguration.h"

@implementation CMenuConfiguration

//Menu width
+ (float)menuWidth
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return window.frame.size.width;
}


//Animation duration of menu appearence
+ (float)animationDuration
{
    return 0.3f;
}

//Menu substrate alpha value
+ (float)backgroundAlpha
{
    return 0.6;
}

//Menu alpha value
+ (float)menuAlpha
{
    return 0.8;
}

//Value of bounce
+ (float)bounceOffset
{
    return -7.0;
}

//Arrow image near title
+ (UIImage *)arrowImage
{
    return [UIImage imageNamed:@"spread_more.png"];
}

//Distance between Title and arrow image
+ (float)arrowPadding
{
    return 13.0;
}

+ (UIColor *)mainColor
{
    return [UIColor blackColor];
}

+ (UIColor *)itemTextColor
{
    return [UIColor colorWithHex:0xa5a5a5];
}

+ (UIColor *)selectionColor
{
    return [UIColor colorWithHex:0x171717];;
}

@end
