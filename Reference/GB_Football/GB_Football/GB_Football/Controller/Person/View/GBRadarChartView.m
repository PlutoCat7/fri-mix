//
//  GBRadarChartView.m
//  GB_Football
//
//  Created by yahua on 2017/10/20.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBRadarChartView.h"
#import "YAHCharts-Swift.h"

@interface GBRadarChartView() <IChartAxisValueFormatter>

@property (weak, nonatomic) IBOutlet RadarChartView *radarChartView;

@end

@implementation GBRadarChartView

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (void)setDatas:(NSArray<NSNumber *> *)datas {
    
    [self setupRadarChatView:datas];
    
}

#pragma mark - Private

- (void)setupRadarChatView:(NSArray<NSNumber *> *)datas {
    
    //self.radarChartView.backgroundColor = [UIColor colorWithHex:0x292f3f andAlpha:0.2];
    self.radarChartView.highlightPerTapEnabled = NO;
    self.radarChartView.rotationEnabled = NO;
    
    self.radarChartView.chartDescription.enabled = NO;
    self.radarChartView.noDataText = @"";
    
    self.radarChartView.webLineWidth = 0.5;//主干线线宽
    self.radarChartView.webColor = [UIColor colorWithHex:0x898989 andAlpha:0.2];//主干线线宽
    self.radarChartView.innerWebLineWidth = 0.5;//边线宽度
    self.radarChartView.innerWebColor = [UIColor colorWithHex:0x898989 andAlpha:0.2];//边线颜色
    self.radarChartView.webAlpha = 1.0;//透明度
    
    //self.radarChartView.marker = nil;
    
    ChartXAxis *xAxis = self.radarChartView.xAxis;
    xAxis.labelFont = [UIFont systemFontOfSize:10];//字体
    xAxis.labelTextColor = [UIColor colorWithHex:0x595a63];
    xAxis.valueFormatter = self;
    xAxis.xOffset = 0.0;
    xAxis.yOffset = 0.0;
    
    
    ChartYAxis *yAxis = self.radarChartView.yAxis;
    yAxis.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:9.f];
    yAxis.labelCount = 5;// label 个数
    yAxis.axisMinValue = 0.0;//最小值
    yAxis.axisMaxValue = 80.0;//最大值
    yAxis.drawLabelsEnabled = NO;//是否显示 label
    //    yAxis.labelFont = [UIFont systemFontOfSize:10];// label 字体
    //    yAxis.labelTextColor = [UIColor colorWithHex:0x595a63];// label 颜色
    self.radarChartView.legend.enabled = NO;
    
    [self setRadarChartData:datas];
    
    [_radarChartView animateWithYAxisDuration:1.0f easingOption:ChartEasingOptionEaseOutBack];
}

- (void)setRadarChartData:(NSArray<NSNumber *> *)valueData {
    
    //每个维度的数据
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    for (int i = 0; i < valueData.count; i++) {
        RadarChartDataEntry *entry = [[RadarChartDataEntry alloc] initWithValue:valueData[i].doubleValue];
        [yVals1 addObject:entry];
    }
    
    // dataSet
    RadarChartDataSet *set1 = [[RadarChartDataSet alloc] initWithValues:yVals1 label:@""];
    set1.lineWidth = 1.5;//数据折线线宽
    [set1 setColor:[UIColor colorWithHex:0x1f4e8a]];//数据折线颜色
    set1.drawFilledEnabled = YES;//是否填充颜色
    set1.fillColor = [UIColor colorWithHex:0x1f4e8a];//填充颜色
    set1.fillAlpha = 0.3;//填充透明度
    //set1.drawValuesEnabled = NO;//是否绘制显示数据
    set1.drawHighlightCircleEnabled = YES;
    [set1 setDrawHighlightIndicators:NO];
    
    //data
    RadarChartData *data = [[RadarChartData alloc] initWithDataSets:@[set1]];
    [data setDrawValues:NO];
    [data setValueFont:[UIFont systemFontOfSize:10.0f*kAppScale]];
    [data setValueTextColor:[UIColor colorWithHex:0x595a63]];
    
    
    self.radarChartView.data = data;
}

#pragma mark - IAxisValueFormatter

- (NSString *)stringForValue:(double)value
                        axis:(ChartAxisBase *)axis
{
    NSArray *xVals = @[LS(@"starcard.label.area"), LS(@"starcard.label.distance"), LS(@"starcard.label.sprint"), LS(@"starcard.label.erupt"), LS(@"starcard.label.endur"), LS(@"starcard.label.speed")];
    return xVals[(int) value % xVals.count];
}

@end
