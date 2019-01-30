//
//  SIMenuConfiguration.m
//  NavigationMenu
//
//  Created by Ivan Sapozhnik on 2/20/13.
//  Copyright (c) 2013 Ivan Sapozhnik. All rights reserved.
//

#import "SIMenuConfiguration.h"

@implementation SIMenuConfiguration
//Menu width
+ (float)menuWidth
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return window.frame.size.width;
}

//Menu item height
+ (float)itemCellHeight
{
    return 53.0;
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
    return [UIImage imageNamed:@"ranking_b.png"];
}

//Distance between Title and arrow image
+ (float)arrowPadding
{
    return 13.0;
}

//Items color in menu
+ (UIColor *)itemsColor
{
    return [UIColor blackColor];
}

+ (UIColor *)mainColor
{
    return [UIColor blackColor];
}

+ (float)selectionSpeed
{
    return 0.15;
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
