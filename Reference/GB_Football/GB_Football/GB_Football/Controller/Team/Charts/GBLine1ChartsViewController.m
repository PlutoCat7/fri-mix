//
//  TestLineChartsViewController.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/16.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBLine1ChartsViewController.h"
#import "YAHCharts-Swift.h"

#import "THLabel.h"

@interface GBLine1ChartsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet THLabel *scoreLabel;

@property (weak, nonatomic) IBOutlet LineChartView *lineChartView;

@property (nonatomic, strong) NSArray<NSString *> *scoreList;

@end

@implementation GBLine1ChartsViewController

- (instancetype)initWithScoreList:(NSArray<NSString *> *)scoreList {
    
    self = [super init];
    if (self) {
        _scoreList = scoreList;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)localizeUI {
    
    self.titleLabel.text = LS(@"team.data.T-Goal.team.index");
}

- (void)setupUI {
    
    self.title = @"Line";
    [self setupBackButtonWithBlock:nil];
    [self setupScoreLabel];
    [self setupLineChart];
}

- (void)setupScoreLabel {
    
    self.scoreLabel.gradientStartColor = [UIColor whiteColor];
    self.scoreLabel.gradientEndColor = [UIColor colorWithHex:0xe98315];
    self.scoreLabel.font = [UIFont fontWithName:@"BEBAS" size:45.0f*kAppScale];
    self.scoreLabel.text = self.scoreList.lastObject;
    self.scoreLabel.textAlignment = NSTextAlignmentCenter;
    self.scoreLabel.shadowColor = [UIColor colorWithHex:0x0d131c];
    self.scoreLabel.shadowOffset = CGSizeMake(0, 5.f);
    [self.scoreLabel setShadowBlur:2.f];
}

- (void)setupLineChart {
    
    _lineChartView.chartDescription.enabled = NO;
    _lineChartView.userInteractionEnabled = NO;
    _lineChartView.legend.enabled = NO;
    
    //设置X轴样式
    ChartXAxis *xAxis = self.lineChartView.xAxis;
    xAxis.enabled = NO;
    xAxis.drawGridLinesEnabled = NO;
    xAxis.labelCount = 7;
    xAxis.axisMinValue = 0;
    xAxis.axisMaxValue = 1;
    
    //设置Y轴样式
    self.lineChartView.rightAxis.enabled = NO;
    
    ChartYAxis *leftAxis = _lineChartView.leftAxis;
    leftAxis.enabled = NO;
    [leftAxis removeAllLimitLines];
    leftAxis.axisMaximum = [self maxYValue];
    leftAxis.axisMinimum = 0.0;
    leftAxis.drawGridLinesEnabled = NO;
    //leftAxis.zeroLineDashPhase = 20.f;
    //leftAxis.drawLimitLinesBehindDataEnabled = YES;
    
    _lineChartView.rightAxis.enabled = NO;
    _lineChartView.legend.form = ChartLegendFormLine;
    
    [self setLineData];
    
}

- (CGFloat)maxYValue {
    
    CGFloat maxYValue = 0;
    for (NSString *score in _scoreList) {
        if (score.floatValue>maxYValue) {
            maxYValue = score.floatValue;
        }
    }
    return maxYValue*1.3;
}

- (void)setLineData {
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    NSArray *valueList = @[@(0), @(60.f/750), @(210.f/750), @(352.f/750), @(460.f/750), @(604.f/750), @(1)];
    for (int i = 0; i < 7; i++)
    {
        [values addObject:[[ChartDataEntry alloc] initWithX:[valueList[i] floatValue] y:[self.scoreList[i] floatValue] icon:(i==0||i==1||i==6)?nil:[UIImage imageNamed:@"data_dian_a"]]];
    }
    
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
        set1 = [[LineChartDataSet alloc] initWithValues:values label:nil];
        
        set1.drawIconsEnabled = YES;
        set1.drawCirclesEnabled = NO;
        
        [set1 setColor:[UIColor colorWithHex:0x16427a andAlpha:0.8]];
        set1.lineWidth = 1.0f;
        set1.valueColors = @[[UIColor clearColor],
                             [UIColor clearColor],
                             [UIColor colorWithHex:0x424756],
                             [UIColor colorWithHex:0x424756],
                             [UIColor colorWithHex:0x424756],
                             [UIColor colorWithHex:0x424756],
                             [UIColor clearColor]];
        set1.valueFont = [UIFont fontWithName:@"BEBAS" size:15.0f*kAppScale];
        set1.mode = LineChartModeCubicBezier;
        
        NSArray *gradientColors = @[(id)[UIColor colorWithHex:0x0b3659 andAlpha:0.1].CGColor,
                                    (id)[UIColor colorWithHex:0x0b3659 andAlpha:0.3].CGColor];
        CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
        
        set1.fillAlpha = 1.f;
        set1.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
        set1.drawFilledEnabled = YES;
        
        CGGradientRelease(gradient);
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        
        _lineChartView.data = data;
    }
}

@end
