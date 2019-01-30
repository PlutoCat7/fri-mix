//
//  GBRadarChartView.h
//  GB_Football
//
//  Created by yahua on 2017/10/20.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXNibBridge.h"

@interface GBRadarChartView : UIView <XXNibBridge>

- (void)setDatas:(NSArray<NSNumber *> *)datas;

@end
