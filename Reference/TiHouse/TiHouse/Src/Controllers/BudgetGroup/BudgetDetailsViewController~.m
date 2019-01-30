//
//  BudgetDetailsViewController.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/22.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BudgetDetailsViewController.h"
#import "BudgetDetailsTabbleHeader.h"
#import "BudgetDetailsTabbleHeaderView.h"
#import "BudgetDetailsTableViewCell.h"
#import "OneClassMenus.h"
#import "ZXCategorySliderBar.h"
#import "BudgetDetailsBottom.h"
#import "Budget.h"
#import "House.h"
#import "ScreenPopView.h"
#import "PriceSortPopView.h"
#import "AddBudgetPopView.h"
#import "AddBudgetNamePopView.h"
#import "SGTopScrollMenu.h"
#import "BudgetOneClass.h"
#import "BudgetTwoClass.h"
#import "BudgetThreeClass.h"
@interface BudgetDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,ZXCategorySliderBarDelegate,SGTopScrollMenuDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BudgetDetailsTabbleHeader *tableHeaderView;
@property (nonatomic, strong) BudgetOneClass *oldOneClass;
@property (nonatomic, strong) BudgetOneClass *currentOneClass;
@property (nonatomic, strong) BudgetTwoClass *currentTwoClass;
@property (nonatomic, strong) ZXCategorySliderBar *sliderBar;

@property (nonatomic, strong) BudgetDetailsBottom *bottomView;
@property (nonatomic, strong) BudgetDetailsTabbleHeaderView *header;

@end

@implementation BudgetDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self wr_setNavBarBarTintColor:[UIColor colorWithWhite:0 alpha:0]];
    [self setupNavBar];
    
    [self header];
    [self tableView];
    [self bottomView];
    
    //初始化数据
    _tableHeaderView.budgetpro = _budgetpro;
    _bottomView.budgetpro = _budgetpro;
    _currentOneClass = _budgetpro.cateoneList.firstObject;
    _currentTwoClass = _currentOneClass.catetwoList.firstObject;
    _header.oneClass = _budgetpro.cateoneList.firstObject;
    _ViewController.navigationItem.titleView = nil;
    
}

-(void)setupNavBar{
    
//    UIImage *shareImage = [[UIImage imageNamed:@"budget_ share_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIBarButtonItem *share=[[UIBarButtonItem alloc] initWithImage:shareImage style:UIBarButtonItemStylePlain target:self action:@selector(BarBtnShare)];
//    self.navigationItem.rightBarButtonItem = share;
    
    UIImage *listImage = [[UIImage imageNamed:@"budget_block_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftone=[[UIBarButtonItem alloc] initWithImage:listImage style:UIBarButtonItemStylePlain target:self action:@selector(BarBtnBlock)];
    UIImage *blockImage = [[UIImage imageNamed:@"budget_list_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *lefttwo=[[UIBarButtonItem alloc] initWithImage:blockImage style:UIBarButtonItemStylePlain target:self action:@selector(BarBtnList)];
    lefttwo.imageInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:leftone,lefttwo, nil]];
    
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _currentTwoClass.sortList.count + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BudgetDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WEAKSELF
    cell.deleteBudget = ^{
        
        UIAlertController *alertCV = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除该项目？" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancen = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf RemoveWithBudgetThreeClass:_currentTwoClass.sortList[indexPath.row]];
        }];
        [cancen setValue:XWColorFromHex(0x5186aa) forKey:@"_titleTextColor"];
        [confirm setValue:XWColorFromHex(0x5186aa) forKey:@"_titleTextColor"];
        [alertCV addAction:cancen];
        [alertCV addAction:confirm];
        [weakSelf presentViewController:alertCV animated:YES completion:nil];
        
    };
    if (indexPath.row == _currentTwoClass.sortList.count) {
        cell.isAdd = YES;
        return cell;
    }
    cell.isAdd = NO;
    cell.threeClass = _currentTwoClass.sortList[indexPath.row];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
////    BudgetDetailsTabbleHeaderView *header = [[BudgetDetailsTabbleHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 100)];
//    BudgetDetailsTabbleHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
//    header = [[BudgetDetailsTabbleHeaderView alloc]initWithReuseIdentifier:@"header"];
//    header.oneClass = _currentOneClass;
//    header.masksToBounds = YES;
////    header.sliderBar.delegate = self;
////    _sliderBar = header.sliderBar;
//    header.topScrollMenu.topScrollMenuDelegate = self;
//    WEAKSELF
//    header.sortBlock = ^{
//        [weakSelf PopSort];
//    };
//    header.screenBlock = ^{
//        [weakSelf PopScreen];
//    };
    return _header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (_currentTwoClass.catetwostatus == 0) {
        return 50;
    }
    
    return 100;
}


//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20.f;
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
    WEAKSELF
    if (indexPath.row == _currentTwoClass.sortList.count) {
//        [self PopAddBudetItemWihtThreeClass:nil];
        AddBudgetNamePopView *addB = [[AddBudgetNamePopView alloc]init];
        addB.finishBlock = ^(NSString *name) {
            BudgetThreeClass *therrClass = [[BudgetThreeClass alloc]init];
            therrClass.proname = name;
            [weakSelf PopAddBudetItemWihtThreeClass:therrClass];
        };
        [addB Show];
        return;
    }
    [self PopAddBudetItemWihtThreeClass:_currentTwoClass.sortList[indexPath.row]];
}

#pragma mark - CustomDelegate
-(void)didSelectedIndex:(NSInteger)index{
    _currentTwoClass = _currentOneClass.catetwoList[index];
    [_tableView reloadData];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int contentOffsety = scrollView.contentOffset.y;
    if (-contentOffsety > 100) {
        _tableView.contentOffset = CGPointMake(0, -100);
    }
    
    //NavBar背景色渐变
    [self wr_setNavBarBarTintColor:XWColorFromHexAlpha(0xfdf086,(contentOffsety-55)/50.0)];
    if (contentOffsety < 55) {
        [self wr_setNavBarTintColor:[UIColor clearColor]];
        _ViewController.title = @"";
        _ViewController.navigationItem.titleView = nil;
    }else{
        [self wr_setNavBarTintColor:kRKBNAVBLACK];
        _ViewController.title = _budgetpro.budgetname;
        
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
        _ViewController.navigationItem.titleView = view;
    }
    if (contentOffsety > kRKBHEIGHT(263)-kNavigationBarHeight) {
        _tableView.contentInset = UIEdgeInsetsMake(kNavigationBarHeight, 0, 100, 0);
    }else{
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
    }
    
}

- (void)SGTopScrollMenu:(SGTopScrollMenu *)topScrollMenu didSelectTitleAtIndex:(NSInteger)index{
    _currentTwoClass = _currentOneClass.catetwoList[index];
    [_tableView reloadData];
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
//弹出添加或修改的预算内容视图
-(void)PopAddBudetItemWihtThreeClass:(BudgetThreeClass *)threeClass{
    BudgetThreeClass *threeClassCopy = [threeClass copy];
    AddBudgetPopView *AddBudget = [[AddBudgetPopView alloc]initWithBudgetThreeClass:threeClassCopy ? threeClassCopy : nil];
    WEAKSELF
    __block BudgetThreeClass *blockOld = threeClass;
    AddBudget.finishSelectde = ^(BudgetThreeClass *threeClass, BOOL isNew) {
        if (isNew) {
            [weakSelf.currentTwoClass.sortList addObject:threeClass];
            [weakSelf.currentTwoClass.catethreeList addObject:threeClass];
            [weakSelf.budgetpro upDataBudgetpro];
            threeClass.catetwoid = weakSelf.currentTwoClass.catetwoid;
            BudgetThreeClass *Three = weakSelf.currentTwoClass.catethreeList.firstObject;
            threeClass.budgetid = Three.budgetid;
            [weakSelf AddBudgetProWihtThreeClass:threeClass];
        }else{
//            NSInteger index = [weakSelf.currentTwoClass.sortList indexOfObject:blockOld];
//            [weakSelf.currentTwoClass.sortList removeObject:blockOld];
//            [weakSelf.currentTwoClass.sortList insertObject:threeClass atIndex:index];
//            [weakSelf.tableView reloadData];
            [weakSelf EditimngBudgetProWihtNewThreeClass:threeClass OldthreeClass:blockOld];
        }
    };
    [AddBudget Show];
    
}

-(void)save{
    [self.view removeFromSuperview];
    if (_UpdataBlock) {
        _UpdataBlock();
    }
}

-(void)BarBtnShare{
    XWLog(@"======分享======");
    _budgetpro.isSort = YES;
    _budgetpro.ascending = NO;
    
    [_budgetpro upDataBudgetpro];
    [_tableView reloadData];
    
}
-(void)BarBtnList{
    XWLog(@"======列表======");
    
}
-(void)BarBtnBlock{
    XWLog(@"======返回======");
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - <数据请求>
-(void)EditimngBudgetProWihtNewThreeClass:(BudgetThreeClass *)newthreeClass OldthreeClass:(BudgetThreeClass *)oldthreeClass{
    WEAKSELF
    __block BudgetThreeClass *bolckThreeClass = newthreeClass;
    __block BudgetThreeClass *bolckoldThreeClass = oldthreeClass;
    [[TiHouse_NetAPIManager sharedManager] request_BudgetProEditWithBudgetThreeClass:newthreeClass Block:^(id data, NSError *error) {
        if (data) {
            NSInteger index = [weakSelf.currentTwoClass.catethreeList indexOfObject:bolckoldThreeClass];
            [weakSelf.currentTwoClass.catethreeList replaceObjectAtIndex:index withObject:bolckThreeClass];
            [weakSelf.budgetpro upDataBudgetpro];
            [weakSelf.tableView reloadData];
        }else{
            [weakSelf.budgetpro upDataBudgetpro];
            [weakSelf.tableView reloadData];
        }
    }];
}

-(void)AddBudgetProWihtThreeClass:(BudgetThreeClass *)threeClass{
    WEAKSELF
    __block BudgetThreeClass *bolckThreeClass = threeClass;
    [[TiHouse_NetAPIManager sharedManager] request_BudgetProAddWithBudgetThreeClass:threeClass Block:^(id data, NSError *error) {
        if (data) {
            BudgetThreeClass *pro = data;
            pro.doubleamountzj = pro.amountzj/100;
            NSInteger integer = [weakSelf.currentTwoClass.catethreeList indexOfObject:bolckThreeClass];
            [weakSelf.currentTwoClass.catethreeList replaceObjectAtIndex:integer withObject:pro];
            [weakSelf.currentTwoClass.sortList replaceObjectAtIndex:integer withObject:pro];
        }else{
            [weakSelf.currentTwoClass.catethreeList removeObject:bolckThreeClass];
            [weakSelf.currentTwoClass.sortList removeObject:bolckThreeClass];
            [weakSelf.tableView reloadData];
        }
        [weakSelf.tableView reloadData];
    }];
}
-(void)RemoveWithBudgetThreeClass:(BudgetThreeClass *)threeClass{
    WEAKSELF
    __block BudgetThreeClass *bolckThreeClass = threeClass;
    [[TiHouse_NetAPIManager sharedManager] request_BudgetProRemoveWithBudgetThreeClass:threeClass Block:^(id data, NSError *error) {
        if (data) {
            [weakSelf.currentTwoClass.catethreeList removeObject:bolckThreeClass];
            [weakSelf.currentTwoClass.sortList removeObject:bolckThreeClass];
            [weakSelf.tableView reloadData];
            [weakSelf.budgetpro upDataBudgetpro];
        }
    }];
}

-(void)setBudgetpro:(Budgetpro *)budgetpro{
    _budgetpro = budgetpro;
    [_budgetpro upDataBudgetpro];
    _tableHeaderView.budgetpro = _budgetpro;
    _bottomView.budgetpro = _budgetpro;
    _currentOneClass = _budgetpro.cateoneList.firstObject;
    _currentTwoClass = _currentOneClass.catetwoList.firstObject;
    [_tableView reloadData];
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
//        _tableView.clipsToBounds = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [_tableView registerClass:[BudgetDetailsTabbleHeaderView class] forHeaderFooterViewReuseIdentifier:@"header"];
        [_tableView registerClass:[BudgetDetailsTableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.estimatedRowHeight = 60;
        _tableView.bounces = NO;
        _tableView.tableHeaderView = self.tableHeaderView;
//        _tableView.contentInset = UIEdgeInsetsMake(kNavigationBarHeight, 0, 0, 0);
//        _tableView.contentOffset = CGPointMake(0, 263-kNavigationBarHeight);
//        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(263-kNavigationBarHeight, 0, 0, 0);
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _tableView;
}

-(BudgetDetailsTabbleHeader *)tableHeaderView{
    
    if (!_tableHeaderView) {
        _tableHeaderView = [[BudgetDetailsTabbleHeader alloc]init];
        _tableHeaderView.frame = CGRectMake(0, 0, _tableView.width, kRKBHEIGHT(263));
//        [_tableView addSubview:_tableHeaderView];
        WEAKSELF
        _tableHeaderView.oneClassMenus.MenuClikcWihtTag = ^(NSInteger tag) {
            weakSelf.oldOneClass = weakSelf.currentOneClass;
            weakSelf.currentOneClass = weakSelf.budgetpro.cateoneList[tag];
            weakSelf.sliderBar.originIndex = 0;
            weakSelf.header.oneClass = weakSelf.budgetpro.cateoneList[tag];
            weakSelf.currentTwoClass = weakSelf.currentOneClass.catetwoList.firstObject;
            [weakSelf.tableView reloadData];
        };
    }
    return _tableHeaderView;
}

-(BudgetDetailsBottom *)bottomView{
    
    if (!_bottomView) {
        _bottomView = [[BudgetDetailsBottom alloc]initWithFrame:CGRectMake(0, kDevice_Is_iPhoneX ? kScreen_Height-84 : kScreen_Height-50, kScreen_Width, kDevice_Is_iPhoneX ? 84 : 50)];
        [_bottomView.savesBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
}

-(BudgetDetailsTabbleHeaderView *)header{
    if (!_header) {
        _header = [[BudgetDetailsTabbleHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 100)];
        _header.masksToBounds = YES;
//        _header.topScrollMenu.topScrollMenuDelegate = self;
        _header.sliderBar.delegate = self;
        _sliderBar = _header.sliderBar;
        WEAKSELF
        _header.sortBlock = ^{
            [weakSelf PopSort];
        };
        _header.screenBlock = ^{
            [weakSelf PopScreen];
        };
    }
    return _header;
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
