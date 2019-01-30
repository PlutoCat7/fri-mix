//
//  GBEvaluationBoard.m
//  GB_Football
//
//  Created by Pizza on 2017/1/6.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBEvaluationBoard.h"
#import "XXNibBridge.h"
#import "GBReportCell.h"
#import "GBBarChart.h"
#import "GBAxiBar.h"
#import "GBEvalutionString.h"
#import "GBBorderButton.h"

@interface GBEvaluationBoard()<XXNibBridge,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *moveChartGroup;
@property (weak, nonatomic) IBOutlet UIView *moveAix;
@property (weak, nonatomic) IBOutlet UIView *speedChartGroup;
@property (weak, nonatomic) IBOutlet UIView *speedAix;
@property (strong, nonatomic) GBBarChart *moveChart;
@property (strong, nonatomic) GBBarChart *speedChart;
@property (strong, nonatomic) GBAxiBar *axiMoveBar;
@property (strong, nonatomic) GBAxiBar *axiSpeedBar;
@property (weak, nonatomic) IBOutlet UILabel *totalMoveLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxSpeedLabel;
@property (strong, nonatomic) BarChartModel *data;
@property (strong, nonatomic) MatchInfo* matchInfo;
// 体能消耗低于106.47不显示体能衰减 Cell
@property (assign,nonatomic) BOOL isBeyond106_47;
// Cell标题
@property (nonatomic,strong) NSArray<NSString*> *cellTitles;
// string容器
@property (nonatomic,strong) GBEvalutionString *evalutionString;
// 等级
@property (nonatomic,strong) NSMutableArray<NSNumber*> *level;
// 平均值
@property (nonatomic,strong) NSMutableArray<NSNumber*> *average;
// 成就查看
@property (weak, nonatomic) IBOutlet GBBorderButton *achievePopButton;

// 富文本标签
@property (weak, nonatomic) IBOutlet UILabel *stTimeDivLabelCh;
@property (weak, nonatomic) IBOutlet UILabel *stAnalyDivLabelCh;
@property (weak, nonatomic) IBOutlet UILabel *stTimeDivLabelEn;
@property (weak, nonatomic) IBOutlet UILabel *stAnalyDivLabelEn;

@property (weak, nonatomic) IBOutlet UILabel *stChartTitleMove;
@property (weak, nonatomic) IBOutlet UILabel *stChartTitleSpeed;
@property (weak, nonatomic) IBOutlet GBBorderButton *achiveButton;
    
@end

@implementation GBEvaluationBoard

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupUI];
}

-(void)setupUI{
    BOOL isEnglish = [[LanguageManager sharedLanguageManager] isEnglish];
    self.stTimeDivLabelCh.hidden   = isEnglish;
    self.stAnalyDivLabelCh.hidden  = isEnglish;
    self.stTimeDivLabelEn.hidden   = !isEnglish;
    self.stAnalyDivLabelEn.hidden  = !isEnglish;
    [self.achiveButton setTitle:LS(@"analyse.button.achievement") forState:UIControlStateNormal];
    [self.achiveButton setTitle:LS(@"analyse.button.disable") forState:UIControlStateDisabled];
    self.stChartTitleMove.text = LS(@"analyse.chart.move");
    self.stChartTitleSpeed.text = LS(@"analyse.chart.speed");
    
    CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(-15 * (CGFloat)M_PI / 180), 1, 0, 0);
    
    self.stChartTitleMove.transform = matrix;
    self.stChartTitleSpeed.transform = matrix;
    self.stTimeDivLabelCh.transform = matrix;
    self.stAnalyDivLabelCh.transform = matrix;
    
    [self.achievePopButton setupNomalTextColor:[UIColor greenColor] pressColor:[UIColor greenColor]];
    [self.achievePopButton setupNomalBorderColor:[UIColor colorWithHex:0x3f3f3f] pressColor:[UIColor colorWithHex:0x3f3f3f]];
    [self.achievePopButton setupNomalBackColor:[UIColor clearColor] pressColor:[UIColor blackColor]];
    [self.tableView registerNib:[UINib nibWithNibName:@"GBReportCell" bundle:nil] forCellReuseIdentifier:@"GBReportCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.isBeyond106_47 = YES;
    self.evalutionString = [[GBEvalutionString alloc]init];
    self.level = [[NSMutableArray alloc]initWithArray:@[@(0),@(0),@(0),@(0),@(0)]];
    self.average = [[NSMutableArray alloc]initWithArray:@[@(0.0),@(0.0),@(0.0)]];
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.cellTitles count];
}

-(NSString*)rtLabel:(NSString*)detail bold:(BOOL)bold{
    if (bold) {
        return [NSString stringWithFormat:@"<font size=16 color='#01FF00'>%@</font>",detail];
    }
    return [NSString stringWithFormat:@"<font size=16 color='#909090'>%@</font>",detail];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BOOL isEnglish = [[LanguageManager sharedLanguageManager] isEnglish];
    GBReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBReportCell"];
    cell.titleLabel.text = self.cellTitles[indexPath.row];
    switch (indexPath.row)
     {
         case 0:
         {
             NSString *chString = [NSString stringWithFormat:@"%@%@%@%@",
                                   self.evalutionString.distanceDescribe1[[self.level[indexPath.row] integerValue]],
                                   [self rtLabel:[NSString stringWithFormat:@"%.2f",[self.average[0] floatValue]]bold:NO],
                                   [self rtLabel:@"KM\n" bold:NO],
                                   self.evalutionString.distanceDescribe2[[self.level[indexPath.row] integerValue]]];
             NSString *enString = [NSString stringWithFormat:@"%@%@%@",
                                   LS(@"analyse.distance.english.head"),
                                   [self rtLabel:[NSString stringWithFormat:@"%.2f%@",[self.average[0] floatValue],@"KM"] bold:NO],
                                   self.evalutionString.distanceEnglish[[self.level[indexPath.row] integerValue]]];
             cell.contentLabel.text = isEnglish?enString:chString;
         }
             break;
         case 1:
         {
             NSString *chString =  [NSString stringWithFormat:@"%@%@%@%@",
                                  self.evalutionString.highspeedDescribe1[[self.level[indexPath.row] integerValue]],
                                  [self rtLabel:[NSString stringWithFormat:@"%.2f",[self.average[1] floatValue]]bold:NO],
                                  [self rtLabel:@"M/S\n" bold:NO],
                                  self.evalutionString.highspeedDescribe2[[self.level[indexPath.row] integerValue]]];
             NSString *enString = [NSString stringWithFormat:@"%@%@%@",
                                  LS(@"analyse.highspeed.english.head"),
                                  [self rtLabel:[NSString stringWithFormat:@"%.2f%@",[self.average[1] floatValue],@"M/S"] bold:NO],
                                  self.evalutionString.highspeedEnglish[[self.level[indexPath.row] integerValue]]];
             cell.contentLabel.text = isEnglish?enString:chString;
         }
             break;
         case 2:
         {
             NSInteger level = [self.level[indexPath.row] integerValue];
             NSString *chString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",
                                  self.evalutionString.calorieDescribe1[[self.level[indexPath.row] integerValue]],
                                  [self rtLabel:[NSString stringWithFormat:@"%.2f",[self.average[2] floatValue]]bold:NO],
                                  [self rtLabel:@"KCAL\n" bold:NO],
                                  self.evalutionString.calorieDescribe2[[self.level[indexPath.row] integerValue]],
                                  [self rtLabel:[self calToFoodName:self.matchInfo.globalData.consume] bold:NO],
                                  [self rtLabel:LS(@"analyse.food.label.burn") bold:NO],
                                  (level == 0 ? [self rtLabel:LS(@"analyse.food.label.need") bold:NO]:@"")
                                  ];
             NSString *enString = [NSString stringWithFormat:@"%@%@%@%@",
                                  LS(@"analyse.calorie.english.head"),
                                  [self rtLabel:[NSString stringWithFormat:@"%.2f%@",[self.average[2] floatValue],@"KCAL"] bold:NO],
                                  self.evalutionString.calorieEnglish[[self.level[indexPath.row] integerValue]],
                                  [self calToFoodName:self.matchInfo.globalData.consume]];
             cell.contentLabel.text = isEnglish?enString:chString;
         }
             break;
         case 3:
         {
             NSString *chString = [NSString stringWithFormat:@"%@%@",
                                    self.evalutionString.runpowerDescribe1[[self.level[indexPath.row] integerValue]],
                                    self.evalutionString.runpowerDescribe2[[self.level[indexPath.row] integerValue]]];
             NSString *enString = self.evalutionString.runpowerEnglish[[self.level[indexPath.row] integerValue]];
             cell.contentLabel.text = isEnglish?enString:chString;
         }
             break;
         case 4:
         {
            NSString *chString = [NSString stringWithFormat:@"%@%@",
                                self.evalutionString.decayDescribe1[[self.level[indexPath.row] integerValue]],
                                self.evalutionString.decayDescribe2[[self.level[indexPath.row] integerValue]]];
             NSString *enString = self.evalutionString.decayEnglish[[self.level[indexPath.row] integerValue]];
             cell.contentLabel.text = isEnglish?enString:chString;
         }
             break;
         default:
             break;
    }
    return cell;
}

-(void)drawChartWithBarChartModel:(BarChartModel*)barChartModel
{
    self.data = barChartModel;
    // 移动距离
    self.moveChart = [[GBBarChart alloc]initWithFrame:self.moveChartGroup.bounds];
    [self.moveChartGroup addSubview:self.moveChart];
    [self.moveChart showWithTopValue:self.data.topMove
                         bottomValue:self.data.axiXMove
                            progress:self.data.progressMove];
    self.axiMoveBar = [[GBAxiBar alloc]initWithFrame:self.moveAix.bounds];
    [self.moveAix addSubview:self.axiMoveBar];
    [self.axiMoveBar showWithTitles:self.data.axiYMove];
    // 最高速度
    self.speedChart = [[GBBarChart alloc]initWithFrame:self.speedChartGroup.bounds];
    [self.speedChartGroup addSubview:self.speedChart];
    [self.speedChart showWithTopValue:self.data.topSpeed
                          bottomValue:self.data.axiXSpeed
                             progress:self.data.progressSpeed];
    self.axiSpeedBar = [[GBAxiBar alloc]initWithFrame:self.speedAix.bounds];
    [self.speedAix addSubview:self.axiSpeedBar];
    [self.axiSpeedBar showWithTitles:self.data.axiYSpeed];
    // 图表表头峰值
    self.totalMoveLabel.text = [NSString stringWithFormat:@"%@KM",self.data.totalMove];
    self.maxSpeedLabel.text  = [NSString stringWithFormat:@"%@M/S",self.data.maxSpeed];
}

// 刷新表格
-(void)reloadTableWith:(MatchInfo*)info{
    self.achiveButton.enabled = info.achieve.display_type!= 0;
    self.matchInfo = [info copy];
    self.isBeyond106_47 = self.matchInfo.globalData.consume < 106.47 ? NO:YES;
    self.cellTitles = !self.isBeyond106_47?
    @[LS(@"analyse.distance.title"),LS(@"analyse.highspeed.title"),
      LS(@"analyse.calorie.title"),LS(@"analyse.runpower.title")]:
    @[LS(@"analyse.distance.title"),LS(@"analyse.highspeed.title"),
    LS(@"analyse.calorie.title"),LS(@"analyse.runpower.title"),LS(@"analyse.decay.title")];
    self.level[0] = @([self safeLevel:self.matchInfo.report.distance_level]);
    self.level[1] = @([self safeLevel:self.matchInfo.report.speed_level]);
    self.level[2] = @([self safeLevel:self.matchInfo.report.pc_level]);
    self.level[3] = @([self safeLevel:self.matchInfo.report.run_strong_level]);
    self.level[4] = @([self safeLevel:self.matchInfo.report.power_att_level]);
    self.average[0] = @(self.matchInfo.report.average_distance/1000);
    self.average[1] = @(self.matchInfo.report.average_speed);
    self.average[2] = @(self.matchInfo.report.average_pc);
    [self.tableView reloadData];
}

// 服务端等级转变成本地等级
-(NSInteger)safeLevel:(NSInteger)server
{
    if (server <= 0) {
        return 1;
    }
    return (server - 1) ;
}

- (NSString *)toKmString:(CGFloat)distance{
    return [NSString stringWithFormat:@"%.2f", distance/1000];
}

- (IBAction)actionPressAchieve:(id)sender {
  BLOCK_EXEC(self.actionClickAchivement);
}

// 食物等级计算
-(NSString*)calToFoodName:(CGFloat)cal
{
    NSArray *calFoodTable =  @[@(0.f), @(30.f),@(60.f),@(100.f),@(150.f),@(200.f),@(300.f),@(400.f),@(500.f),@(650.f),@(800.f),@(1000.f),@(99999.f)];
    NSInteger level = 0;
    for (int i = 0 ; i < [calFoodTable count]; i++) {
        if (cal > [calFoodTable[i] floatValue] && cal <= [calFoodTable[i+1] floatValue])
         {
            level = i;
            break;
        }
    }
    return self.evalutionString.foodName[level];
}

-(void)showBarChartAnimation
{
    [self.moveChart showProgressWithAnimation];
    [self.speedChart showProgressWithAnimation];
}
@end
