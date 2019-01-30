//
//  BudgetDetailsViewController.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/22.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BudgetDetailsPreviewViewController.h"
#import "BudgetDetailsPreviewTabbleHeader.h"
#import "BudgetDetailsTabbleHeaderView.h"
#import "BudgetPreviewTableViewCell.h"
#import "BudgetDetailsViewController.h"
#import "NewBudgetViewController.h"
#import "BudgetListViewController.h"
#import "Budget.h"
#import "House.h"
#import "ScreenPopView.h"
#import "PriceSortPopView.h"
#import "BudgetDetailSort.h"
#import "AddBudgetBtn.h"
#import "BudgetOneClass.h"
#import "BudgetTwoClass.h"
#import "BudgetThreeClass.h"
#import "Login.h"
#import "BaseNavigationController.h"
#import "GBSharePan.h"
static NSString *noAuthorizationString = @"您没有权限查看此房屋";

@interface BudgetDetailsPreviewViewController ()<UITableViewDelegate, UITableViewDataSource, GBSharePanDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BudgetDetailsPreviewTabbleHeader *tableHeaderView;
@property (nonatomic, strong) AddBudgetBtn *addBudgetBtn;
@property (nonatomic, retain) BudgetDetailsViewController * BudgetDetailsVC;
@property (strong, nonatomic) UITextField *TextField;
@property (strong, nonatomic) GBSharePan *sharePan;

@end

@implementation BudgetDetailsPreviewViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [(BaseNavigationController *)self.navigationController hideNavBottomLine];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (_budget) {
        //初始化数据
        [self request_Budgetpro];
//        [[NSUserDefaults standardUserDefaults] setValue:_budget forKey:@"lastbudget"];
    }else{
        //请求最新修改
        [self request_LatestBudgetWithHouse];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newBudgetpor:) name:@"NEWBUDGETPRO" object:nil];
}

-(void)setupNavBar{
    
    UIImage *shareImage = [[UIImage imageNamed:@"budget_ share_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *share=[[UIBarButtonItem alloc] initWithImage:shareImage style:UIBarButtonItemStylePlain target:self action:@selector(BarBtnShare)];
    self.navigationItem.rightBarButtonItem = share;
    
    UIImage *listImage = [[UIImage imageNamed:@"budget_block_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftone=[[UIBarButtonItem alloc] initWithImage:listImage style:UIBarButtonItemStylePlain target:self action:@selector(BarBtnBlock)];
    UIImage *blockImage = [[UIImage imageNamed:@"budget_list_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *lefttwo=[[UIBarButtonItem alloc] initWithImage:blockImage style:UIBarButtonItemStylePlain target:self action:@selector(BarBtnList)];
    lefttwo.imageInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:leftone,lefttwo, nil]];
    
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _budgetpro.cateoneList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BudgetPreviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.oneClass = _budgetpro.cateoneList[indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [BudgetPreviewTableViewCell GetCellHightWhitOneClass:_budgetpro.cateoneList[indexPath.row]];
}




-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    BudgetDetailSort *sortView = [[BudgetDetailSort alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 50)];
    sortView.titleView.textColor = XWColorFromHex(0xfec00c);
    sortView.titleView.text = [NSString stringWithFormat:@"预算总价：¥%@",
                               [self moneyFormat:[NSString stringWithFormat:@"%.0f",_budgetpro.budgetproamount / 100.0f]]];
//    sortView.titleView.text = [NSString stringWithFormat:@"预算总价：¥%.0f",_budgetpro.budgetproamount];
    [sortView.sortBtn addTarget:self action:@selector(PopSort) forControlEvents:UIControlEventTouchUpInside];
    [sortView.screenBtn addTarget:self action:@selector(PopScreen) forControlEvents:UIControlEventTouchUpInside];
    //修饰线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, kScreen_Width, 0.5)];
    line.backgroundColor = XWColorFromHex(0xdbdbdb);
    [sortView addSubview:line];
    return sortView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0f;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.f;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - CustomDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int contentOffsety = scrollView.contentOffset.y;
    if (-contentOffsety > 100) {
        _tableView.contentOffset = CGPointMake(0, -100);
    }
    
    //NavBar背景色渐变
    [self wr_setNavBarBarTintColor:XWColorFromHexAlpha(0xfdf086,(contentOffsety-55)/50.0)];
    if (contentOffsety < 55) {
        [self wr_setNavBarTintColor:[UIColor clearColor]];
//        self.title = @"";
        self.navigationItem.titleView = nil;
    }else{
        [self wr_setNavBarTintColor:kRKBNAVBLACK];
//        self.title = _budgetpro.budgetname;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 64)];
        view.backgroundColor = [UIColor clearColor];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [view addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(view);
            make.height.equalTo(@(25));
        }];
        titleLabel.text = [NSString stringWithFormat:@"  %@  ", _budgetpro.budgetname];
        titleLabel.textColor = kRKBNAVBLACK;
        titleLabel.font = [UIFont boldSystemFontOfSize:19];
//        titleLabel.layer.borderWidth = 2;
//        titleLabel.layer.borderColor = [UIColor blackColor].CGColor;
        self.navigationItem.titleView = view;
    }
    if (contentOffsety > _tableHeaderView.height-kNavigationBarHeight) {
        _tableView.contentInset = UIEdgeInsetsMake(kNavigationBarHeight, 0, 50, 0);
    }else{
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    }
    
}

#pragma mark - private methods 私有方法
-(void)request_LatestBudgetWithHouse{
    [self.view beginLoading];
    WEAKSELF
    [[TiHouse_NetAPIManager sharedManager] request_LatestBudgetWithHouse:_house Block:^(id data, NSError *error) {
        if (data) {
            if ([data isKindOfClass:[NSString class]] && [data isEqualToString:noAuthorizationString]) {
                [weakSelf.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
                return;
            }
            Budget *budget = data;
            [weakSelf requestBudgetProWithBudget:budget];
        }else{
            [weakSelf.view endLoading];
            [weakSelf.view configBlankPage:EaseBlankPageTypeBudet hasData:NO hasError:NO offsetY:kDevice_Is_iPhoneX?88:64 reloadButtonBlock:^(id sender) {
            }];
//            weakSelf.title = @"预算列表";
            //空白页按钮事件
            weakSelf.view.blankPageView.clickButtonBlock=^(EaseBlankPageType curType) {
                if (_house.uidcreater != [[Login curLoginUser] uid]) {
                    [NSObject showHudTipStr:@"亲友不能做预算"];
                    return;
                }
                [weakSelf goToNewBudgetVC];
            };
        }
        
    }];
}

-(void)requestBudgetProWithBudget:(Budget *)budget{
    WEAKSELF
    __block Budget *blockBudget = budget;
    [[TiHouse_NetAPIManager sharedManager]request_BudgetproWithBudgets:budget Block:^(id data, NSError *error) {
        if (data) {
            weakSelf.budgetpro = data;
            weakSelf.budgetpro.budget = blockBudget;
            weakSelf.budgetpro.budget.house = weakSelf.house;
            [weakSelf.budgetpro upDataBudgetpro];
            [weakSelf UpdateViews];
            [weakSelf wr_setNavBarBarTintColor:[UIColor colorWithWhite:0 alpha:0]];
            [weakSelf setupNavBar];
        }else{
            [NSObject showHudTipStr:@"请求失败！"];
            [weakSelf.view endLoading];
        }
        [self.view endLoading];
    }];
}

//添加预算
- (void)goToNewBudgetVC{
    NewBudgetViewController *newBudgetVC = [[NewBudgetViewController alloc]init];
    newBudgetVC.house = _house;
    [self.navigationController pushViewController:newBudgetVC animated:YES];
}

//刷新视图
-(void)UpdateViews{
    [self.view endLoading];
    [self tableView];
    if (_house.uidcreater == [[Login curLoginUser] uid]) {
        [self addBudgetBtn];
    }
    [_budgetpro upDataBudgetpro];
    _tableHeaderView.budgetpro = _budgetpro;
    self.BudgetDetailsVC.budgetpro = self.budgetpro;
    [_tableView reloadData];
}

-(void)newBudgetpor:(NSNotification *)notification{
    NSDictionary *dic = notification.userInfo;
    _budgetpro = dic[@"budgetpro"];
    [self UpdateViews];
    [self wr_setNavBarBarTintColor:[UIColor colorWithWhite:0 alpha:0]];
    [self setupNavBar];
    [self.view addSubview:self.BudgetDetailsVC.view];
}

#pragma mark - event response
//弹出筛选视图
-(void)PopScreen{
    ScreenPopView *Screen = [[ScreenPopView alloc]init];
    Screen.budgetpro = _budgetpro;
    WEAKSELF
    Screen.finishSelectde = ^(BOOL selectBuy, BOOL selectMoney) {
        [weakSelf.budgetpro upDataBudgetpro];
        [weakSelf.tableView reloadData];
    };
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:Screen];
    [Screen Show];
}
//弹出价格排序
-(void)PopSort{
    PriceSortPopView *PriceSort = [[PriceSortPopView alloc]init];
    PriceSort.budgetpro = _budgetpro;
    WEAKSELF
    PriceSort.finishSelectde = ^(BOOL selectBuy, BOOL selectMoney) {
        [weakSelf.budgetpro upDataBudgetpro];
        [weakSelf.tableView reloadData];
    };
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:PriceSort];
    [PriceSort Show];
}
-(void)goToEidtBudgetVC{
    WEAKSELF
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *coverAction = [UIAlertAction actionWithTitle:@"编辑此版预算" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.view addSubview:weakSelf.BudgetDetailsVC.view];
    }];
    [coverAction setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
    UIAlertAction *copyAction = [UIAlertAction actionWithTitle:@"另存为新版预算" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请填写预算版本名称" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            Budget *budget = weakSelf.budgetpro.budget;
            budget.budgetname = [weakSelf.TextField.text aliasedString];
            [weakSelf CopyBudget];
        }];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            [textField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
            weakSelf.TextField = textField;
        }];
        [alert addAction:cancel];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    [copyAction setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [cancelAction setValue:XWColorFromHex(0x5186aa) forKey:@"_titleTextColor"];
    [alertVC addAction:coverAction];
    [alertVC addAction:copyAction];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

-(void)CopyBudget{
    WEAKSELF
    [NSObject showHUDQueryStr:@"为您添加数据..."];
    [[TiHouse_NetAPIManager sharedManager] request_CopyBudgetWithBudgetpro:_budgetpro Block:^(Budget *budget, NSError *error) {
        __block Budget *blockBudget = budget;
        if (!budget) {
            [NSObject hideHUDQuery];
        }
        if (budget) {
            [[TiHouse_NetAPIManager sharedManager]request_BudgetproWithBudgets:budget Block:^(id data, NSError *error) {
                [NSObject hideHUDQuery];
                if (data) {
                    Budgetpro *Budgetpro = data;
                    weakSelf.budgetpro = Budgetpro;
                    weakSelf.budgetpro.budget = blockBudget;
                    weakSelf.budgetpro.budget.house = weakSelf.house;
                    [weakSelf UpdateViews];
                    [weakSelf.view addSubview:weakSelf.BudgetDetailsVC.view];
                }else{
                    [NSObject showHudTipStr:@"请求失败！"];
                }
            }];
        }
    }];
    
}

-(void)request_Budgetpro{
    WEAKSELF
    [self.view beginLoading];
    [[TiHouse_NetAPIManager sharedManager]request_BudgetproWithBudgets:_budget Block:^(id data, NSError *error) {
        [weakSelf.view endLoading];
        
        if ([data isKindOfClass:[NSString class]] && [data isEqualToString:noAuthorizationString]) {
            [weakSelf.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
            return;
        }
        weakSelf.budgetpro = data;
        weakSelf.budgetpro.budget = weakSelf.budget;
        [weakSelf.budgetpro upDataBudgetpro];
        [weakSelf UpdateViews];
        [weakSelf wr_setNavBarBarTintColor:[UIColor colorWithWhite:0 alpha:0]];
        [weakSelf setupNavBar];
    }];
    
}

- (GBSharePan*)sharePan
{
    if (!_sharePan)
    {
        _sharePan = [[GBSharePan alloc] init];
        _sharePan.delegate = self;
    }
    return _sharePan;
}

-(void)BarBtnShare{
    XWLog(@"======分享======");
    _budgetpro.isSort = YES;
    _budgetpro.ascending = NO;
//    [_budgetpro upDataBudgetpro];
    [self.sharePan showSharePanWithDelegate:self showSingle:YES];
    [_tableView reloadData];
    
}
-(void)BarBtnList{
    XWLog(@"======列表======");
    BudgetListViewController *BudgetListVC = [[BudgetListViewController alloc]init];
    BudgetListVC.house = _house;
    [self.navigationController pushViewController:BudgetListVC animated:YES];
}
-(void)BarBtnBlock{
    XWLog(@"======返回======");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)GBSharePanAction:(GBSharePan*)pan tag:(SHARE_TYPE)tag
{
    [self share:tag];
}

- (void)GBSharePanActionCancel:(GBSharePan *)pan {
}

- (void)share:(SHARE_TYPE)tag {
    
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
    NSString *title;
    if (tag == SHARE_TYPE_WEIBO) {
        title = [NSString stringWithFormat:@"“%@”装修预算出炉啦！%@", _house.housename, _house.linkshare];
    } else {
        title = [NSString stringWithFormat:@"“%@”装修预算出炉啦！", _house.housename];
    }
    NSString *content = @"快来看看要花多少钱？";
    [[[UMShareManager alloc]init] webShare:tag title:title content:content url:_budgetpro.budget.linkshare image:_house.urlshare complete:^(NSInteger state)
     {
         @strongify(self)
         switch (state) {
             case 0: {
                 [NSObject showHudTipStr:self.view tipStr:@"分享成功"];
                 [self.sharePan hide:^(BOOL ok){}];
//                 NSInteger type = self.knowModeInfo.knowtype == KnowType_Poster ? 5 : 6;
//                 [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/inter/share/notifySuccess" withParams:@{@"type":@(type),@"typeid":@(self.knowModeInfo.knowid),@"platform":platform} withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
//                 }];
             }
             break;
             case 1: {
                 [NSObject showHudTipStr:self.view tipStr:@"分享失败"];
                 [self.sharePan hide:^(BOOL ok){}];
             }
             break;
             default:
                 break;
         }
     }];
}


#pragma mark - <懒加载>
-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = kRKBViewControllerBgColor;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.automaticallyAdjustsScrollViewInsets = NO;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[BudgetDetailsTabbleHeaderView class] forHeaderFooterViewReuseIdentifier:@"header"];
        [_tableView registerClass:[BudgetPreviewTableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.estimatedRowHeight = 60;
        _tableView.bounces = NO;
        _tableView.tableHeaderView = self.tableHeaderView;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
            make.height.equalTo(self.view).offset(-20);
        }];
    }
    return _tableView;
}

-(AddBudgetBtn *)addBudgetBtn{
    if (!_addBudgetBtn) {
        _addBudgetBtn = [[AddBudgetBtn alloc]init];
        _addBudgetBtn.Title.text = @"再次编辑";
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToEidtBudgetVC)];
        [_addBudgetBtn addGestureRecognizer:tap];
        [self.view addSubview:_addBudgetBtn];
        [_addBudgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.equalTo(kDevice_Is_iPhoneX ? @(84) : @(50));
        }];
    }
    return _addBudgetBtn;
}

-(BudgetDetailsPreviewTabbleHeader *)tableHeaderView{
    
    if (!_tableHeaderView) {
        _tableHeaderView = [[BudgetDetailsPreviewTabbleHeader alloc]init];
        _tableHeaderView.frame = CGRectMake(0, 0, _tableView.width, kRKBHEIGHT(194));
    }
    return _tableHeaderView;
}

-(BudgetDetailsViewController *)BudgetDetailsVC{
    if (!_BudgetDetailsVC) {
        _BudgetDetailsVC = [[BudgetDetailsViewController alloc]init];
        _BudgetDetailsVC.budgetpro =  _budgetpro;
        _BudgetDetailsVC.ViewController = self;
        WEAKSELF
        _BudgetDetailsVC.UpdataBlock = ^{
            //返回刷新视图
            [weakSelf UpdateViews];
        };
        [self addChildViewController:_BudgetDetailsVC]; 
    }
    return _BudgetDetailsVC;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
// 千分位有小数点
- (NSString *)moneyFormat:(NSString *)money{
    NSArray *moneys = [money componentsSeparatedByString:@"."];
    if (moneys.count > 2) {
        return money;
    }
    else if (moneys.count < 2) {
        return [self stringFormatToThreeBit:money];
    }
    else {
        NSString *frontMoney = [self stringFormatToThreeBit:moneys[0]];
        if([frontMoney isEqualToString:@""]){
            frontMoney = @"0";
        }
        return [NSString stringWithFormat:@"%@.%@", frontMoney,moneys[1]];
    }
}

// 千分位无小数点
- (NSString *)stringFormatToThreeBit:(NSString *)string{
    if (string.length <= 0) {
        return @"".mutableCopy;
    }
    
    NSString *tempRemoveD = [string stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSMutableString *stringM = [NSMutableString stringWithString:tempRemoveD];
    NSInteger n = 2;
    for (NSInteger i = tempRemoveD.length - 3; i > 0; i--) {
        n++;
        if (n == 3) {
            [stringM insertString:@"," atIndex:i];
            n = 0;
        }
    }
    
    return stringM;
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

@end

