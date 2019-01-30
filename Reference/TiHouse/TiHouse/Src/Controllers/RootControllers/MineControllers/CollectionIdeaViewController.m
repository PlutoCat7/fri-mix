//
//  CollectionIdeaViewController.m
//  TiHouse
//
//  Created by admin on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CollectionIdeaViewController.h"
#import "CollectionSoulFolderTableViewCell.h"
#import "SoulFolderCreateTableViewCell.h"
#import "Login.h"
#import "AllPicturesViewController.h"
#import "SubSoulFolderController.h"
#import "SoulFolder.h"
#import "AddSouFolderController.h"

@interface CollectionIdeaViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) int allPictureCount;
@end

@implementation CollectionIdeaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏-灵感册";
    _soulfolderList = [[NSMutableArray alloc] init];
    _allPictureCount = 0;
    
    [self tableView];
    [self getSoulFolders];
    [self receiveNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    } else {
        return _soulfolderList ? [_soulfolderList count] + 1 : 1;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.row == _soulfolderList.count) {
        return NO;
    }
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    User *user = [Login curLoginUser];
    WEAKSELF
    NSString *mess = [NSString stringWithFormat:@"确定要删除%@?",
                       [_soulfolderList[indexPath.row]soulfoldername]] ;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"删除灵感册" message:mess              preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/soulfolder/remove" withParams:@{@"uid": @(user.uid), @"soulfolderid": @([_soulfolderList[indexPath.row] soulfolderid])} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
            if ([data[@"is"] integerValue]) {
                [NSObject showHudTipStr:data[@"msg"]];
                [weakSelf reload];
            } else {
                [NSObject showHudTipStr:data[@"msg"]];
            }
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:deleteAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    NSInteger tmp = _soulfolderList ? [_soulfolderList count] : 0;
    if (indexPath.section == 0) {
        CollectionSoulFolderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[CollectionSoulFolderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        SoulFolder *sf = [SoulFolder new];
        sf.soulfoldername = @"全部图片";
        sf.countAssemblefile = _allPictureCount;
        cell.soulfolder = sf;
        return cell;
    } else {
        if (indexPath.row >= tmp) {
            SoulFolderCreateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addCell"];
            if (!cell) {
                cell = [[SoulFolderCreateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addCell"];
            }
            cell.topLineStyle = CellLineStyleFill;
            cell.bottomLineStyle = CellLineStyleFill;
            return cell;
        } else {
            CollectionSoulFolderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[CollectionSoulFolderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            cell.soulfolder = [SoulFolder mj_objectWithKeyValues:_soulfolderList[indexPath.row]];
            cell.topLineStyle = CellLineStyleFill;
            cell.bottomLineStyle = CellLineStyleFill;
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kRKBHEIGHT(60);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((indexPath.section == 1) && (indexPath.row + 1> ([_soulfolderList count]))) {
        WEAKSELF
        AddSouFolderController *addVC = [[AddSouFolderController alloc] init];
        [addVC setCallback:^{
            [weakSelf reload];
        }];
        [self.navigationController pushViewController:addVC animated:YES];
    }
    if (indexPath.section == 0) {
        AllPicturesViewController *allPictureVC = [AllPicturesViewController new];
        allPictureVC.soulFolderList = _soulfolderList;
        [self.navigationController pushViewController:allPictureVC animated:YES];
    }
    if ((indexPath.section == 1) && (indexPath.row + 1 <= [_soulfolderList count])) {
        SubSoulFolderController *subSoulFolderVC = [[SubSoulFolderController alloc] init];
        subSoulFolderVC.soulFolder = _soulfolderList[indexPath.row];
        
        NSMutableArray *array = [_soulfolderList mutableCopy];
        
        [array removeObjectAtIndex:indexPath.row];
        subSoulFolderVC.soulFolderList = array;
        [self.navigationController pushViewController:subSoulFolderVC animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        return view;
    } else {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        view.backgroundColor = [UIColor clearColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kRKBWIDTH(15), 5, tableView.frame.size.width, 40)];
        label.text = @"灵感册";
        label.textColor = [UIColor colorWithHexString:@"9999999"];
        label.font = [UIFont systemFontOfSize:16];
        [view addSubview:label];

        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


#pragma mark - getters and setters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).mas_offset(UIEdgeInsetsMake(kNavigationBarHeight, 0, 0, 0));
        }];
        WEAKSELF
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf getSoulFolders];
        }];
    }
    return _tableView;
}

- (void)getSoulFolders {
    [_soulfolderList removeAllObjects];
    User *user = [Login curLoginUser];
    WEAKSELF
    [weakSelf.view beginLoading];
     // MARK: - showdefault 2 表示不在灵感册列表显示全部图片灵感册
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/soulfolder/listByUid" withParams:@{@"uid":[NSString stringWithFormat:@"%ld", user.uid], @"showdefault": @2} withMethodType:Get autoShowError:YES andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue]) {

            for (NSDictionary *dic in data[@"data"]) {
                SoulFolder *sf = [SoulFolder mj_objectWithKeyValues:dic];
                [_soulfolderList addObject:sf];
            }
            _allPictureCount = [data[@"allCount"] intValue];
            [weakSelf.tableView reloadData];

        } else {
            NSLog(@"%@", error);
        }
        [weakSelf.view endLoading];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - NSNotificationCenter
- (void)receiveNotification {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(reload) name:editSoulFolderNameNotification object:nil];
    [nc addObserver:self selector:@selector(reload) name:deleteSoulFolderNotification object:nil];
    [nc addObserver:self selector:@selector(reload) name:editSoulFolderContentNotification object:nil];
}

- (void)reload {
    [self getSoulFolders];
}

- (void)dealloc {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

@end



