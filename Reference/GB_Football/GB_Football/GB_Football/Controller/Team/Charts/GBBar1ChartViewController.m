//
//  GBBar1ChartViewController.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/20.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBBar1ChartViewController.h"

#import "YAHCharts-Swift.h"
#import "Bar1xAxisValueFormatter.h"
#import "Bar1DataValueFormatter.h"

@interface GBBar1ChartViewController () <
ChartTopViewDelegate>

@property (weak, nonatomic) IBOutlet BarChartView *chartView;

@property (nonatomic, strong) NSArray<ChartDataModel *> *modelList;

@end

@implementation GBBar1ChartViewController

- (instancetype)initWithChartModelList:(NSArray<ChartDataModel *> *)modelList {
    
    self = [super init];
    if (self) {
        NSMutableArray *list = [NSMutableArray arrayWithArray:modelList];
        for (NSInteger i=list.count; i<6; i++) {  //默认显示6个
            ChartDataModel *model = [[ChartDataModel alloc] init];
            model.value = @(-1);
            [list addObject:model];
        }
        _modelList = [list copy];
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Bar1";
    [self setupBackButtonWithBlock:nil];
    self.topView.delegate = self;
    self.topView.textcColor = [UIColor colorWithHex:0xc2328a];
    [self setupChartView];
}

- (void)setupChartView {
    
    _chartView.chartDescription.enabled = NO;
    _chartView.userInteractionEnabled = NO;
    _chartView.legend.enabled = NO;
    
    //设置X轴样式
    ChartXAxis *xAxis = self.chartView.xAxis;
    xAxis.axisLineWidth = 1;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelRotationAngle = -45;
    xAxis.drawGridLinesEnabled = NO;
    xAxis.labelTextColors = [_modelList subValueListWithKey:@"nameColor"];
    xAxis.labelFonts = [_modelList subValueListWithKey:@"nameFont"];
    xAxis.valueFormatter = [[Bar1xAxisValueFormatter alloc] initWithValues:[self.modelList subValueListWithKey:@"name"]];
    xAxis.axisLineColor = [UIColor colorWithHex:0x0b3659];
    xAxis.labelCount = self.modelList.count;
    xAxis.granularity = 1;
    
    //设置Y轴样式
    self.chartView.rightAxis.enabled = NO;
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    [leftAxis removeAllLimitLines];
    leftAxis.axisLineWidth = 1.f;
    leftAxis.axisMaximum = [self maxYValue];
    leftAxis.axisMinimum = 0.0;
    leftAxis.forceLabelsEnabled = NO;//不强制绘制指定数量的label
    leftAxis.drawGridLinesEnabled = YES;
    leftAxis.gridColor = [UIColor colorWithHex:0x0b3659 andAlpha:0.5];
    leftAxis.axisLineColor = [UIColor colorWithHex:0x0b3659];
    leftAxis.labelTextColor = [UIColor colorWithHex:0x909090];
    
    
    [self setChartsData];
    
}

- (CGFloat)maxYValue {
    
    CGFloat maxYValue = 0;
    if (self.modelList.firstObject.value.floatValue<=0) {
        maxYValue = 20;
    }else {
        maxYValue = self.modelList.firstObject.value.floatValue*1.4;
    }
    return maxYValue;
}

- (void)setChartsData {
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:1];
    for (NSInteger i=0; i<_modelList.count; i++)
    {
        ChartDataModel *model = _modelList[i];
        [values addObject:[[BarChartDataEntry alloc] initWithX:i y:[model.value floatValue]]];
        [colors addObject:model.valueTextColor];
    }
    
    BarChartDataSet *set1 = nil;
    if (_chartView.data.dataSetCount > 0)
    {
        set1 = (BarChartDataSet *)_chartView.data.dataSets[0];
        set1.values = values;
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[BarChartDataSet alloc] initWithValues:values label:@""];
        [set1 setColor:[UIColor colorWithHex:0x1091d2]];
        set1.valueFont = [UIFont systemFontOfSize:9.f];
        set1.valueColors = colors;
        set1.valueFormatter = [[Bar1DataValueFormatter alloc] init];
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
        data.barWidth = 0.5;
        
        _chartView.data = data;
    }
}

#pragma mark - Delegate

- (void)actionMore:(ChartTopView *)chartTopView {
    
    BLOCK_EXEC(self.actionMoreBlock);
}


@end
