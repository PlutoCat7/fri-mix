//
//  GBCircleChartViewController.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/20.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBBaseViewController.h"
#import "ChartTopView.h"
#import "ChartDataModel.h"

@interface GBCircleChartViewController : GBBaseViewController

@property (weak, nonatomic) IBOutlet ChartTopView *topView;
@property (nonatomic, copy) void(^actionMoreBlock)();

- (instancetype)initWithChartModelList:(NSArray<ChartDataModel *> *)modelList;

@end
