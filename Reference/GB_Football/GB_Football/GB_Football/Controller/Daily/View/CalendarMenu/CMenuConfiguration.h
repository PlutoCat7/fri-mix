//
//  CMenuConfiguration.h
//  GB_Football
//
//  Created by gxd on 17/6/8.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMenuConfiguration : NSObject

//Menu width
+ (float)menuWidth;

//Animation duration of menu appearence
+ (float)animationDuration;

//Menu substrate alpha value
+ (float)backgroundAlpha;

//Menu alpha value
+ (float)menuAlpha;

//Value of bounce
+ (float)bounceOffset;

//Arrow image near title
+ (UIImage *)arrowImage;

//Distance between Title and arrow image
+ (float)arrowPadding;

//Menu color
+ (UIColor *)mainColor;

//Menu item text color
+ (UIColor *)itemTextColor;

//Selection color
+ (UIColor *)selectionColor;

@end
