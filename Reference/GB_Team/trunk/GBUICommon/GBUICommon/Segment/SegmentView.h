//
//  SegmentView.h
//  GBUICommon
//
//  Created by weilai on 16/9/8.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SegPageViewController.h"

@class SegmentView;

/**
 *  滑动结束或按钮按下某页的index
 */
@protocol SegmentViewDelegate <NSObject>
@optional
- (void)SegmentView:(SegmentView*)segment fromIndex:(NSInteger)fromeIndex toIndex:(NSInteger)toIndex;
- (void)SegmentView:(SegmentView*)segment fromController:(SegPageViewController*)fromController toController:(SegPageViewController*)toController;
@end

@interface SegmentView : UIView

// 构造方法
- (instancetype)initWithFrame:(CGRect)frame
                    topHeight:(CGFloat)topHeight
              viewControllers:(NSArray<SegPageViewController*>*)viewControllers
                       titles:(NSArray<NSString*>*)titles
                     delegate:(id<SegmentViewDelegate>)delegate;

// 滑动到index位置
- (void)setCurrentController:(NSInteger)index;
// 设置title的标题名称
-(void)setTitle:(NSString*)title index:(NSInteger)index;

// 滑动开关
@property (nonatomic,assign) BOOL scrollerEnable;

@property (nonatomic, assign) BOOL isNeedDelete;  //是否需要开启左滑删除cell

@end
