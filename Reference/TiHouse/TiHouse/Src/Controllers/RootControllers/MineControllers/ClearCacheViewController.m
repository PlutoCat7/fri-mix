//
//  ClearCacheViewController.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ClearCacheViewController.h"
#import "ClearCacheTableViewCell.h"
#import "MineTableFooter.h"

@interface ClearCacheViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *UIModels;

@end

@implementation ClearCacheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"清理占用空间";
    [self tableView];
    self.UIModels = [UIHelp getClearCacheUI];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getters && setters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(@(kNavigationBarHeight));
            make.height.equalTo(@290);
        }];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.UIModels count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.UIModels[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId;
    
    if (indexPath.section == 0) {
        cellId = @"totalCellId";
    } else {
        cellId = @"subCellId";
    }
    
    ClearCacheTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ClearCacheTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        cell.subLabel.text = [self getSize];
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        cell.subLabel.text = @"0.0K";
    } else {
        cell.subLabel.text = [self getSize];
    }
    
    if (indexPath.row == 0) {
        cell.topLineStyle = CellLineStyleFill;
    } else if (indexPath.row == 1) {
        cell.bottomLineStyle = CellLineStyleFill;
    }
    
    cell.titleLabel.text = [_UIModels[indexPath.section][indexPath.row] Title];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 0 ? 10 : 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ClearCacheTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) return;
    [self showAlerts:cell.titleLabel.text completion:^(BOOL b) {
        if (b) {
            
        } else {
            [[SDImageCache sharedImageCache] clearMemory];
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
            [_tableView reloadData];
        }
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return [[MineTableFooter alloc] initWithFrame:CGRectMake(0, 0, 0, 50) title:@"点击对应选项可以清空，释放存储空间"];
    }
    return nil;
}

#pragma mark - private method
- (void)showAlerts:(NSString *)title completion:(void(^)(BOOL))completion {
    
    NSString *totalString = [NSString stringWithFormat:@"确定要清除\"%@\"",title];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:totalString preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *clearAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completion([title isEqualToString:@"下载占用"]);
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:clearAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - private method
- (NSString *)getSize {
    NSUInteger tmpSize = [[SDImageCache sharedImageCache] getSize];
    NSString *cacheName;
    if (tmpSize >= 1024 * 1024 * 1024) {
        cacheName = [NSString stringWithFormat:@"%.2fG", tmpSize/(1024.f*1024.f*1024.f)];
    } else if (tmpSize >= 1024 * 1024) {
        cacheName = [NSString stringWithFormat:@"%.2fM", tmpSize/(1024.f*1024.f)];
    } else {
        cacheName = [NSString stringWithFormat:@"%.2fK", tmpSize/1024.f];
    }
    return cacheName;
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
