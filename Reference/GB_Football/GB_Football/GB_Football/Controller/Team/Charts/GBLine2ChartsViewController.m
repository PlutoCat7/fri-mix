//
//  TestLine2ChartsViewController.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/20.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBLine2ChartsViewController.h"
#import "YAHCharts-Swift.h"
#import "Line2xAxisValueFormatter.h"
#import "Line2DataValueFormatter.h"

@interface GBLine2ChartsViewController ()<
ChartTopViewDelegate>

@property (weak, nonatomic) IBOutlet LineChartView *lineChartView;

@property (nonatomic, strong) NSArray<ChartDataModel *> *modelList;

@end

@implementation GBLine2ChartsViewController

- (instancetype)initWithChartModelList:(NSArray<ChartDataModel *> *)modelList {
    
    self = [super init];
    if (self) {
        _modelList = modelList;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)setupUI {
    
    self.title = @"Line2";
    [self setupBackButtonWithBlock:nil];
    self.topView.delegate = self;
    self.topView.textcColor = [UIColor colorWithHex:0xdfa744];
    [self setupLineChart];
}

- (void)setupLineChart {
    
    _lineChartView.chartDescription.enabled = NO;
    _lineChartView.userInteractionEnabled = NO;
    _lineChartView.legend.enabled = NO;
    
    //设置X轴样式
    ChartXAxis *xAxis = self.lineChartView.xAxis;
    xAxis.axisLineWidth = 1.f;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelRotationAngle = -45;
    xAxis.drawGridLinesEnabled = NO;
    NSMutableArray *textColors = [NSMutableArray arrayWithArray:[_modelList subValueListWithKey:@"nameColor"]];
    [textColors insertObject:[UIColor clearColor] atIndex:0];
    [textColors addObject:[UIColor clearColor]];
    xAxis.labelTextColors = [textColors copy];
    NSMutableArray *textFontss = [NSMutableArray arrayWithArray:[_modelList subValueListWithKey:@"nameFont"]];
    [textFontss insertObject:[UIFont systemFontOfSize:10.0f] atIndex:0];
    [textFontss addObject:[UIFont systemFontOfSize:10.0f]];
    xAxis.labelTextColors = [textColors copy];
    xAxis.labelFonts = [_modelList subValueListWithKey:@"nameFont"];
    xAxis.valueFormatter = [[Line2xAxisValueFormatter alloc] initWithValues:[self.modelList subValueListWithKey:@"name"]];;
    xAxis.axisLineColor = [UIColor colorWithHex:0x0b3659];
    xAxis.labelCount = 2 + self.modelList.count;
    xAxis.forceLabelsEnabled = YES;
    
    //设置Y轴样式
    self.lineChartView.rightAxis.enabled = NO;
    
    ChartYAxis *leftAxis = _lineChartView.leftAxis;
    [leftAxis removeAllLimitLines];
    leftAxis.axisLineWidth = 1.f;
    leftAxis.axisMaximum = [self maxYValue];
    leftAxis.axisMinimum = 0.0;
    leftAxis.forceLabelsEnabled = NO;//不强制绘制指定数量的label
    leftAxis.drawGridLinesEnabled = YES;
    leftAxis.gridColor = [UIColor colorWithHex:0x0b3659 andAlpha:0.5];
    leftAxis.labelTextColor = [UIColor colorWithHex:0x909090];
    leftAxis.axisLineColor = [UIColor colorWithHex:0x0b3659];
    
    _lineChartView.rightAxis.enabled = NO;
    _lineChartView.legend.form = ChartLegendFormLine;
    
    [self setLineData];
    
}

- (CGFloat)maxYValue {
    
    CGFloat maxYValue = 0;
    if (self.modelList.firstObject.value.floatValue<=0) {
        maxYValue = 5;
    }else {
        maxYValue = self.modelList.firstObject.value.floatValue*1.4;
    }
    return maxYValue;
}

- (void)setLineData {
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:1];
    
    [values addObject:[[ChartDataEntry alloc] initWithX:0 y:0 icon:nil]];
    [colors addObject:[UIColor clearColor]];
    for (int i = 1; i <= self.modelList.count; i++)
    {
        [values addObject:[[ChartDataEntry alloc] initWithX:i y:[self.modelList[i-1].value floatValue] icon:[UIImage imageNamed:@"data_dian_b"]]];
        [colors addObject:self.modelList[i-1].valueTextColor];
    }
    [values addObject:[[ChartDataEntry alloc] initWithX:self.modelList.count+1 y:0 icon:nil]];
    [colors addObject:[UIColor clearColor]];
    
    LineChartDataSet *set1 = nil;
    if (_lineChartView.data.dataSetCount > 0)
    {
        set1 = (LineChartDataSet *)_lineChartView.data.dataSets[0];
        set1.values = values;
        [_lineChartView.data notifyDataChanged];
        [_lineChartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[LineChartDataSet alloc] initWithValues:values label:@""];
        
        set1.drawIconsEnabled = YES;
        set1.drawCirclesEnabled = NO;
        
        [set1 setColor:[UIColor colorWithHex:0xdfa744]];
        set1.lineWidth = 1.0;
        set1.valueFont = [UIFont systemFontOfSize:10.f];
        set1.valueColors = colors;
        set1.mode = LineChartModeCubicBezier;
        set1.valueFormatter = [[Line2DataValueFormatter alloc] init];
    
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        
        _lineChartView.data = data;
    }
}

#pragma mark - Delegate

- (void)actionMore:(ChartTopView *)chartTopView {
    
    BLOCK_EXEC(self.actionMoreBlock);
}

@end
