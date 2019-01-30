//
//  GBPie2ChartViewController.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/20.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBPie2ChartViewController.h"
#import "YAHCharts-Swift.h"

#import "ChartDataModel.h"
#import "GBChartsLogic.h"

@interface GBPie2ChartViewController ()<
ChartTopViewDelegate>

@property (nonatomic, strong) IBOutlet PieChartView *chartView;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *colorViewList;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *nameLabelList;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *numberLabelList;

@property (nonatomic, strong) NSArray<ChartDataModel *> *modelList;


@end

@implementation GBPie2ChartViewController

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
    self.title = @"Pie2";
    [self setupBackButtonWithBlock:nil];
    self.topView.delegate = self;
    self.topView.textcColor = [UIColor colorWithHex:0xff0000];
    [self refreshUI];
}

- (void)refreshUI {
    
    [self setupChartView];
    for (NSInteger index=0; index<6; index++) {
        if (index<self.modelList.count) {
            ChartDataModel *model = _modelList[index];
            ((UIView *)self.colorViewList[index]).backgroundColor = model.valueColor;
            ((UILabel *)self.nameLabelList[index]).text = model.name;
            ((UILabel *)self.nameLabelList[index]).textColor = model.nameColor;
            ((UILabel *)self.nameLabelList[index]).font = model.nameFont;
            
            ((UILabel *)self.numberLabelList[index]).text = model.value.stringValue;
            ((UILabel *)self.numberLabelList[index]).textColor = model.valueTextColor;
            ((UILabel *)self.numberLabelList[index]).font = model.valueFont;
        }else {
            ((UIView *)self.colorViewList[index]).hidden = YES;
            ((UILabel *)self.nameLabelList[index]).hidden = YES;
            ((UILabel *)self.numberLabelList[index]).hidden = YES;
        }
    }
}

#pragma mark - Delegate

- (void)actionMore:(ChartTopView *)chartTopView {
    
    BLOCK_EXEC(self.actionMoreBlock);
}

#pragma mark - Private

- (void)setupChartView {
    
    _chartView.chartDescription.enabled = NO;
    _chartView.userInteractionEnabled = NO;
    _chartView.legend.enabled = NO;
    _chartView.holeColor = [UIColor clearColor];
    _chartView.transparentCircleRadiusPercent = 0;  //透明半径
    
    _chartView.maxAngle = 180.0; // Half chart
    _chartView.rotationAngle = 180.0; // Rotate to make the half on the upper side
    
    [self setChartsData];
    
}

- (void)setChartsData {
    
        
    NSMutableArray *values = [[NSMutableArray alloc] init];
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:_modelList.count];
    if (_modelList.count == 0 || [_modelList.firstObject.value floatValue]<=0) { //空圆
        [values addObject:[[PieChartDataEntry alloc] initWithValue:1]];
        [colors addObject:[UIColor colorWithHex:0x19191c]];
    }else {
        for (ChartDataModel *model in _modelList)
        {
            [values addObject:[[PieChartDataEntry alloc] initWithValue:[model.value floatValue]]];
            [colors addObject:model.valueColor];
        }
    }
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:values label:@""];
        
    dataSet.drawIconsEnabled = NO;
        
    dataSet.sliceSpace = 2;
    // add a lot of colors
    dataSet.colors = colors;
    
    
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    [data setDrawValues:NO];
    
    _chartView.data = data;
    
    [_chartView highlightValues:nil];
}

@end
