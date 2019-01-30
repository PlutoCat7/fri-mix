//
//  BudgetDetailsViewController.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/22.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BudgetListViewController.h"
#import "NewBudgetViewController.h"
#import "BudgetListTableViewCell.h"
#import "ODRefreshControl.h"
#import "Budgets.h"
#import "House.h"
#import "AddBudgetBtn.h"
#import "Budgetpro.h"
#import "LookTransformViewController.h"
#import "BudgetDetailsViewController.h"
#import "BudgetDetailsPreviewViewController.h"
#import "HouseInfoViewController.h"
#import "Login.h"
@interface BudgetListViewController ()<UITableViewDelegate,UITableViewDataSource,BudgetListTableViewCellDelegate>
{
    BOOL isEdit;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ODRefreshControl *refreshControl;
@property (nonatomic, strong) Budgets *budgets;
@property (nonatomic, strong) AddBudgetBtn *addBudgetBtn;
@property (nonatomic, strong) Budgetpro *budgetpro;



@end

@implementation BudgetListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预算列表";
    _budgets = [[Budgets alloc]init];
    _budgets.house = _house;
    isEdit = NO;
    
    [self tableView];
    if (_house.uidcreater == [[Login curLoginUser] uid]) {
        [self addBudgetBtn];
    }
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.automaticallyAdjustsScrollViewInsets = YES;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refresh];
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _budgets.list.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BudgetListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    Budget *budget = _budgets.list[indexPath.section];
    cell.budget = budget;
    cell.indexPath = indexPath;
    cell.isEdit = isEdit;
    cell.delagate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
    return 15.f;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - UITableCellViewDelegate
-(void)BudgetListCellBtnCkickRespondType:(BudgetListCellBtnRespondType)Style cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAKSELF
    if (Style == BudgetListCellBtnRespondTypeDelete) {
        XWLog(@"=======删除=======%@",indexPath);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您是否确认删除预算？\n删除后无法恢复！" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancen = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf removeBudgetWithIndex:indexPath.section];
        }];
        [alert addAction:cancen];
        [alert addAction:confirm];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if (Style == BudgetListCellBtnRespondTypeLock) {
        WEAKSELF
        XWLog(@"=======查看预算=======%@",indexPath);
        [weakSelf goToBudgetDetailsVC:_budgets.list[indexPath.section]];
        return;
    }
    if (Style == BudgetListCellBtnRespondTypeChange) {
        XWLog(@"=======查看修改=======");
        LookTransformViewController *lookVC = [[LookTransformViewController alloc]init];
        lookVC.bugset = _budgets.list[indexPath.section];
        [self.navigationController pushViewController:lookVC animated:YES];
        return;
    }
}


#pragma mark - event response
-(void)edit{
    XWLog(@"= ======编辑=======");
    if(_house.uidcreater != [Login curLoginUser].uid) {
        [NSObject showHudTipStr:@"亲友不能编辑预算"];
        return;
    }
    isEdit = !isEdit;
    if (isEdit) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(edit)];
        self.title = @"编辑预算列表";
        self.addBudgetBtn.hidden = YES;
        
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(edit)];
        self.title = @"预算列表";
        self.addBudgetBtn.hidden = NO;
    }
    [_tableView reloadData];
}


#pragma mark - private methods 私有方法
-(void)refresh{
    if (_budgets.isLoading) {
        return;
    }
    _budgets.willLoadMore = NO;
    _budgets.page = @(0);
    [self sendRequest];
}

- (void)refreshMore{
    if (_budgets.isLoading || !_budgets.canLoadMore) {
        [_tableView.mj_footer endRefreshing];
        _tableView.mj_footer.state = MJRefreshStateNoMoreData;
        [_tableView.mj_footer resetNoMoreData];
        return;
    }
    _budgets.willLoadMore = YES;
    _budgets.page = @(20 + [_budgets.page intValue]);
    [self sendRequest];
}

-(void)sendRequest{
    
    if (_budgets.list.count <= 0) {
        [self.view beginLoading];
    }
    WEAKSELF
    [[TiHouse_NetAPIManager sharedManager] request_BudgetListWithBudgets:_budgets Block:^(NSMutableArray *data, NSError *error) {
        [weakSelf.view endLoading];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
        if (data) {
            weakSelf.budgets.list = data;
            [weakSelf.tableView reloadData];
            if (isEdit) {
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(edit)];
            }else{
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(edit)];
            }
            [weakSelf.tableView configBlankPage:EaseBlankPageTypeBudet hasData:data.count hasError:NO offsetY:0 reloadButtonBlock:^(id sender) {
            }];
            //空白页按钮事件
            weakSelf.tableView.blankPageView.clickButtonBlock=^(EaseBlankPageType curType) {
                [weakSelf goToNewBudgetVC];
            };
            
        }
    }];
}

-(void)removeBudgetWithIndex:(NSInteger)index{
    Budget *budget = _budgets.list[index];
    WEAKSELF
    __block NSInteger row = index;
    [_tableView beginUpdates];
    [[TiHouse_NetAPIManager sharedManager] request_RemoveBudgetWithBudgets:budget Block:^(id data, NSError *error) {
        if (data) {
            [weakSelf.budgets.list removeObjectAtIndex:row];
            if ([weakSelf.budgets.list count] == 0) {
                NSInteger index=[[self.navigationController viewControllers]indexOfObject:self];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 2] animated:YES];
            }
            [weakSelf.tableView deleteSections:[NSIndexSet indexSetWithIndex:row] withRowAnimation:(UITableViewRowAnimationRight)];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView endUpdates];
            NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
            for (UIViewController *aViewController in allViewControllers) {
                if ([aViewController isKindOfClass:[HouseInfoViewController class]]) {
                    [self.navigationController popToViewController:aViewController animated:NO];
                }
            }
        }
    }];
}

#pragma mark VC
- (void)goToNewBudgetVC{

    NewBudgetViewController *newBudgetVC = [[NewBudgetViewController alloc]init];
    newBudgetVC.house = _house;
    [self.navigationController pushViewController:newBudgetVC animated:YES];
}

- (void)goToBudgetDetailsVC:(Budget *)budget{
    BudgetDetailsPreviewViewController*newBudgetVC = [[BudgetDetailsPreviewViewController alloc]init];
    newBudgetVC.budget = budget;
    newBudgetVC.house = _house;
    [self.navigationController pushViewController:newBudgetVC animated:YES];
}



#pragma mark - <懒加载>
-(UITableView *)tableView{

    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = kRKBViewControllerBgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[BudgetListTableViewCell class] forCellReuseIdentifier:@"cell"];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).mas_offset(UIEdgeInsetsMake(IphoneX ? 88 : 64, 0, 0, 0));
        }];
        WEAKSELF
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf refresh];
        }];
        _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            [weakSelf refreshMore];
        }];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    }
    return _tableView;
}

-(AddBudgetBtn *)addBudgetBtn{
    if (!_addBudgetBtn) {
        _addBudgetBtn = [[AddBudgetBtn alloc]init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToNewBudgetVC)];
        [_addBudgetBtn addGestureRecognizer:tap];
        [self.view addSubview:_addBudgetBtn];
        [_addBudgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.equalTo(kDevice_Is_iPhoneX ? @(84) : @(50));
        }];
    }
    return _addBudgetBtn;
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

@end
