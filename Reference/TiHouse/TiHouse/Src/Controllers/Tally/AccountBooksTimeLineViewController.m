//
//  AccountBooksTimeLineViewController.m
//  TiHouse
//
//  Created by gaodong on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AccountBooksTimeLineViewController.h"
#import "AccountBooksEditViewController.h"
#import "AccountBooksSearchViewController.h"
#import "AccountBooksStaViewController.h"
#import "AccountBooksRecordViewController.h"
#import "AccountBooksViewController.h"
#import "HouseInfoViewController.h"
#import "BaseNavigationController.h"
#import "AddTallyViewController.h"
#import "TimeLineHeadView.h"
#import "TimeLineTableViewCell.h"
#import "AccountBooksWordAddViewController.h"
#import "UIButton+ImageTitleSpacing.h"
#import "CWNumberKeyboard.h"
#import <MJRefresh.h>
#import "Tally_NetAPIManager.h"
#import "Tally.h"
#import "TallyDetail.h"
#import "NSDate+Extend.h"
#import "TallyVoiceInputView.h"
#import "HLActionSheet.h"
#import "TallySharePan.h"
#import "AddBudgetBtn.h"
#import "Login.h"


static NSString *kCell = @"cell";
static NSString *kHeadview = @"headview";

@interface AccountBooksTimeLineViewController ()<UITableViewDelegate, UITableViewDataSource, TallyVoiceInputViewDelegate, TallySharePanDelegate>

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *listView;
@property (strong, nonatomic) NSMutableArray *regionListData;//账本明细 原始数据
@property (strong, nonatomic) NSMutableArray *listData;//账本明细 排序后的数据
@property (strong, nonatomic) NSMutableArray *dayArr;//分组日期

@property (retain, nonatomic) Tally *tallyInfo;
@property (retain, nonatomic) AddBudgetBtn *addBudgetBtn;

@property (assign, nonatomic) double numSumamount;//总支出
@property (assign, nonatomic) double numBudget;//预算
@property (assign, nonatomic) double numSurplus;//剩余

@property (weak, nonatomic) IBOutlet UILabel *lblSumamount;//总支出
@property (weak, nonatomic) IBOutlet UIButton *btnBudget;//预算
@property (weak, nonatomic) IBOutlet UILabel *lblSurplus;//剩余

@property (weak, nonatomic) IBOutlet UIButton *btnTopTitle;//顶部title& 显示金额
@property (strong, nonatomic) CWNumberKeyboard *numberKb;
@property (weak, nonatomic) UITextField *textFieldAmount;
@property (strong, nonatomic) UIAlertController *alertVc;

@property (weak, nonatomic) IBOutlet UIView *bottomView;//底部布局view
@property (weak, nonatomic) IBOutlet UIButton *btnLeftAdd;//手工记账btn
@property (weak, nonatomic) IBOutlet UIButton *btnMiddleAdd;//语音
@property (weak, nonatomic) IBOutlet UIButton *btnRightAdd;//智能输入


@property (strong, nonatomic)  TallySharePan *sharePan;//分享页面

@property (retain, nonatomic) UIImageView *noDataBG;

@property (nonatomic) BOOL showMoney;

@property (nonatomic, weak) TallyVoiceInputView *tallyVoiceInputView;

@end

@implementation AccountBooksTimeLineViewController

#pragma mark - init
+ (instancetype)initWithStoryboard {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AccountBooks" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"AccountBooksTimeLineViewController"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.title = @"装修账本";
    
    self.dayArr = [[NSMutableArray alloc] initWithCapacity:0];
    self.listData = [[NSMutableArray alloc] initWithCapacity:0];
    self.regionListData = [[NSMutableArray alloc] initWithCapacity:0];
    self.showMoney = YES;
    
    [self.listView registerClass:[TimeLineTableViewCell class] forCellReuseIdentifier:kCell];
    
    [self.btnLeftAdd layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:5];
    [self.btnRightAdd layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:5];
    
    self.bottomView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.bottomView.layer.shadowOffset = CGSizeMake(0,-1.5);
    self.bottomView.layer.shadowOpacity = 0.3;
    //隐藏语音智能记账功能
    self.bottomView.hidden = YES;
    
    UIButton *titleButton= [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 260, 30)];
    [titleButton setImage:[UIImage imageNamed:@"account_nav_eye"] forState:UIControlStateNormal];
    [titleButton setImage:[UIImage imageNamed:@"account_nav_eyehide"] forState:UIControlStateSelected];
    [titleButton setTitle:@"装修账本" forState:UIControlStateNormal];
    titleButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    [titleButton setTitleColor:XWColorFromHex(0x44444b) forState:UIControlStateNormal];
    [titleButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:3];
    [titleButton addTarget:self action:@selector(changeShowMoney:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleButton;
    self.btnTopTitle = titleButton;
    
    UIBarButtonItem *btnBackTimeline = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"account_nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backTimeline:)];
    UIBarButtonItem *btnBackAccountbooks = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"account_nav_menu"] style:UIBarButtonItemStyleDone target:self action:@selector(backAccountBooks:)];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:btnBackTimeline,btnBackAccountbooks, nil];
    
    UIBarButtonItem *btnMorefunc = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"account_nav_more"] style:UIBarButtonItemStyleDone target:self action:@selector(moreFunc:)];
    self.navigationItem.rightBarButtonItem = btnMorefunc;
    
    self.noDataBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"account_nodata"]];
    [self.view insertSubview:self.noDataBG belowSubview:self.listView];
    [self.noDataBG setHidden:YES];
    [self.noDataBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(279);
        make.center.mas_equalTo(self.view);
    }];
    
    [self getDetail];//获取账本详情
    [self getDetailList];//获取账本明细

}

//手工记账
-(void)goToNewBudgetVC{
    [self.tallyVoiceInputView removeFromSuperview];
    
    if (self.navigationController.navigationBar.hidden == YES) [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    
    WEAKSELF
    AddTallyViewController *vc = [AddTallyViewController initWithTallyId:self.tallyInfo.tallyid HouseId:self.tallyInfo.houseid House:_house type:AddTallyShowType_Input_Text];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    vc.completionBlock = ^{
        // 刷数据
        [weakSelf getDetail];//获取账本详情
        [weakSelf getDetailList];//获取账本明细
    };
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.tallyVoiceInputView != nil) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

#pragma mark - tableview
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    TimeLineHeadView *headView = [[TimeLineHeadView alloc] initWithFrame:CGRectZero];
    
    NSDate *d = [NSDate dateWithString:[self.dayArr objectAtIndex:section] format:@"yyyy-MM-dd"];
    
    headView.day.text = [NSString stringWithFormat:@"%lu月%lu日", d.month, d.day];
    headView.week.text = [NSString stringWithFormat:@"·%@", [NSDate dayFromWeekday:d]];
    headView.idx = (int)section;
    [headView setFrame:CGRectMake(0, 0, kScreen_Width, 40)];
    
    return headView;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TimeLineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCell];
    if (!cell) {
        cell = [[TimeLineTableViewCell alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 64)];
    }
    
    NSDictionary *dic = [[self.listData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    TallyDetail *tDetail = [TallyDetail mj_objectWithKeyValues:dic];
    cell.tDetail = tDetail;
    cell.showMoney = self.showMoney;
    [cell.Img setImage:nil];
    if ([tDetail.arrurlcert length] > 0) {
        NSArray *imgArr = [tDetail.arrurlcert componentsSeparatedByString:@","];
        if ([imgArr count] > 0) {
            [cell.Img sd_setImageWithURL:[NSURL URLWithString:imgArr[0]]];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSDictionary *dic = [[self.listData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    TallyDetail *tDetail = [TallyDetail mj_objectWithKeyValues:dic];
    return [TimeLineTableViewCell getCellHeightWithDetail:tDetail];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dayArr count];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self.listData objectAtIndex:section] count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *detail = [[self.listData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    WEAKSELF
    AddTallyViewController *vc = [AddTallyViewController initWithTallyId:self.tallyInfo.tallyid HouseId:self.tallyInfo.houseid House:_house type:AddTallyShowType_Show_Info];
    vc.tallyDetail = [TallyDetail mj_objectWithKeyValues:detail];
    vc.completionBlock = ^{
        // 刷数据
        [weakSelf getDetail];//获取账本详情
        [weakSelf getDetailList];//获取账本明细
    };
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}



#pragma mark - action
//显示自定义计算键盘
- (IBAction)showNumberPadAction:(UITextField *)sender {
    sender.inputView = [[UIView alloc] initWithFrame:CGRectZero];
    if (!_numberKb) {
        _numberKb = [[CWNumberKeyboard alloc] init];
        [[[UIApplication sharedApplication].windows lastObject] addSubview:_numberKb];
    }
    WEAKSELF
    [_numberKb setHidden:NO];
    [_numberKb showNumKeyboardViewAnimateWithTextField:sender andBlock:^(NSString *priceString) {
        [weakSelf saveAmount:[priceString floatValue]];
        [weakSelf.alertVc dismissViewControllerAnimated:YES completion:nil];
    }];
}
//返回时间轴
- (IBAction)backTimeline:(id)sender{
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[HouseInfoViewController class]]) {
            HouseInfoViewController *vc =(HouseInfoViewController *)controller;
            [self.navigationController popToViewController:vc animated:YES];
        }
    }

}
//返回账本
- (IBAction)backAccountBooks:(id)sender{
    AccountBooksViewController *vc = [AccountBooksViewController initWithStoryboard];
    if (self.house != nil) {
        vc.Houseid = self.house.houseid;
        vc.house = self.house;
    } else {
        vc.Houseid = _tallyInfo.houseid;
    }
    vc.stopRedirect = YES;
    
    //    AccountBooksStaViewController *vc = [[AccountBooksStaViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

//    [self.navigationController popViewControllerAnimated:YES];
}
//更多功能
- (IBAction)moreFunc:(id)sender{
    
    WEAKSELF
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"账本设置" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        AccountBooksEditViewController *vc = [AccountBooksEditViewController initWithStoryboard];
        vc.tDetail = weakSelf.tallyInfo;
        vc.completionBlock = ^(id data) {
            [weakSelf getDetail];
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [action setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"分享账本" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.sharePan showSharePanWithDelegate:self];
    }];
    [action1 setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"账本统计" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        AccountBooksStaViewController *vc = [[AccountBooksStaViewController alloc] init];
        vc.regionData = weakSelf.regionListData;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [action2 setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
    
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"修改记录" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        AccountBooksRecordViewController *vc = [AccountBooksRecordViewController initWithStoryboard];
        vc.Tallyid = weakSelf.Tallyid;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [action4 setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
    
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"删除账本" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf deleteTally];
    }];
    [action5 setValue:[UIColor redColor] forKey:@"_titleTextColor"];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [action3 setValue:XWColorFromHex(0x5186aa) forKey:@"_titleTextColor"];
    if (_house.houseisself != 1) {
        [alert addAction:action4];
        [alert addAction:action2];
        [alert addAction:action1];
        [alert addAction:action3];
    } else {
        [alert addAction:action4];
        [alert addAction:action];
        [alert addAction:action2];
        [alert addAction:action1];
        [alert addAction:action5];
        [alert addAction:action3];
    }

    [self presentViewController:alert animated:YES completion:nil];
    
}
//进入搜索界面
- (IBAction)clickBtnSearch:(UIButton *)sender {
    
    AccountBooksSearchViewController *vc = [AccountBooksSearchViewController initWithStoryboard];
    vc.tallyproArr = self.regionListData;
    [self.navigationController pushViewController:vc animated:YES];
    
}

//设置预算
- (IBAction)clickBtnBudget:(UIButton *)sender {
    
    _alertVc = [UIAlertController alertControllerWithTitle:@"请设置预算金额" message:nil preferredStyle:
                UIAlertControllerStyleAlert];
    
    
    
    WEAKSELF
    [_alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请填写                                  CNY(元)";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.font = [UIFont systemFontOfSize:14.f];
        [textField setValue:[NSNumber numberWithInt:8] forKey:@"paddingTop"];
        [textField setValue:[NSNumber numberWithInt:2] forKey:@"paddingLeft"];
        [textField setValue:[NSNumber numberWithInt:4] forKey:@"paddingBottom"];
        [textField setValue:[NSNumber numberWithInt:2] forKey:@"paddingRight"];
//        [textField addTarget:weakSelf action:@selector(showNumberPadAction:) forControlEvents:UIControlEventEditingDidBegin];
        weakSelf.textFieldAmount = textField;
        
    }];
    
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *inputAmount = weakSelf.textFieldAmount.text;
        
        [weakSelf saveAmount:[[inputAmount stringByReplacingOccurrencesOfString:@"￥" withString:@""] floatValue]];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [_alertVc addAction:action2];
    [_alertVc addAction:action1];
    [action1 setValue:XWColorFromHex(0x5186aa) forKey:@"_titleTextColor"];
    [action2 setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
    [self presentViewController:_alertVc animated:YES completion:^{
        [[weakSelf.textFieldAmount superview] superview].backgroundColor = [UIColor clearColor];
        [[weakSelf.textFieldAmount superview] superview].layer.borderColor = XWColorFromRGB(203, 203, 203).CGColor;
        [[weakSelf.textFieldAmount superview] superview].layer.borderWidth = 0.5f;

    }];
}

//手工记账
- (IBAction)clickLeftAdd:(UIButton *)sender {
    [self.tallyVoiceInputView removeFromSuperview];
    
    if (self.navigationController.navigationBar.hidden == YES) [self.navigationController setNavigationBarHidden:NO animated:NO];

    
    WEAKSELF
    AddTallyViewController *vc = [AddTallyViewController initWithTallyId:self.tallyInfo.tallyid HouseId:self.tallyInfo.houseid House:_house type:AddTallyShowType_Input_Text];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    vc.completionBlock = ^{
        // 刷数据
        [weakSelf getDetailList];//获取账本明细
    };
    [self presentViewController:nav animated:YES completion:nil];
}
// 语音记账 StartRecord
- (IBAction)clickMiddleAdd:(UIButton *)sender {
     if (self.tallyVoiceInputView != nil) {
        [self.tallyVoiceInputView startRecord];
     }else{
         TallyVoiceInputView *tallyVoiceInputView = [TallyVoiceInputView new];
         [self.view insertSubview:tallyVoiceInputView belowSubview:self.bottomView];
         self.tallyVoiceInputView = tallyVoiceInputView;
         self.tallyVoiceInputView.delegate = self;
         [tallyVoiceInputView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.edges.equalTo(self.view);
         }];
         
         [self.navigationController setNavigationBarHidden:YES animated:YES];
         [self.tallyVoiceInputView startRecord];
     }
}

// 停止录音
- (IBAction)recordStopAction:(id)sender {
    if (self.tallyVoiceInputView == nil) {
        TallyVoiceInputView *tallyVoiceInputView = [TallyVoiceInputView new];
        [self.view insertSubview:tallyVoiceInputView belowSubview:self.bottomView];
        self.tallyVoiceInputView = tallyVoiceInputView;
        self.tallyVoiceInputView.delegate = self;
        [tallyVoiceInputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    } else {
        [self.tallyVoiceInputView stopRecord];
    }
}

- (IBAction)cancelRecord:(id)sender {
    [self.tallyVoiceInputView cancelRecord];
}

//智能输入
- (IBAction)clickRightAdd:(UIButton *)sender {
    
    [self.tallyVoiceInputView removeFromSuperview];
    if (self.navigationController.navigationBar.hidden == YES) [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    WEAKSELF
    AccountBooksWordAddViewController *v = [AccountBooksWordAddViewController initWithStoryboard];
    v.completionBlock = ^(id data) {
        
        AddTallyViewController *vc = [AddTallyViewController initWithTallyId:weakSelf.tallyInfo.tallyid HouseId:self.tallyInfo.houseid House:_house type:AddTallyShowType_Input_Word];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        
        vc.completionBlock = ^{
            // 刷数据
            [weakSelf getDetailList];//获取账本明细
        };
        
        //智能文字转换完成跳转 手工添加页面
        TallyDetail *detail = [[TallyDetail alloc] init];
        detail.tallyprotype = [[data objectForKey:@"type"] intValue];
        detail.doubleamountzj = [[data objectForKey:@"amount"] floatValue];
        detail.tallyproremark = [data objectForKey:@"identifytext"];
        detail.cateoneid = [data[@"cateoneid"] integerValue];
        detail.catetwoid = [data[@"catetwoid"] integerValue];
        detail.catethreeid = [data[@"catethreeid"] integerValue];
        detail.tallyprotime = [data[@"identifytime"] integerValue];
        detail.isSynchronDate = [data[@"identifyresult"] boolValue];
        vc.tallyDetail = detail;
        [weakSelf presentViewController:nav animated:YES completion:nil];
    };
    [self presentViewController:v animated:YES completion:nil];
}

#pragma mark - ui setter
//显示隐藏金额
- (IBAction)changeShowMoney:(id)sender{
    
    UIButton *b = sender;
    [b setSelected:self.showMoney];
    self.showMoney = !self.showMoney;
    [self calculateBudget];
}

// 计算剩余预算&刷新ui
- (void)calculateBudget{
    
//    self.lblSumamount.text = self.showMoney?[NSString stringWithFormat:@"%.0lf",self.numSumamount]:@"****";
    self.lblSumamount.text = self.showMoney?[NSString stringWithFormat:@"%.0lf",_tallyInfo.tallyamountallhf / 100.0]:@"****";
    if (self.numBudget > 0) {
        [self.btnBudget setTitle:self.showMoney?[NSString stringWithFormat:@"%.0lf",self.numBudget]:@"****" forState:UIControlStateNormal];
    }
    
    double surplus = self.numBudget - self.numSumamount;
    self.lblSurplus.text = self.showMoney? [NSString stringWithFormat:@"%0.0lf", self.numBudget>0?surplus:0]:@"****";
    
    [self.listView reloadData];
}

#pragma mark - data
//保存总预算
- (void)saveAmount:(double)amount{
    WEAKSELF
    [[Tally_NetAPIManager sharedManager] request_TallySaveAmountWithTallyID:weakSelf.Tallyid Amount:amount Block:^(id data, NSError *error) {
        if (data) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"保存成功";
            [hud hideAnimated:YES afterDelay:1];
            
            weakSelf.numBudget = amount;
            [weakSelf calculateBudget];
        }
    }];
    
    if (amount == 0) {
        [self.btnBudget setTitle:@"点击设置" forState:UIControlStateNormal];
    }
}

//获取账本详情
- (void)getDetail{
    
    WEAKSELF
    [[Tally_NetAPIManager sharedManager] request_TallyDetailWithTallyID:weakSelf.Tallyid Block:^(id data, NSError *error) {
        if (data) {
            weakSelf.tallyInfo = data;
            if (weakSelf.tallyInfo.doubleamountzys > 0) {
                
                weakSelf.numBudget = weakSelf.tallyInfo.doubleamountzys;
                
            }
            [weakSelf calculateBudget];
            [weakSelf.btnTopTitle setTitle:weakSelf.tallyInfo.tallyname forState:UIControlStateNormal];
            [weakSelf.btnTopTitle layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:3];
            if (_tallyInfo.uidcreater == [Login curLoginUser].uid) {
                if (!_addBudgetBtn) {
                    _addBudgetBtn = [[AddBudgetBtn alloc]init];
                    _addBudgetBtn.Title.text = @"记一笔";
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToNewBudgetVC)];
                    [_addBudgetBtn addGestureRecognizer:tap];
                    [weakSelf.view addSubview:_addBudgetBtn];
                    [_addBudgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.bottom.equalTo(self.view);
                        make.height.equalTo(kDevice_Is_iPhoneX ? @(84) : @(50));
                    }];
                }
            }
        }
    }];
}


//获取账本详细数据
- (void)getDetailList{
    
    WEAKSELF
    [[Tally_NetAPIManager sharedManager] request_TallyInfoListWithTallyID:weakSelf.Tallyid Block:^(id data, NSError *error) {
        
        [weakSelf.dayArr removeAllObjects];
        [weakSelf.listData removeAllObjects];
        [weakSelf.regionListData removeAllObjects];
        
        if ([data count] > 0) {
            [weakSelf.regionListData addObjectsFromArray:data];
            [weakSelf sortListData:weakSelf.regionListData];

            [self.noDataBG setHidden:YES];
        }else{
            [self.noDataBG setHidden:NO];
            self.numSumamount = 0;
            [self calculateBudget];
        }
        [weakSelf.listView setContentOffset:CGPointMake(0,0) animated:NO];
        [weakSelf.listView reloadData];
    }];
}
//排序
- (void)sortListData:(NSArray *)data{
    
    NSMutableArray *resultArray = [NSMutableArray array];
    int amountSum = 0;//计算总金额使用
    for (NSDictionary *dic in data) {
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        NSString *day = [NSDate timeStringFromTimestamp:[[dic valueForKey:@"tallyprotime"] integerValue] formatter:@"yyyy-MM-dd"];
        [tempDic addEntriesFromDictionary:@{@"tallyproday":day}];//添加一个转换日期格式字段，用于排序识别
        
        [resultArray addObject:tempDic];
        
        if ([[dic valueForKey:@"tallyprotype"] integerValue] == 1) {//支出 or 退款
            amountSum += [[dic valueForKey:@"doubleamountzj"] integerValue];
        }else{
            amountSum -= [[dic valueForKey:@"doubleamountzj"] integerValue];
        }
        
    }
    self.numSumamount = amountSum;
    [self calculateBudget];
    
    NSArray *indexArray = [resultArray valueForKey:@"tallyproday"];
    NSSet *indexSet = [NSSet setWithArray:indexArray];//去重
    
    NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:nil ascending:NO]];
    NSArray *sortSetArray = [indexSet sortedArrayUsingDescriptors:sortDesc];//排序
    
    [self.dayArr addObjectsFromArray:sortSetArray];
    NSLog(@"dayArr: %@", self.dayArr);
    [[[NSSet setWithArray:sortSetArray] allObjects] enumerateObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self.dayArr count])]
                                             options:NSEnumerationConcurrent
                                          usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    
        //获取array
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tallyproday == %@", [self.dayArr objectAtIndex:idx]];
        NSArray *idxArr = [resultArray filteredArrayUsingPredicate:predicate];
        //倒序 排列
        NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:@"tallyprotime" ascending:NO]];
        NSArray *sortArray = [idxArr sortedArrayUsingDescriptors:sortDesc];
        NSLog(@"day:%@, count: %lu, idx:%lu", obj, [idxArr count], idx);
        [self.listData addObject:sortArray];
    }];
    
}

//删除
- (void)deleteTally{
    
    WEAKSELF
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"确定删除此账本吗？" message:nil preferredStyle:
                                  UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = @"正在删除";
        
        [[Tally_NetAPIManager sharedManager] request_TallyDeleteWithTallyID:self.Tallyid Block:^(id data, NSError *error) {
            if (data) {
                hud.mode = MBProgressHUDModeText;
                hud.label.text = [NSString stringWithFormat:@"删除成功"];
                [hud hideAnimated:YES afterDelay:1];
                [hud setCompletionBlock:^{
                    // 直接点账本进入删除时直接POP到时间轴
                    if (self.navigationController.viewControllers.count == 3 && [self.navigationController.viewControllers[2]  isKindOfClass:[AccountBooksTimeLineViewController class]]) {
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }
                    
                    for (UIViewController *controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[AccountBooksViewController class]]) {
                            AccountBooksViewController *vc =(AccountBooksViewController *)controller;
                            [weakSelf.navigationController popToViewController:vc animated:YES];
                        }
                    }
                    
                }];
            }else{
                
                [hud hideAnimated:YES];
            }
        }];
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVc addAction:action2];
    [alertVc addAction:action1];
    [action1 setValue:XWColorFromHex(0x5186aa) forKey:@"_titleTextColor"];
    [action2 setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
    [self presentViewController:alertVc animated:YES completion:nil];
        
    
    
    
    
}


#pragma mark - TallyVoiceInputViewDelegate

- (void)voiceFinish:(NSString *)soundFilePath {
    NSLog(@"%@", soundFilePath);
    // 上传音频文件
    NSData *data = [NSData dataWithContentsOfFile:soundFilePath];
    
    [data writeToFile:@"/Users/alienjunx/test.wav" atomically:YES];
    
    AddTallyViewController *vc = [AddTallyViewController initWithTallyId:self.tallyInfo.tallyid HouseId:self.tallyInfo.houseid House:_house type:AddTallyShowType_Input_Voice];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    
    WEAKSELF
    vc.completionBlock = ^{
        // 刷数据
        [weakSelf getDetailList];//获取账本明细
    };
    [[TiHouse_NetAPIManager sharedManager] uploadVoiceFile:data name:@"voice.wav" successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        if (responseObject) {
            NSInteger type = [responseObject[@"type"] integerValue];
            NSInteger amount = [responseObject[@"amount"] integerValue];
            TallyDetail *detail = [[TallyDetail alloc] init];
            detail.tallyproremark = responseObject[@"identifytext"];
            detail.cateoneid = [responseObject[@"cateoneid"] integerValue];
            detail.catetwoid = [responseObject[@"catetwoid"] integerValue];
            detail.catethreeid = [responseObject[@"catethreeid"] integerValue];
            detail.tallyprotime = [responseObject[@"identifytime"] integerValue];
            detail.isSynchronDate = [responseObject[@"identifyresult"] boolValue];
            detail.tallyprotype = type;
            detail.doubleamountzj = amount;
            vc.tallyDetail = detail;
            [weakSelf presentViewController:nav animated:YES completion:nil];
            [self.tallyVoiceInputView removeFromSuperview];
            if (self.navigationController.navigationBar.hidden == YES) [self.navigationController setNavigationBarHidden:NO animated:NO];
            
        } else {
            [self.tallyVoiceInputView recogError];
        }
    } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        
    } progerssBlock:^(CGFloat progressValue) {
        
    }];
}

#pragma mark - 分享功能

- (TallySharePan*)sharePan
{
    if (!_sharePan)
    {
        _sharePan = [[TallySharePan alloc] init];
        _sharePan.delegate = self;
    }
    return _sharePan;
}
// share delegate
- (void)TallySharePanAction:(TallySharePan*)pan tag:(SHARE_TYPE)tag
{
    if (tag == SHARE_TYPE_Favor) {
        
    } else if (tag == SHARE_TYPE_Download) {
        
    } else {
        [self clickShare:tag];
    }
    
}

- (void)TallySharePanActionCancel:(TallySharePan *)pan {
}

- (void)clickShare:(SHARE_TYPE)tag {
    
    NSString *platform;
    switch (tag)
    {
        case SHARE_TYPE_WECHAT:
        {
            platform = @"1";
        }
            break;
        case SHARE_TYPE_QQ:
        {
            platform = @"2";
        }
            break;
        case SHARE_TYPE_WEIBO:
        {
            platform = @"3";
        }
            break;
        default:
        {
            platform = @"4";
        }
            break;
    }
    
    
    @weakify(self)
    NSString *mainTitle;
    if (tag == SHARE_TYPE_WEIBO) {
        mainTitle = [NSString stringWithFormat:@"嘘~ “%@”的账本【%@】，悄悄给你看哦!%@",_house.housename, _tallyInfo.tallyname, _tallyInfo.linkshare];
    } else {
        mainTitle = [NSString stringWithFormat:@"嘘~ “%@”的账本【%@】，悄悄给你看哦!",_house.housename, _tallyInfo.tallyname];
    }
    NSString *subTitle;
    if (tag == SHARE_TYPE_QQ || tag == SHARE_TYPE_WECHAT) {
        subTitle = [NSString stringWithFormat:@"共%ld条流水，总支出%.2f元", _tallyInfo.numdetail, _tallyInfo.tallyamountallzc / 100.0];
    } else {
        subTitle = @"";
    }
    [[[UMShareManager alloc]init] webShare:tag title:mainTitle content:subTitle
                                       url:_tallyInfo.linkshare image:_house.urlshare complete:^(NSInteger state)
     {
         @strongify(self)
         switch (state) {
             case 0: {
                 [NSObject showHudTipStr:@"分享成功"];
                 [self.sharePan hide:^(BOOL ok){}];
                 
                 [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/inter/share/notifySuccess" withParams:@{@"type":@(4),@"typeid":@(self.Tallyid),@"platform":platform} withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
                     
                 }];
                 
             }break;

             case 1: {
                 [NSObject showHudTipStr:@"分享失败"];
                 [self.sharePan hide:^(BOOL ok){}];
             }break;
             default:
                 break;
         }
     }];
}

@end
