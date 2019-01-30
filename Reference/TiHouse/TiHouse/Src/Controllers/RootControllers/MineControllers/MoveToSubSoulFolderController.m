//
//  MoveToSubSoulFolderController.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "MoveToSubSoulFolderController.h"
#import "SoulFolder.h"
#import "Login.h"
#import "AssemarcFile.h"

static CGFloat table_header_height = 50;

NSString * const editSoulFoldeContentNotification = @"editSoulFolderContentNotification";

@interface MoveToSubSoulFolderController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation MoveToSubSoulFolderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self cancelButton];
    [self tableView];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self tapCancelGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.scrollEnabled = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_cancelButton.mas_top).offset(-8);
            make.height.equalTo(@(_soulFoldersArray.count * 50 + table_header_height));
            make.left.right.equalTo(_cancelButton);
        }];
    }
    return _tableView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.view addSubview:_cancelButton];
        [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.view);
            make.height.equalTo(@50);
        }];
        _cancelButton.titleLabel.font = ZISIZE(12);
        [_cancelButton setTitleColor:kColorNavTitle forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _soulFoldersArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.font = ZISIZE(12);
    cell.textLabel.textColor = kColorNavTitle;
    cell.textLabel.text = [_soulFoldersArray[indexPath.row] soulfoldername];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return table_header_height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_selectedItems.count == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"未选中任何图片" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        NSString *message = [NSString stringWithFormat:@"确定要移动到%@灵感册么?",
                             [_soulFoldersArray[indexPath.row] soulfoldername]];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *moveAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self moveToSoulFolder:indexPath.row];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        [alert addAction:cancel];
        [alert addAction:moveAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] init];
    label.font = ZISIZE(11);
    label.textColor = [UIColor colorWithHexString:@"bfbfbf"];
    label.text = @"选择灵感册";
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(@12);
    }];
    return view;
}

#pragma mark - private method
- (void)tapCancelGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)];
    [tap setDelegate:self];
    [self.view addGestureRecognizer:tap];
}

- (void)moveToSoulFolder:(NSInteger)soulFolderIndex {
    
    NSMutableString *str = [NSMutableString string];
    for (AssemarcFile *af in _selectedItems) {
        [str appendString:[NSString stringWithFormat:@"%ld",af.assemfileid]];
        [str appendString:@","];
    }
    [str deleteCharactersInRange:NSMakeRange(str.length - 1, 1)];
    NSLog(@"picture link: %@", str);
    WEAKSELF
    [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/assemarcfile/editArr" withParams:@{@"uid": [NSNumber numberWithLong:[[Login curLoginUser] uid]], @"soulfolderid": @([_soulFoldersArray[soulFolderIndex] soulfolderid]), @"assemfileids": str} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue]) {
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc postNotificationName:editSoulFoldeContentNotification object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
            [NSObject showHudTipStr:@"移动成功"];
        } else {
            [NSObject showHudTipStr:data[@"msg"]];
        }
    }];
}

#pragma mark - Target Action
- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.tableView]) {
        return NO;
    }
    return YES;
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
