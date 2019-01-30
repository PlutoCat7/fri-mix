//
//  FriendsRangeViewController.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/16.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FriendsRangeViewController.h"
#import "AddHouseTableViewCell.h"
#import "SelectFriendsViewController.h"
#import "Dairy.h"
#import "Login.h"

@interface FriendsRangeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *UIModels;

@end

@implementation FriendsRangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        //        self.automaticallyAdjustsScrollViewInsets = YES;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(Finish)];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(Cancel)] animated:YES];

    self.UIModels = [UIHelp getFriendsRange];
    [self tableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_UIModels count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UIModel *uimodel = _UIModels[indexPath.row];
    cell.image = [UIImage imageNamed:@"relationBtn"];
    cell.Title.text = uimodel.Title;
    cell.TextField.userInteractionEnabled = NO;
//    cell.icon.userInteractionEnabled = YES;
    cell.icon.selected = NO;
    if (_dairy && _dairy.uid != [Login curLoginUserID] && indexPath.row == 1) {
        cell.Title.textColor = [UIColor colorWithHexString:@"0xbfbfbf"];
    }
    [cell.icon setImage:[UIImage imageNamed:@"relationBtnselect"] forState:UIControlStateSelected];
    if (indexPath.row == _index) {
        cell.icon.selected = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kRKBHEIGHT(50);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_dairy && _dairy.uid != [Login curLoginUserID] && indexPath.row == 1) {
        return;
    }
    _index = indexPath.row;
    [tableView reloadData];
    WEAKSELF
    AddHouseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row == 2) {
        SelectFriendsViewController *SelectFriendsVC = [[SelectFriendsViewController alloc]init];
        SelectFriendsVC.house = _house;
        SelectFriendsVC.dairy = _dairy;
        SelectFriendsVC.tweet = _tweet;
        SelectFriendsVC.friends = [NSMutableArray arrayWithArray:_friends];
        SelectFriendsVC.selectedFriends = [NSMutableArray arrayWithArray:_selectedFriends];
        SelectFriendsVC.selectdeFriendsBlcok = ^(NSArray *friends, NSArray *selectedFriends) {
            weakSelf.friends = friends;
            weakSelf.selectedFriends = selectedFriends;
        };
        [self.navigationController pushViewController:SelectFriendsVC animated:YES];
    }
    
}

#pragma mark - event response
-(void)Cancel{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)Finish{
    if (_selectdeFriendsBlcok) {
        _selectdeFriendsBlcok(_friends,_selectedFriends,_index);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - getters and setters
-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = kRKBViewControllerBgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[AddHouseTableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.estimatedRowHeight = 50;
        //        _tableView.tableHeaderView = self.TableHeader;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).mas_offset(UIEdgeInsetsMake(IphoneX ? 88 : 64, 0, 0, 0));
        }];
    }
    return _tableView;
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
