//
//  AccountBooksStaViewController.m
//  TiHouse
//
//  Created by gaodong on 2018/2/6.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AccountBooksStaViewController.h"
#import "PieView.h"
#import "ProgressView.h"

@interface AccountBooksStaViewController ()

@property (weak, nonatomic) UISegmentedControl *segmentedControl;
@property (retain, nonatomic) PieView *p;
@property (retain, nonatomic) ProgressView *progressV1;
@property (retain, nonatomic) ProgressView *progressV2;
@property (retain, nonatomic) ProgressView *progressV3;
@property (retain, nonatomic) ProgressView *progressV4;
@property (retain, nonatomic) ProgressView *progressV5;
@property (strong, nonatomic) NSMutableArray *classOneArr;

@property (assign, nonatomic) NSInteger paySum;
@property (assign, nonatomic) NSInteger refundSum;

@property (strong, nonatomic) NSMutableDictionary *payDic;
@property (strong, nonatomic) NSMutableDictionary *refundDic;

@property (nonatomic) BOOL isPay;

@end

@implementation AccountBooksStaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"账本统计";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.isPay = YES;
    self.classOneArr = [[NSMutableArray alloc] initWithCapacity:0];
    self.payDic = [[NSMutableDictionary alloc] initWithDictionary:@{@"人工":@0,@"主材":@0,@"软装":@0,@"入住":@0,@"其它":@0}];
    self.refundDic = [[NSMutableDictionary alloc] initWithDictionary:@{@"人工":@0,@"主材":@0,@"软装":@0,@"入住":@0,@"其它":@0}];
    
    //添加控件
    [self addSegementControl];
    [self addPieView];
    [self addProgressView];
    
    //统计数据
    [self countData:self.regionData];
    
    //刷新UI
    [self refreshUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
// addSegementControl
- (void)addSegementControl {
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"支出", @"退款"]];
    segment.frame = CGRectZero;
    [segment addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    segment.tintColor = XWColorFromHex(0xfec00c);
    UIColor *selectedColor = XWColorFromHex(0xffffff);
    UIColor *normalColor = XWColorFromHex(0x999999);
    [segment setTitleTextAttributes:@{NSForegroundColorAttributeName:normalColor} forState:UIControlStateNormal];
    [segment setTitleTextAttributes:@{NSForegroundColorAttributeName:selectedColor}forState:UIControlStateSelected];
    segment.selectedSegmentIndex = (0);
    [self.view addSubview:segment];
    [segment mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(116);
        make.height.mas_equalTo(26);
        make.top.mas_equalTo(self.view).offset(kNavigationBarHeight+15);
    }];
    self.segmentedControl = segment;
}

- (void)addPieView {
    self.p = [[PieView alloc] initWithFrame:CGRectMake(kScreen_Width/2-120, kNavigationBarHeight + 35, 240, 240)];
    self.p.clipsToBounds = YES;
    [self.view addSubview:self.p];
}

- (void)addProgressView {
    
    NSInteger Toppadding = kDevice_Is_iPhoneX? 360:330;
    
    self.progressV1 = [[ProgressView alloc] initWithFrame:CGRectMake(0, Toppadding, self.view.frame.size.width, 60)];
    self.progressV1.IconName = @"account_sum1";
    [self.view addSubview:self.progressV1];
    
    self.progressV2 = [[ProgressView alloc] initWithFrame:CGRectMake(0, Toppadding+60, self.view.frame.size.width, 60)];
    self.progressV2.IconName = @"account_sum2";
    [self.view addSubview:self.progressV2];
    
    self.progressV3 = [[ProgressView alloc] initWithFrame:CGRectMake(0, Toppadding+120, self.view.frame.size.width, 60)];
    self.progressV3.IconName = @"account_sum3";
    [self.view addSubview:self.progressV3];
    
    self.progressV4 = [[ProgressView alloc] initWithFrame:CGRectMake(0, Toppadding+180, self.view.frame.size.width, 60)];
    self.progressV4.IconName = @"account_sum4";
    [self.view addSubview:self.progressV4];
    
    self.progressV5 = [[ProgressView alloc] initWithFrame:CGRectMake(0, Toppadding+240, self.view.frame.size.width, 60)];
    self.progressV5.IconName = @"account_sum5";
    [self.view addSubview:self.progressV5];
    
}

#pragma mark - refreshUI
- (void)refreshUI{

    NSArray *nameArray = @[@"人工",@"主材",@"软装",@"入住",@"其它"];
    NSMutableArray *numArray = [[NSMutableArray alloc] initWithArray:@[@0,@0,@0,@0,@0]];
    float num = 0.0f;
    for (int i=0; i<5; i++) {
        if (self.segmentedControl.selectedSegmentIndex == 0) {
            num = fabs([[self.payDic objectForKey:nameArray[i]] doubleValue] / self.paySum * 100.00f);
            
        }else{
            num = [[self.refundDic objectForKey:nameArray[i]] doubleValue] / self.refundSum * 100.00f;
            
        }
        [numArray replaceObjectAtIndex:i withObject:@(num)];
    }

    [self.p drawPieWithNumbers:numArray price:@(self.isPay?self.paySum:self.refundSum) isPay:self.isPay];

    NSMutableDictionary *dic = self.segmentedControl.selectedSegmentIndex == 0?self.payDic:self.refundDic;
    [self.progressV1 updateWithTitle:nameArray[0]
                               Price:[[dic valueForKey:nameArray[0]] integerValue]
                             Percent:[numArray[0] integerValue]
                               isPay:self.isPay];
    
    [self.progressV2 updateWithTitle:nameArray[1]
                               Price:[[dic valueForKey:nameArray[1]] integerValue]
                             Percent:[numArray[1]integerValue]
                               isPay:self.isPay];
    
    [self.progressV3 updateWithTitle:nameArray[2]
                               Price:[[dic valueForKey:nameArray[2]] integerValue]
                             Percent:[numArray[2]integerValue]
                               isPay:self.isPay];
    
    [self.progressV4 updateWithTitle:nameArray[3]
                               Price:[[dic valueForKey:nameArray[3]] integerValue]
                             Percent:[numArray[3]integerValue]
                               isPay:self.isPay];
    
    [self.progressV5 updateWithTitle:nameArray[4]
                               Price:[[dic valueForKey:nameArray[4]] integerValue]
                             Percent:[numArray[4]integerValue]
                               isPay:self.isPay];
}

#pragma mark - action

- (void)segmentChange:(UISegmentedControl *)sender {
    // 明细类型，1支出2退款
    
    self.isPay = sender.selectedSegmentIndex==0? YES:NO;
    [self refreshUI];
}

#pragma mark - 统计算法
//排序
- (void)countData:(NSArray *)data{
    
    NSMutableArray *resultArray = [NSMutableArray array];
    NSInteger amountPay = 0;//计算支付总金额
    NSInteger amountRefund = 0;//计算退款总金额
    for (NSDictionary *dic in data) {
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        NSString *day = [NSDate timeStringFromTimestamp:[[dic valueForKey:@"tallyprotime"] integerValue] formatter:@"yyyy-MM-dd"];
        [tempDic addEntriesFromDictionary:@{@"tallyproday":day}];//添加一个转换日期格式字段，用于排序识别
        
        [resultArray addObject:tempDic];
        
        if ([[dic valueForKey:@"tallyprotype"] integerValue] == 1) {//支出 or 退款
            amountPay += [[dic valueForKey:@"doubleamountzj"] integerValue];
        }else{
            amountRefund += [[dic valueForKey:@"doubleamountzj"] integerValue];
        }
    }
    
    self.paySum = amountPay;
    self.refundSum = amountRefund;
    
    NSArray *indexArray = [resultArray valueForKey:@"cateonename"];
    NSSet *indexSet = [NSSet setWithArray:indexArray];//去重
    
    NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:nil ascending:NO]];
    NSArray *sortSetArray = [indexSet sortedArrayUsingDescriptors:sortDesc];//排序
    
    [self.classOneArr addObjectsFromArray:sortSetArray];
    
    [[indexSet allObjects] enumerateObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self.classOneArr count])]
                                             options:NSEnumerationConcurrent
                                          usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                              
      //支付
      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tallyprotype==1 AND cateonename == %@",obj];
      NSArray *indexArray = [resultArray filteredArrayUsingPredicate:predicate];
      NSInteger sum =[[indexArray valueForKeyPath:@"@sum.doubleamountzj"] integerValue];
      [self.payDic setValue:@(sum) forKey:obj];
      
      //退款
      NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"tallyprotype!=1 AND cateonename == %@",obj];
      NSArray *indexArray2 = [resultArray filteredArrayUsingPredicate:predicate2];
      NSInteger sum2 =[[indexArray2 valueForKeyPath:@"@sum.doubleamountzj"] integerValue];
      [self.refundDic setValue:@(sum2) forKey:obj];
    }];
    
}

@end
