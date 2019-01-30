//
//  GBBar2ChartViewController.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/20.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBBar2ChartViewController.h"

#import "YAHCharts-Swift.h"
#import "Bar2xAxisValueFormatter.h"
#import "Bar2DataValueFormatter.h"

@interface GBBar2ChartViewController ()<
ChartTopViewDelegate>

@property (weak, nonatomic) IBOutlet HorizontalBarChartView *chartView;

@property (nonatomic, strong) NSArray<ChartDataModel *> *modelList;

@end

@implementation GBBar2ChartViewController

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
    self.title = @"Bar2";
    [self setupBackButtonWithBlock:nil];
    self.topView.delegate = self;
    self.topView.textcColor = [UIColor colorWithHex:0x2ebecb];
    [self setupChartView];
}

- (void)setupChartView {
    
    _chartView.chartDescription.enabled = NO;
    _chartView.userInteractionEnabled = NO;
    _chartView.legend.formSize = 0;   //不显示这个，rightAxis下部会截断
    
    //设置X轴样式
    ChartXAxis *xAxis = self.chartView.xAxis;
    xAxis.axisLineWidth = 1;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelTextColors = [_modelList subValueListWithKey:@"nameColor"];
    xAxis.labelFonts = [_modelList subValueListWithKey:@"nameFont"];
    xAxis.valueFormatter = [[Bar2xAxisValueFormatter alloc] initWithValues:[self.modelList subValueListWithKey:@"name"]];
    xAxis.drawGridLinesEnabled = NO;
    xAxis.labelCount = self.modelList.count;
    xAxis.granularity = 1;
    xAxis.axisLineColor = [UIColor colorWithHex:0x0b3659];
    
    //设置Y轴样式  //显示leftAxis  解决柱状图偏移问题
    ChartYAxis *leftAxis = _chartView.leftAxis;
    [leftAxis removeAllLimitLines];
    leftAxis.axisMaximum = 10.5;
    leftAxis.axisMinimum = 0.0;
    leftAxis.labelCount = 10;
    leftAxis.forceLabelsEnabled = NO;//不强制绘制指定数量的label
    leftAxis.axisLineColor = [UIColor clearColor];
    leftAxis.drawGridLinesEnabled = NO;
    leftAxis.labelTextColor = [UIColor clearColor];
    
    ChartYAxis *rightAxis = _chartView.rightAxis;
    [rightAxis removeAllLimitLines];
    rightAxis.axisMaximum = 10.5;
    rightAxis.axisMinimum = 0.0;
    rightAxis.labelCount = 10;
    rightAxis.forceLabelsEnabled = NO;//不强制绘制指定数量的label
    rightAxis.axisLineColor = [UIColor colorWithHex:0x0b3659];
    rightAxis.drawGridLinesEnabled = YES;
    rightAxis.gridColor = [UIColor colorWithHex:0x0b3659 andAlpha:0.5];
    rightAxis.labelTextColor = [UIColor colorWithHex:0x909090];
    
    [self setChartsData];
}

- (void)setChartsData {
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (NSInteger i=1; i<=_modelList.count; i++)
    {
        ChartDataModel *model = _modelList[i-1];
        [values addObject:[[BarChartDataEntry alloc] initWithX:i y:[model.value floatValue]]];
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
        set1.valueColors = [_modelList subValueListWithKey:@"valueTextColor"];
        set1.valueFormatter = [[Bar2DataValueFormatter alloc] init];
        
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
        data.barWidth = 0.5;
        
        _chartView.data = data;
        
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }
}

#pragma mark - Delegate

- (void)actionMore:(ChartTopView *)chartTopView {
    
    BLOCK_EXEC(self.actionMoreBlock);
}

@end
