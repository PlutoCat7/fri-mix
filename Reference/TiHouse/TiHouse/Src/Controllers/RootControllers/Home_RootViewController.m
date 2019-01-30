//
//  Home_RootViewController.m
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/15.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "Home_RootViewController.h"
#import "HomeTableViewCell.h"
#import "HomeTopMuneView.h"
#import "ODRefreshControl.h"
#import "BaseNavigationController.h"

#import "AddHouseViewController.h"
#import "InvitationCodeViewController.h"
#import "HouseInfoViewController.h"
#import "PerfectRelationViewController.h"
#import "UnReadManager.h"

#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "Houses.h"
#import "HomeEmptyView.h"
#import "Login.h"
#import "NewVersionController.h"


@interface Home_RootViewController ()<UITableViewDelegate,UITableViewDataSource,MGSwipeTableCellDelegate,InvitationCodeViewControllerDelegate>
{
    CGFloat _oldPanOffsetY;
    NSInteger phusOne;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HomeTopMuneView *topView;
@property (nonatomic, strong) ODRefreshControl *refreshControl;
@property (nonatomic, strong) Houses *myHouses;
@property (nonatomic, strong) HomeEmptyView *emptyView;
@property (nonatomic, assign) BOOL          shouldCompletedRelationShipAuto;//是否需要自动完善关系
@property (nonatomic, assign) NSInteger     relationShipHouseId;//从完善页面传过来的houseid

@end

@implementation Home_RootViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.shouldCompletedRelationShipAuto = NO;
    }
    return self;
}

#pragma mark - lift cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"房屋";
    [(BaseNavigationController *)self.navigationController  hideNavBottomLine];
    _myHouses = [[Houses alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self tableView];
    
    NSNumber *delete = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeleteByCreator"];
    //上一次如果有查看者直接进入
    if ([House getRecordHouse].houseid && ![delete integerValue] && [Login curLoginUserID] != 60) {
        HouseInfoViewController *houesInfoVC = [HouseInfoViewController new];
        houesInfoVC.isFixNavigation = YES; // MARK: - 只有这个入口会导致时间轴首页导航问题
        houesInfoVC.house = [House getRecordHouse];
        [self.navigationController pushViewController:houesInfoVC animated:NO];
    }
    
    [[UnReadManager shareManager] updateUnRead];
    //关注房屋返回houseid
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AttentionHouse:) name:@"AttentionHouse" object:nil];
    
//    // MARK: - 检查更新应该延迟执行，其root present方式对时间轴导航样式有影响
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        [NewVersionModel checkNewVersion:^(BOOL b, NewVersionModel *model) {
//            if (b) {
//                NewVersionController *newVersionVC = [[NewVersionController alloc] init];
//                newVersionVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//                newVersionVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//                newVersionVC.currentModel = model;
//                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:newVersionVC animated:YES completion:nil];
//            }
//        }];
//
//    });
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [(BaseNavigationController *)self.navigationController  hideNavBottomLine];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self refresh];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _myHouses.list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row == _myHouses.list.count-1) {
        cell.bottomLineStyle = CellLineStyleNone;
    }else{
        cell.bottomLineStyle = CellLineStyleDefault;
    }
    cell.delegate = self;
    cell.house = _myHouses.list[indexPath.row];
    NSString *title = cell.house.housepersonisstick == 1 ? @"取消置顶" : @"置顶房屋";
    cell.rightButtons =  @[[MGSwipeButton buttonWithTitle:@"房屋信息" backgroundColor:[UIColor colorWithHexString:@"0xc8c7cd"]],
                           [MGSwipeButton buttonWithTitle:title backgroundColor:[UIColor colorWithHexString:@"0xfbbe42"]]];
    return cell;
}

- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion {
    HomeTableViewCell *hCell = (HomeTableViewCell *)cell;
    if (index == 1) {
        hCell.house.housepersonisstick == 2 ? [self topFixedCurrentHouse:hCell.house] : [self cancelTopFixedCurrentHouse:hCell.house];
    } else {
        AddHouseViewController *addHouse = [AddHouseViewController new];
        addHouse.edit = YES;
        addHouse.addHouse = NO;
        hCell.house.edit = YES;
        hCell.house.halfurlfront = [[hCell.house.urlfront componentsSeparatedByString:@"com"] lastObject];
        hCell.house.halfurlback = [[hCell.house.urlback componentsSeparatedByString:@"com"] lastObject];
        addHouse.myHouse = hCell.house;
        
        addHouse.editBlock = ^(House *house) {
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:addHouse animated:YES];
    }
    return true;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kRKBHEIGHT(70);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self phusHouseInfoWithHouse:self.myHouses.list[indexPath.row] animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentSize.height <= CGRectGetHeight(scrollView.bounds)-50) {
        [self hideToolBar:NO];
        return;
    }else if (scrollView.panGestureRecognizer.state == UIGestureRecognizerStateChanged){
        CGFloat nowPanOffsetY = [scrollView.panGestureRecognizer translationInView:scrollView.superview].y;
        CGFloat diffPanOffsetY = nowPanOffsetY - _oldPanOffsetY;
        CGFloat contentOffsetY = scrollView.contentOffset.y;
        if (ABS(diffPanOffsetY) > 50.f) {
            [self hideToolBar:(diffPanOffsetY < 0.f && contentOffsetY > 0)];
            _oldPanOffsetY = nowPanOffsetY;
        }
    }
}

- (void)hideToolBar:(BOOL)hide{
    if (hide != self.rdv_tabBarController.tabBarHidden) {
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, (hide? 0.0:CGRectGetHeight(self.rdv_tabBarController.tabBar.frame)), 0.0);
        self.tableView.contentInset = contentInsets;
        [self.rdv_tabBarController setTabBarHidden:hide animated:YES];
    }
}

// 隐藏UITableViewStyleGrouped下边多余的间隔
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;//section头部高度
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
    return 0.01f;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}



#pragma mark - CustomDelegate

#pragma mark - event response
-(void)phusHouseInfoWithHouse:(House *)house animated:(BOOL)animated{
    if (house.typerelation) {
        HouseInfoViewController *houesInfoVC = [HouseInfoViewController new];
        houesInfoVC.house = house;
        [self.navigationController pushViewController:houesInfoVC animated:animated];
        [House setgetRecordWithHouseid:house.houseid housenumrecord:house.numrecord];
    }else{
        PerfectRelationViewController *PerfectRelationVC = [PerfectRelationViewController new];
        PerfectRelationVC.house = house;
        [self.navigationController pushViewController:PerfectRelationVC animated:animated];
    }
}

#pragma mark - private methods 私有方法

- (void)refresh{
    
    if (_myHouses.isLoading) {
        return;
    }
    _myHouses.willLoadMore = NO;
    _myHouses.page = @(0);
    [_tableView.mj_footer resetNoMoreData];
    [self sendRequest];
}

- (void)refreshMore{
    if (_myHouses.isLoading || !_myHouses.canLoadMore) {
        //        [NSObject showHudTipStr:@"没有更多数据了"];
        //        [_tableView.mj_footer endRefreshing];
        _tableView.mj_footer.state = MJRefreshStateNoMoreData;
        //        [_tableView.mj_footer resetNoMoreData];
        return;
    }
    _myHouses.willLoadMore = YES;
    _myHouses.page = @([_myHouses.pageSize integerValue] + [_myHouses.page intValue]);
    [self sendRequest];
}

-(void)sendRequest{
    
    if (_myHouses.list.count <= 0) {
        [self.view beginLoading];
    }
    WEAKSELF
    [[TiHouse_NetAPIManager sharedManager] request_HousePageWithpageHouses:_myHouses Block:^(id data, NSError *error) {
        [weakSelf.view endLoading];
        [weakSelf.refreshControl endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (data) {
            [weakSelf.myHouses configWithHouess:data];
            if (weakSelf.myHouses.list.count == 0) {
                [self emptyView];
                weakSelf.tableView.scrollEnabled = NO;
                AddHouseViewController *addHouse = [AddHouseViewController new];
                addHouse.edit = YES;
                addHouse.addHouse = YES;
                addHouse.isNoHouse = YES;
                addHouse.finishAddHouseBlock = ^(House *house) {
                    if (house.typerelation) {
                        HouseInfoViewController *houesInfoVC = [HouseInfoViewController new];
                        houesInfoVC.house = house;
                        [weakSelf.navigationController pushViewController:houesInfoVC animated:YES];
                        [House setgetRecordWithHouseid:house.houseid housenumrecord:house.numrecord];
                    }
                };
                [weakSelf.navigationController pushViewController:addHouse animated:NO];
            } else {
                [weakSelf.emptyView removeFromSuperview];
                weakSelf.emptyView = nil;
                weakSelf.tableView.scrollEnabled = YES;
            }
            [weakSelf.tableView reloadData];
            
            if (self.shouldCompletedRelationShipAuto)
            {
                self.shouldCompletedRelationShipAuto = NO;
                
                House *house = nil;
                for (House *tmpHouse in self.myHouses.list)
                {
                    if (self.relationShipHouseId == tmpHouse.houseid)
                    {
                        house = tmpHouse;
                        break;
                    }
                }
                if (house)
                {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        PerfectRelationViewController *PerfectRelationVC = [PerfectRelationViewController new];
                        PerfectRelationVC.house = house;
                        [self.navigationController pushViewController:PerfectRelationVC animated:YES];
                    });
                }
            }
        }
        
    }];
    
}

-(void)AttentionHouse:(NSNotification *)notification{
    
    NSDictionary *dic = notification.userInfo;
    
    HouseInfoViewController *houesInfoVC = [HouseInfoViewController new];
    House *house = [[House alloc]init];
    house.houseid = [dic[@"houseid"] longLongValue];
    house.typerelation = [dic[@"typerelation"] longLongValue];
    houesInfoVC.house = house;
    [self.navigationController pushViewController:houesInfoVC animated:YES];
}


#pragma mark - getters and setters

-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = kRKBViewControllerBgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[HomeTableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.tableHeaderView = self.topView;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).mas_offset(UIEdgeInsetsMake(kNavigationBarHeight, 0, 0, 0));
        }];
        WEAKSELF
        _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            [weakSelf refreshMore];
        }];
        _tableView.estimatedRowHeight = kRKBHEIGHT(70);
        _refreshControl = [[ODRefreshControl alloc] initInScrollView:_tableView];
        [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    }
    return _tableView;
}

-(HomeTopMuneView *)topView{
    
    if (!_topView) {
        _topView = [[HomeTopMuneView alloc]init];
        _topView.backgroundColor =[UIColor whiteColor];
        _topView.frame = CGRectMake(0, 0, kScreen_Width, kRKBHEIGHT(120));
        __weak typeof(self) weakself = self;
        _topView.ClickItem = ^(NSInteger i) {
            if (i == 1) {
                AddHouseViewController *addHouse = [AddHouseViewController new];
                addHouse.edit = YES;
                addHouse.addHouse = YES;
                addHouse.finishAddHouseBlock = ^(House *house) {
                    HouseInfoViewController *houesInfoVC = [HouseInfoViewController new];
                    houesInfoVC.house = house;
                    [weakself.navigationController pushViewController:houesInfoVC animated:YES];
                    [House setgetRecordWithHouseid:house.houseid housenumrecord:house.numrecord];
                };
                [weakself.navigationController pushViewController:addHouse animated:YES];
            }else{
                InvitationCodeViewController *invitationCode = [InvitationCodeViewController new];
                invitationCode.delegate = self;
                [weakself.navigationController pushViewController:invitationCode animated:YES];
            }
        };
    }
    return _topView;
}

- (HomeEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[HomeEmptyView alloc] init];
        [self.view addSubview:_emptyView];
        [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.mas_equalTo( kRKBHEIGHT(120) + 15 + kNavigationBarHeight);
        }];
    }
    return _emptyView;
}

-(void)click:(UIButton *)btn{
    
    btn.enabled = NO;
    //    btn.imageView.size = CGSizeMake(btn.imageView.size.width*0.8, btn.imageView.size.width*0.8);
    
}

- (void)topFixedCurrentHouse:(House *)house {
    NSDictionary *params = @{@"houseid": @(house.houseid), @"uid": @([Login curLoginUserID])};
    [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/house/stick" withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        if ([data[@"is"] integerValue]) {
            [NSObject showHudTipStr:data[@"msg"]];
            [self refresh];
        } else {
            [NSObject showHudTipStr:data[@"msg"]];
        }
    }];
}

- (void)cancelTopFixedCurrentHouse:(House *)house {
    NSDictionary *params = @{@"houseid": @(house.houseid), @"uid": @([Login curLoginUserID])};
    [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/house/stickcancel" withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        if ([data[@"is"] integerValue]) {
            [NSObject showHudTipStr:data[@"msg"]];
            [self refresh];
        } else {
            [NSObject showHudTipStr:data[@"msg"]];
        }
    }];
    
}

- (void)invitationCodeViewController:(InvitationCodeViewController *)controller createRelationShipSuccessedWithHouseId:(NSInteger)houseId;
{
    self.shouldCompletedRelationShipAuto = YES;
    self.relationShipHouseId = houseId;
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
