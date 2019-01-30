//
//  GBSegmentTitleView.h
//  GB_Football
//
//  Created by gxd on 17/7/18.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GBSegmentTitleView;

@protocol GBSegmentTitleViewDelegate <NSObject>
@optional
- (void)GBSegmentTitleView:(GBSegmentTitleView*)titleView;
@end

@interface GBSegmentTitleView : UIView

@property (assign, nonatomic) CGFloat currentTransformSx;

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIFont *font;
@property (strong, nonatomic) UIFont *highlightFont;
@property (assign, nonatomic, getter=isSelected) BOOL selected;

// 滑动结束或按钮按下的delegate
@property(nonatomic,weak)id<GBSegmentTitleViewDelegate>delegate;

- (CGFloat)titleViewWidth;
- (void)adjustSubviewFrame;

@end
