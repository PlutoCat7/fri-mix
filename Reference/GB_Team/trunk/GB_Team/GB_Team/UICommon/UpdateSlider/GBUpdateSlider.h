//
//  GBUpdateSlider.h
//  GB_Football
//
//  Created by Pizza on 16/8/25.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SLIDER_COLOR)
{
    COLOR_GREEN,// 绿色
    COLOR_RED,  // 红色
    COLOR_CYAN, // 青色
};

@interface GBUpdateSlider : UISlider
@property (nonatomic,assign) SLIDER_COLOR sliderColor;// 外观样式
@end
