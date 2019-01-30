//
//  GBSegmentView.h
//  GB_Football
//
//  Created by Leo Lin Software Engineer on 16/7/11.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageViewController.h"
#import "GBSegmentHeadScrollView.h"

@class GBSegmentView;

/**
 *  滑动结束或按钮按下某页的index
 */
@protocol GBSegmentViewDelegate <NSObject>
@optional
- (void)GBSegmentView:(GBSegmentView*)segment toIndex:(NSInteger)index;
- (void)GBSegmentView:(GBSegmentView*)segment toViewController:(PageViewController*)viewController;
@end

@interface GBSegmentView : UIView
// 构造方法
- (instancetype)initWithFrame:(CGRect)frame
                    topHeight:(CGFloat)topHeight
              viewControllers:(NSArray<UIViewController*>*)viewControllers
                       titles:(NSArray<NSString*>*)titles
                     delegate:(id<GBSegmentViewDelegate>)delegate;

- (instancetype)initWithFrame:(CGRect)frame
                    topHeight:(CGFloat)topHeight
              viewControllers:(NSArray<UIViewController*>*)viewControllers
                       titles:(NSArray<NSString*>*)titles
                 segmentStyle:(GBSegmentStyle *)segmentStyle
                     delegate:(id<GBSegmentViewDelegate>)delegate;

@property (nonatomic, assign, readonly) NSInteger currentIndex;

// 滑动结束或按钮按下的delegate
// @property(nonatomic,weak)id<GBSegmentViewDelegate>delegate;
// 滑动到index位置
- (void)goCurrentController:(NSInteger)index;
// 设置title的标题名称
-(void)setTitle:(NSString*)title index:(NSInteger)index;

//设置菜单高度
- (void)resetTopItemHeight:(CGFloat)height;

// 滑动开关
@property (nonatomic,assign) BOOL scrollerEnable;

@property (nonatomic, assign) BOOL isNeedDelete;  //是否需要开启左滑删除cell

@end
