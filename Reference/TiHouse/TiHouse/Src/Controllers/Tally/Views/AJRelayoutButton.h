//
//  AJVerticalButton.h
//  TiHouse
//
//  Created by AlienJunX on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
// 图标在上，文字在下 的排列方式
//     🐰
//    xxxx
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AJButtonLayoutStyle) {
    AJButtonLayoutStyleTop, // image在上，label在下
    AJButtonLayoutStyleLeft, // image在左，label在右
    AJButtonLayoutStyleBottom, // image在下，label在上
    AJButtonLayoutStyleRight // image在右，label在左
};


@interface AJRelayoutButton : UIButton
@property (nonatomic) NSInteger space; // 图标与文字的间隔
@property (nonatomic) BOOL isRenderingMode; // default is NO
@property (nonatomic) AJButtonLayoutStyle style;
@property (nonatomic) CGSize fixedImageSize; // 固定图标大小

@end
