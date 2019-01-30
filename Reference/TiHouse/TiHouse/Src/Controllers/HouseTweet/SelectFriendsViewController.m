//
//  SelectFriendsViewController.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/16.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "SelectFriendsViewController.h"
#import "FriendsHeaderView.h"
#import "AddHouseTableViewCell.h"
#import "User.h"
#import "Login.h"
#import "Dairy.h"
@interface SelectFriendsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) FriendsHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SelectFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        self.automaticallyAdjustsScrollViewInsets = YES;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    for (User *user in _friends) {
        if (user.uidconcert == [Login curLoginUserID]) {
            [_friends removeObject:user];
            break;
        }
    }
    self.title = @"选择亲友";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(Finish)];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(Cancel)] animated:YES];

    [self tableView];
    if (self.friends.count == 0) {
        [self getFriends];
    }else{
        _headerView.images = self.selectedFriends;
        [_headerView.mediaView reloadData];
    }
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_friends count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    User *user = _friends[indexPath.row];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:user.urlhead]];
    cell.image = [UIImage imageNamed:@"photo_-unselected"];
    cell.Title.text =[NSString stringWithFormat:@" %@ (%@)",[self getFriendRelationship:user.typerelation],user.username];
    cell.TextField.userInteractionEnabled = NO;
    [cell.icon setImage:[UIImage imageNamed:@"photo_select"] forState:UIControlStateSelected];
    [cell.icon setImage:[UIImage imageNamed:@"photo_disabled"] forState:UIControlStateDisabled];
    if (user.uidconcert == _dairy.uid) {
        cell.icon.enabled = NO;
    } else {
        cell.icon.enabled = YES;
        cell.icon.selected = NO;
        if (user.selected) {
            cell.icon.selected = YES;
        }
    }
    
    if (indexPath.row == 0) {
        cell.topLineStyle = CellLineStyleFill;
    }
    if (indexPath.row == _friends.count-1) {
        cell.bottomLineStyle = CellLineStyleFill;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kRKBHEIGHT(50);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AddHouseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    User *user = _friends[indexPath.row];
    if (user.uidconcert == _dairy.uid) {
        return;
    }
    user.selected = cell.icon.selected = !cell.icon.selected;
    if (cell.icon.selected) {
        [self.selectedFriends addObject:user];
        _headerView.images = _selectedFriends;
        [_headerView.mediaView reloadData];
    }else{
        [self.selectedFriends removeObject:user];
        _headerView.images = _selectedFriends;
        [_headerView.mediaView reloadData];
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


#pragma mark - event response
-(void)Cancel{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)Finish{
    
    if (_selectedFriends.count == 0) {
        [NSObject showHudTipStr:@"必须至少选择一位亲友"];
        return;
    }
    
    if (_selectdeFriendsBlcok) {
        _selectdeFriendsBlcok(_friends,_selectedFriends);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getFriends{
    WEAKSELF
    [[TiHouse_NetAPIManager sharedManager] request_FindersWithHouse:_house Block:^(id data, NSError *error) {
        weakSelf.friends = [User mj_objectArrayWithKeyValuesArray:data];
        
        for (User *user in self.friends) {
            [self.tweet.dairyrangeJAstr enumerateObjectsUsingBlock:^(RangeModel *rangeModel, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([rangeModel.dairyrangeuid integerValue] == user.uidconcert) {
                    user.selected = YES;
                    if (user.uidconcert != [Login curLoginUserID]) [weakSelf.selectedFriends addObject:user];
                }
            }];
        }
        
        for (User *user in _friends) {
            if (user.uidconcert == [Login curLoginUserID]) {
                [_friends removeObject:user];
                break;
            }
        }
//        for (User *user in weakSelf.friends) {
//            if (user.uidconcert == _dairy.uid) {
//                [weakSelf.selectedFriends addObject:user];
//                break;
//            }
//        }
        
        [weakSelf.tableView reloadData];
        weakSelf.headerView.images = _selectedFriends;
        [weakSelf.headerView.mediaView reloadData];
    }];
}

-(NSString *)getFriendRelationship:(NSInteger )index{
    NSString *Relationship;
    switch (index) {
        case 0:
            Relationship = @"关系未选择";
            break;
        case 1:
            Relationship = @"女主人";
            break;
        case 2:
            Relationship = @"男主人";
            break;
        case 3:
            Relationship = @"亲人";
            break;
        case 4:
            Relationship = @"设计方";
            break;
        case 5:
            Relationship = @"施工方";
            break;
        case 6:
            Relationship = @"朋友";
            break;
            
        default:
            break;
    }
    return Relationship;
}


#pragma mark - getters and setters
-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = kRKBViewControllerBgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[AddHouseTableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.estimatedRowHeight = 50;
        _tableView.tableHeaderView = self.headerView;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).mas_offset(UIEdgeInsetsMake(IphoneX ? 88 : 64, 0, 0, 0));
        }];
    }
    return _tableView;
}


-(FriendsHeaderView *)headerView{
    
    if (!_headerView) {
        _headerView = [[FriendsHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

-(NSMutableArray *)selectedFriends{
    if (!_selectedFriends) {
        _selectedFriends = [NSMutableArray new];
    }
    return _selectedFriends;
}

-(NSMutableArray *)friends{
    if (!_friends) {
        _friends = [NSMutableArray new];
    }
    return _friends;
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
