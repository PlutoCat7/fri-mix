//
//  GBSegmentHeadScrollView.h
//  GB_Football
//
//  Created by gxd on 17/7/18.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBSegmentStyle.h"
#import "GBSegmentTitleView.h"

@interface GBSegmentHeadScrollView : UIView

typedef void(^TitleBtnOnClickBlock)(GBSegmentTitleView *titleView, NSInteger index);

// 所有的标题
@property (strong, nonatomic) NSArray *titles;

- (instancetype)initWithFrame:(CGRect )frame style:(GBSegmentStyle *)style titles:(NSArray *)titles titleDidClick:(TitleBtnOnClickBlock)titleDidClick;


/** 切换下标的时候根据progress同步设置UI*/
- (void)adjustUIWithProgress:(CGFloat)progress oldIndex:(NSInteger)oldIndex currentIndex:(NSInteger)currentIndex;
/** 让选中的标题居中*/
- (void)adjustTitleOffSetToCurrentIndex:(NSInteger)currentIndex animated:(BOOL)animated;
/** 设置选中的下标*/
- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated;
/** 重新刷新标题的内容*/
- (void)reloadTitlesWithNewTitles:(NSArray *)titles;
- (void)setTitleWithIndex:(NSString *)title index:(NSInteger)index;

@end
