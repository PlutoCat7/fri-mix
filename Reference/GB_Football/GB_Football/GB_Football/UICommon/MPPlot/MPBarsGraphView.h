//
//  MPBarsGraphView.h
//  MPPlot
//
//  Created by Alex Manzella on 22/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPPlot.h"

typedef NS_ENUM(NSInteger, TYPE_BAR)
{
    TYPE_WEEK = 1,// 周表
    TYPE_MONTH    // 月表
};

@class MPBarsGraphView;
@protocol MPBarsGraphViewDelegate
@required
// 柱状图颜色
-(NSArray<UIColor*>*)MPBarsGraphViewColor:(MPBarsGraphView*)barGraph;
// 柱状图类型
-(TYPE_BAR)MPBarsGraphViewType:(MPBarsGraphView*)barGraph;
@end

@interface MPBarsGraphView : MPPlot
@property (nonatomic,weak) id<MPBarsGraphViewDelegate> delegate;
@end
