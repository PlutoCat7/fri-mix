//
//  CircleChartView.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/20.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChartDataModel.h"

@interface CircleChartView : UIView

- (void)refreshUI:(NSArray<ChartDataModel *> *)list;

@end
