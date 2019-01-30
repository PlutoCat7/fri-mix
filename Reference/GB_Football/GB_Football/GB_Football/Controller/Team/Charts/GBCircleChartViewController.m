//
//  GBCircleChartViewController.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/20.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBCircleChartViewController.h"
#import "CircleChartView.h"

#import "ChartDataModel.h"
#import "GBChartsLogic.h"

@interface GBCircleChartViewController ()<ChartTopViewDelegate>

@property (weak, nonatomic) IBOutlet CircleChartView *chartView;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *colorViewList;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *nameLabelList;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *numberLabelList;

@property (nonatomic, strong) NSArray<ChartDataModel *> *modelList;

@end

@implementation GBCircleChartViewController

- (instancetype)initWithChartModelList:(NSArray<ChartDataModel *> *)modelList {
    
    self = [super init];
    if (self) {
        _modelList = modelList;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Circle";
    [self setupBackButtonWithBlock:nil];
    self.topView.delegate = self;
    self.topView.textcColor = [UIColor colorWithHex:0x8a4dc3];
    [self refreshUI];
}

- (void)refreshUI {
    
    for (NSInteger index=0; index<6; index++) {
        if (index<_modelList.count) {
            ChartDataModel *model = _modelList[index];
            ((UIView *)self.colorViewList[index]).backgroundColor = model.valueColor;
            ((UILabel *)self.nameLabelList[index]).text = model.name;
            ((UILabel *)self.nameLabelList[index]).textColor = model.nameColor;
            ((UILabel *)self.nameLabelList[index]).font = model.nameFont;
            CGFloat distance = model.value.floatValue/1000;
            NSString *distanceString = @"";
            if (distance<1) {
                distanceString = @"<1KM";
            }else {
                distanceString = [NSString stringWithFormat:@"%.1fKM", model.value.floatValue/1000];
            }
            ((UILabel *)self.numberLabelList[index]).text = distanceString;
            ((UILabel *)self.numberLabelList[index]).textColor = model.valueTextColor;
            ((UILabel *)self.numberLabelList[index]).font = model.valueFont;
        }else {
            ((UIView *)self.colorViewList[index]).hidden = YES;
            ((UILabel *)self.nameLabelList[index]).hidden = YES;
            ((UILabel *)self.numberLabelList[index]).hidden = YES;
        }
        
    }
    [self.chartView refreshUI:self.modelList];
}

#pragma mark - Delegate

- (void)actionMore:(ChartTopView *)chartTopView {
    
    BLOCK_EXEC(self.actionMoreBlock);
}


@end
