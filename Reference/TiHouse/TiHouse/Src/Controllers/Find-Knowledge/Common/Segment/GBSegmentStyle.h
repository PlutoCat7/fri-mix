//
//  GBSegmentStyle.h
//  GB_Football
//
//  Created by gxd on 17/7/18.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GBSegmentStyle : NSObject


/** 是否显示滚动条 默认为NO*/
@property (assign, nonatomic, getter=isShowLine) BOOL showLine;
/** 是否滚动标题 默认为YES 设置为NO的时候所有的标题将不会滚动, 并且宽度会平分 和系统的segment效果相似 */
@property (assign, nonatomic, getter=isScrollTitle) BOOL scrollTitle;

/** 滚动条的高度 默认为2 */
@property (assign, nonatomic) CGFloat scrollLineHeight;
/** 滚动条的颜色 */
@property (strong, nonatomic) UIColor *scrollLineColor;
/** 滚动条的背景颜色 */
@property (strong, nonatomic) UIColor *scrollLineBgColor;
/** 标题之间的间隙 默认为15.0 */
@property (assign, nonatomic) CGFloat titleMargin;
/** 标题的字体 默认为14 */
@property (strong, nonatomic) UIFont *titleFont;
@property (strong, nonatomic) UIFont *highlightTitleFont;
/** 标题一般状态的颜色 */
@property (strong, nonatomic) UIColor *normalTitleColor;
/** 标题选中状态的颜色 */
@property (strong, nonatomic) UIColor *selectedTitleColor;
/** segmentVIew的高度, 这个属性只在使用ScrollPageVIew的时候设置生效 */
@property (assign, nonatomic) CGFloat segmentHeight;
/** 标题选中是否突出 */
@property (assign, nonatomic) BOOL highlightSelectTitle;

@end
