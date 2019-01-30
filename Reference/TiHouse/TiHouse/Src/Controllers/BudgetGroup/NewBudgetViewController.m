//
//  BudgetDetailsViewController.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/22.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "NewBudgetViewController.h"
#import "AddHouseTableViewCell.h"
#import "AddressViewController.h"
#import "SelectHouseTypeViewController.h"
#import "OneKeyCreateViewController.h"
#import "AddresManager.h"
#import "House.h"
#import "Budgetpro.h"
//#import "SelectNewBudgetType.h"
//#import "NewBudgetPopView.h"


@interface NewBudgetViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) NSArray *UIModels;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *budgetNameField;
@property (nonatomic, strong) UITextField *budgetproField;
@property (nonatomic, strong) NSMutableDictionary *HouseTypeDic;
@property (nonatomic, retain) Budget *budget;
//@property (nonatomic, retain) SelectNewBudgetType *budgetType;
//@property (nonatomic, retain) NewBudgetPopView *pop;


@end

@implementation NewBudgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加预算";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(next)];
    _budget = [[Budget alloc]initWithHouse:_house];
//
//    _budgetType = [[SelectNewBudgetType alloc]initWithFrame:self.view.bounds];
//    _budgetType.delegate = self;
//    [self.view addSubview:_budgetType];
//
    self.UIModels = [UIHelp getNewBudgerUI];
    [self budgetNameField];
    [self budgetproField];
    [self tableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}




#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _UIModels.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UIModel *uimodel = _UIModels[indexPath.row];
    cell.Title.text = uimodel.Title;
    
    if (indexPath.row ==  0) {
        cell.topLineStyle = CellLineStyleFill;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.TextField.userInteractionEnabled = NO;
        cell.TextField.text = _house.addrdetail;
    }
    if (indexPath.row ==  1) {
        cell.TextField.keyboardType = UIKeyboardTypeDecimalPad;
        cell.TextField.delegate = self;
        NSString *areaStr = [NSString stringWithFormat:@"%ldm²",(long)self.house.area];
        cell.TextField.text = areaStr;
    }
    if (indexPath.row == 2) {
        cell.bottomLineStyle = CellLineStyleFill;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.TextField.userInteractionEnabled = NO;
        NSString *houseType = [NSString stringWithFormat:@"%ld室%ld厅%ld厨%ld卫%ld阳台",(long)self.house.numroom,(long)self.house.numhall,(long)self.house.numkichen,(long)self.house.numtoilet,(long)self.house.numbalcony];
        cell.TextField.text = houseType;
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kRKBHEIGHT(50.f);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        AddressViewController *addRess = [AddressViewController new];
        WEAKSELF
        addRess.finishAddres = ^(AddresManager *addres) {
            weakSelf.house.regionid = addres.region.regionid;
            AddHouseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.TextField.text = [NSString stringWithFormat:@"%@ %@ %@",addres.province.provname ? addres.province.provname : @"",addres.city.cityname ? addres.city.cityname : @"",addres.region.regionname ? addres.region.regionname : @""];
        };
        [self addChildViewController:addRess];
        addRess.view.frame = self.view.bounds;
        [self.view addSubview:addRess.view];
        [addRess showContent];
    }
    if (indexPath.row == 2) {
        SelectHouseTypeViewController *houseTypeVC = [SelectHouseTypeViewController new];
        WEAKSELF
        houseTypeVC.SelectedHouseType = ^(NSMutableDictionary *dic) {
            _HouseTypeDic = dic;
            AddHouseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            weakSelf.house.numroom = [dic[@"room"] integerValue];
            weakSelf.house.numhall = [dic[@"hall"] integerValue];
            weakSelf.house.numkichen = [dic[@"kitchen"] integerValue];
            weakSelf.house.numtoilet = [dic[@"toilet"] integerValue];
            weakSelf.house.numbalcony = [dic[@"balcony"] integerValue];
            cell.TextField.text = [NSString stringWithFormat:@"%@室%@厅%@厨%@卫%@阳台",dic[@"room"],dic[@"hall"],dic[@"kitchen"],dic[@"toilet"],dic[@"balcony"]];
        };
        if (!_HouseTypeDic) {
            _HouseTypeDic = [NSMutableDictionary new];
        }
        [_HouseTypeDic setValue:[NSString stringWithFormat:@"%ld",self.house.numroom] forKey:@"room"];
        [_HouseTypeDic setValue:[NSString stringWithFormat:@"%ld",self.house.numhall] forKey:@"hall"];
        [_HouseTypeDic setValue:[NSString stringWithFormat:@"%ld",self.house.numkichen] forKey:@"kitchen"];
        [_HouseTypeDic setValue:[NSString stringWithFormat:@"%ld",self.house.numtoilet] forKey:@"toilet"];
        [_HouseTypeDic setValue:[NSString stringWithFormat:@"%ld",self.house.numbalcony] forKey:@"balcony"];
        houseTypeVC.ValuesDic = _HouseTypeDic;
        [self.navigationController pushViewController:houseTypeVC animated:YES];
    }
    
    
}

// 隐藏UITableViewStyleGrouped下边多余的间隔
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01f;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30.f;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


#pragma mark - CustomDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.text = @"";
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField.text.length) {
        _house.area = [textField.text integerValue];
        textField.text = [NSString stringWithFormat:@"%@m²",textField.text];
    }else{
        textField.text = [NSString stringWithFormat:@"%ldm²",_house.area];
    }
    return YES;
}

//-(void)SelectNewBudgetTypeBtntag:(NSInteger)tag{
//    
//    if (tag == 10) {
//        XWLog(@"======从零开始做预算======");
//        _budget.type = 0;
//        [self addNewBudegt];
//        return;
//    }
//    if (tag == 11) {
//        XWLog(@"======一键生成预算表======");
//        _budget.type = 1;
//        _pop = [[NewBudgetPopView alloc]initWithType:(NewBudgetPopTyoeOneKye)];
//        _pop.delegate = self;
//        UIWindow *window = [UIApplication sharedApplication].keyWindow;
//        [window addSubview:_pop];
//        [_pop Show];
//        return;
//    }
//    if (tag == 12) {
//        XWLog(@"======什么是一键生成======");
//        NewBudgetPopView *pop = [[NewBudgetPopView alloc]initWithType:(NewBudgetPopTyoeWhatOneKye)];
//        UIWindow *window = [UIApplication sharedApplication].keyWindow;
//        [window addSubview:pop];
//        [pop Show];
//        
//        return;
//    }
//    
//}
//-(void)NewBudgetWithStyle:(NewBudgetStyle)Style{
//    
//    if (Style == NewBudgetStyleComfort) {
//        XWLog(@"======一键生成舒适版======");
//        _budget.type = 1;
//        _budget.lev = 1;
//        [self addNewBudegt];
//        return;
//    }
//    if (Style == NewBudgetStyleQuality) {
//        XWLog(@"======一键生成品质版======");
//        _budget.type = 1;
//        _budget.lev = 2;
//        [self addNewBudegt];
//        return;
//    }
//    if (Style == NewBudgetStyleExtravagant) {
//        XWLog(@"======一键生成豪华版======");
//        _budget.type = 1;
//        _budget.lev = 3;
//        [self addNewBudegt];
//        return;
//    }
//    
//}

#pragma mark - private methods 私有方法
-(void)next{
    [self.view endEditing:YES];
    _budget.budgetname = _budgetNameField.text;
    _budget.amountqwzj = [_budgetproField.text longLongValue];
    _budget.regionid = _house.regionid;
    _budget.area = _house.area;
    _budget.numroom = _house.numroom;
    _budget.numhall = _house.numhall;
    _budget.numkichen = _house.numkichen;
    _budget.numtoilet = _house.numtoilet;
    _budget.numbalcony = _house.numbalcony;
    
    if ([Budget TipStr:_budget].length) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"请填写您的房屋信息才能\n开始做预算哦！" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:nil];
        [alertVC addAction:action];
        [self presentViewController:alertVC animated:YES completion:nil];
        return;
    }
    OneKeyCreateViewController *oneKey = [OneKeyCreateViewController new];
    oneKey.budget = _budget;
    oneKey.house = _house;
    [self.navigationController pushViewController:oneKey animated:YES];
}




#pragma mark VC
- (void)goToNewBudgetVC{
    
}
//
//-(void)addNewBudegt{
//    if (_budget.isLoading) {
//        return;
//    }
//    WEAKSELF
//    [NSObject showHUDQueryStr:@"上传数据！"];
//    _budget.isLoading = YES;
//    [[TiHouse_NetAPIManager sharedManager]request_NewBudgetWithBudgets:_budget Block:^(id data, NSError *error) {
//        if (data) {
//            [weakSelf requestBudgetProWithBudget:data];
//        }else{
//            [NSObject hideHUDQuery];
//        }
//    }];
//}
//
//-(void)requestBudgetProWithBudget:(Budget *)budget{
//    WEAKSELF
//    [[TiHouse_NetAPIManager sharedManager]request_BudgetproWithBudgets:budget Block:^(id data, NSError *error) {
//        if (data) {
//            Budgetpro *budgetpro = data;
//            budget.house = weakSelf.house;
//            [weakSelf POPVC:budgetpro];
//        }else{
//            [NSObject hideHUDQuery];
//        }
//        
//    }];
//}
//
//-(void)POPVC:(Budgetpro *)budgetpro{
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"NEWBUDGETPRO" object:nil userInfo:@{@"budgetpro":budgetpro}];
//    for (UIViewController *controller in self.navigationController.viewControllers) {
//        if ([controller isKindOfClass:[BudgetDetailsPreviewViewController class]]) {
//            BudgetDetailsPreviewViewController *BudgetDetailsPreviewVC =(BudgetDetailsPreviewViewController *)controller;
//            [self.navigationController popToViewController:BudgetDetailsPreviewVC animated:YES];
//            [NSObject hideHUDQuery];
//        }
//    }
//}



#pragma mark - <懒加载>
-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = kRKBViewControllerBgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[AddHouseTableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.estimatedRowHeight = 50;
        _tableView.bounces = NO;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_budgetproField.mas_bottom).offset(20);
            make.bottom.right.left.equalTo(self.view);
        }];
    }
    return _tableView;
}

-(UITextField *)budgetNameField{
    if (!_budgetNameField) {
        
        UIView *BgView = [[UIView alloc] init];
        BgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:BgView];
        
        _budgetNameField = [[UITextField alloc]init];
        _budgetNameField.placeholder = @"请填写预算版本名称";
        _budgetNameField.font = [UIFont systemFontOfSize:16.0f];
        _budgetNameField.textColor = kTitleAddHouseCOLOR;
        
        UIView *bottomLine = [[UIView alloc] init];
        [bottomLine setBackgroundColor:kLineColer];
        [BgView addSubview:_budgetNameField];
        [BgView addSubview:bottomLine];
        [BgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(self.view);
            make.top.equalTo(self.view).mas_offset(UIEdgeInsetsMake(IphoneX ? 88 : 64, 0, 0, 0));
            make.height.equalTo(@(50));
        }];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.bottom.equalTo(BgView);
            make.height.equalTo(@(0.5));
        }];
        [_budgetNameField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(BgView).mas_offset(UIEdgeInsetsMake(0, 12, 0, -12));
        }];
        [_budgetNameField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _budgetNameField;
}

-(UITextField *)budgetproField{
    if (!_budgetproField) {
        
        UIView *BgView = [[UIView alloc] init];
        BgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:BgView];
        
        _budgetproField = [[UITextField alloc]init];
        _budgetproField.placeholder = @"请填写预算期望总价";
        _budgetproField.keyboardType = UIKeyboardTypeDecimalPad;
        _budgetproField.font = [UIFont systemFontOfSize:16.0f];
        _budgetproField.textColor = kTitleAddHouseCOLOR;
        
        UIView *bottomLine = [[UIView alloc] init];
        [bottomLine setBackgroundColor:kLineColer];
        UIView *topLine = [[UIView alloc] init];
        [topLine setBackgroundColor:kLineColer];
        [BgView addSubview:_budgetproField];
        [BgView addSubview:bottomLine];
        [BgView addSubview:topLine];
        [BgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(self.view);
            make.top.equalTo(_budgetNameField.mas_bottom).offset(10);
            make.height.equalTo(@(50));
        }];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.bottom.equalTo(BgView);
            make.height.equalTo(@(0.5));
        }];
        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.top.equalTo(BgView);
            make.height.equalTo(@(0.5));
        }];
        [_budgetproField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(BgView).mas_offset(UIEdgeInsetsMake(0, 12, 0, -12));
        }];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 50)];
        label.text = @"元";
        label.textColor = kTitleAddHouseCOLOR;
        _budgetproField.rightView = label;
        _budgetproField.rightViewMode = UITextFieldViewModeAlways;
        
    }
    return _budgetproField;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textDidChange:(UITextField *)textField {
    NSInteger kMaxLength = 12;
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange offset:0];
        if (!position) {
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        } else {
        }
    } else {
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
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

