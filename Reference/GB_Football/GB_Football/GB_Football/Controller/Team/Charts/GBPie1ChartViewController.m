//
//  GBPie1ChartViewController.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/20.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBPie1ChartViewController.h"

#import "YAHCharts-Swift.h"
#import "ScreeningsTableViewCell.h"

#import "ChartDataModel.h"
#import "GBChartsLogic.h"

@interface GBPie1ChartViewController ()<
ChartTopViewDelegate>

@property (nonatomic, strong) IBOutlet PieChartView *chartView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray<ChartDataModel *> *modelList;

@end

@implementation GBPie1ChartViewController

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
    self.title = @"Pie1";
    [self setupBackButtonWithBlock:nil];
    self.topView.delegate = self;
    self.topView.textcColor = [UIColor colorWithHex:0x32b363];
    [self setupChartView];
    [self setupTableView];
}

- (void)setupChartView {
    
    _chartView.chartDescription.enabled = NO;
    _chartView.userInteractionEnabled = NO;
    _chartView.holeColor = [UIColor clearColor];
    
    ChartLegend *l = _chartView.legend;
    l.enabled = NO;
    
    [self setChartsData];
    
}

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ScreeningsTableViewCell" bundle:nil] forCellReuseIdentifier:@"ScreeningsTableViewCell"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor clearColor];
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
    
    dataSet.sliceSpace = 0;
    
    // add a lot of colors
    
    dataSet.colors = colors;
    
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    [data setValueTextColor:UIColor.clearColor];
    
    _chartView.data = data;
    [_chartView highlightValues:nil];
}

#pragma mark - Delegate

- (void)actionMore:(ChartTopView *)chartTopView {
    
    BLOCK_EXEC(self.actionMoreBlock);
}

#pragma mark - UITableViewDelegate

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelList.count;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScreeningsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScreeningsTableViewCell"];
    ChartDataModel *model = _modelList[indexPath.row];
    cell.colorSquare.backgroundColor = model.valueColor;
    cell.nameLabel.text = model.name;
    cell.nameLabel.textColor = model.nameColor;
    cell.nameLabel.font = model.nameFont;
    cell.timesLabel.text = model.value.stringValue;
    cell.timesLabel.textColor = model.nameColor;
    cell.timesLabel.font = model.nameFont;
    
    return cell;
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 25*kAppScale;
}

// section头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

@end
