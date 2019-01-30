//
//  OneKeyCreateViewController.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/2/8.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "OneKeyCreateViewController.h"
#import "BudgetDetailsPreviewViewController.h"
#import "SelectNewBudgetType.h"
#import "NewBudgetPopView.h"

@interface OneKeyCreateViewController()<SelectNewBudgetTypeDelegate,NewBudgetPopViewDelegate>

@property (nonatomic, retain) SelectNewBudgetType *budgetType;
@property (nonatomic, retain) NewBudgetPopView *pop;

@end

@implementation OneKeyCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加预算";
    _budgetType = [[SelectNewBudgetType alloc]initWithFrame:self.view.bounds];
    _budgetType.delegate = self;
    [self.view addSubview:_budgetType];
    [_budgetType Show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)SelectNewBudgetTypeBtntag:(NSInteger)tag{
    
    if (tag == 10) {
        XWLog(@"======从零开始做预算======");
        _budget.type = 0;
        [self addNewBudegt];
        return;
    }
    if (tag == 11) {
        XWLog(@"======一键生成预算表======");
        _budget.type = 1;
        _pop = [[NewBudgetPopView alloc]initWithType:(NewBudgetPopTyoeOneKye)];
        _pop.delegate = self;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:_pop];
        [_pop Show];
        return;
    }
    if (tag == 12) {
        XWLog(@"======什么是一键生成======");
        NewBudgetPopView *pop = [[NewBudgetPopView alloc]initWithType:(NewBudgetPopTyoeWhatOneKye)];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:pop];
        [pop Show];
        
        return;
    }
    
}
-(void)NewBudgetWithStyle:(NewBudgetStyle)Style{
    
    //1经济 2品质 3轻奢 4舒适
    if (Style == NewBudgetStyleComfort) {
        XWLog(@"======一键生成舒适版======");
        _budget.type = 1;
        _budget.lev = 4;
        [self addNewBudegt];
        return;
    }
    if (Style == NewBudgetStyleQuality) {
        XWLog(@"======一键生成品质版======");
        _budget.type = 1;
        _budget.lev = 2;
        [self addNewBudegt];
        return;
    }
    if (Style == NewBudgetStyleExtravagant) {
        XWLog(@"======一键生成轻奢版======");
        _budget.type = 1;
        _budget.lev = 3;
        [self addNewBudegt];
        return;
    }
    if (Style == NewBudgetStyleEconomic)
    {
        XWLog(@"======一键生成经济版======");
        _budget.type = 1;
        _budget.lev = 1;
        [self addNewBudegt];
        return;
    }
}



-(void)addNewBudegt{
    if (_budget.isLoading) {
        return;
    }
    WEAKSELF
    [NSObject showHUDQueryStr:@"上传数据！"];
    _budget.isLoading = YES;
    [[TiHouse_NetAPIManager sharedManager]request_NewBudgetWithBudgets:_budget Block:^(id data, NSError *error) {
        if (data) {
            [weakSelf requestBudgetProWithBudget:data];
        }else{
            [NSObject hideHUDQuery];
        }
    }];
}

-(void)requestBudgetProWithBudget:(Budget *)budget{
    WEAKSELF
    [[TiHouse_NetAPIManager sharedManager]request_BudgetproWithBudgets:budget Block:^(id data, NSError *error) {
        if (data) {
            Budgetpro *budgetpro = data;
            budgetpro.budget = budget;
            budget.house = weakSelf.house;
            [weakSelf POPVC:budgetpro];
        }else{
            [NSObject hideHUDQuery];
        }
        
    }];
}

-(void)POPVC:(Budgetpro *)budgetpro{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"NEWBUDGETPRO" object:nil userInfo:@{@"budgetpro":budgetpro}];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[BudgetDetailsPreviewViewController class]]) {
            BudgetDetailsPreviewViewController *BudgetDetailsPreviewVC =(BudgetDetailsPreviewViewController *)controller;
            [self.navigationController popToViewController:BudgetDetailsPreviewVC animated:YES];
            [NSObject hideHUDQuery];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
