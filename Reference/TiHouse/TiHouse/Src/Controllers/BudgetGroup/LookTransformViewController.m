//
//  LookTransformViewController.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "LookTransformViewController.h"
#import "LookTransformViewCell.h"
#import "Logbudgetopes.h"
#import "ODRefreshControl.h"

@interface LookTransformViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, retain) Logbudgetopes *logbudgetopes;
@property (nonatomic, strong) ODRefreshControl *refreshControl;

@end

@implementation LookTransformViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = XWColorFromHex(0xf8f8f8);
    self.title = [NSString stringWithFormat:@"%@修改记录",_bugset.budgetname];
    _logbudgetopes = [[Logbudgetopes alloc]init];
    _logbudgetopes.budget = _bugset;
    [self tableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refresh];
}


#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _logbudgetopes.list.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LookTransformViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.models = _logbudgetopes.list[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [LookTransformViewCell getCellHeight:_logbudgetopes.list[indexPath.section]];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}


//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15.0f;
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



#pragma mark - private methods 私有方法
-(void)refresh{
    if (_logbudgetopes.isLoading) {
        return;
    }
    _logbudgetopes.willLoadMore = NO;
    _logbudgetopes.page = @(0);
    [self sendRequest];
}

- (void)refreshMore{
    if (_logbudgetopes.isLoading || !_logbudgetopes.canLoadMore) {
        [_tableView.mj_footer endRefreshing];
        _tableView.mj_footer.state = MJRefreshStateNoMoreData;
        [_tableView.mj_footer resetNoMoreData];
        return;
    }
    _logbudgetopes.willLoadMore = YES;
    _logbudgetopes.page = @(20 + [_logbudgetopes.page intValue]);
    [self sendRequest];
}
-(void)sendRequest{
    
    if (_logbudgetopes.list.count <= 0) {
        [self.view beginLoading];
    }
    WEAKSELF
    [[TiHouse_NetAPIManager sharedManager] request_LookTransformListWithLogbudgetopes:_logbudgetopes Block:^(id data, NSError *error) {
        [weakSelf.view endLoading];
        [weakSelf.refreshControl endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (data) {
            [weakSelf.logbudgetopes configWithLogbudgetopes:data];
            [weakSelf.tableView reloadData];
//            [weakSelf.tableView configBlankPage:EaseBlankPageTypeBudet hasData:data.count hasError:NO offsetY:0 reloadButtonBlock:^(id sender) {
//            }];
//            //空白页按钮事件
//            weakSelf.tableView.blankPageView.clickButtonBlock=^(EaseBlankPageType curType) {
//                
//            };
            
        }
    }];
}

#pragma mark - <懒加载>
-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = kRKBViewControllerBgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 250;
        [_tableView registerClass:[LookTransformViewCell class] forCellReuseIdentifier:@"cell"];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).mas_offset(UIEdgeInsetsMake(IphoneX ? 88 : 64, 0, 0, 0));
        }];
        WEAKSELF
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf refreshMore];
        }];
        _refreshControl = [[ODRefreshControl alloc] initInScrollView:_tableView];
        [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    }
    return _tableView;
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
