//
//  FriendsRangeViewController.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/16.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "SelectRecordingTimeViewController.h"
#import "AddHouseTableViewCell.h"
#import "BRPickerView.h"
#import "NSDate+BRAdd.h"
@interface SelectRecordingTimeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *UIModels;
@property (nonatomic, strong) NSString *shotTime;

@end

@implementation SelectRecordingTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择记录时间";
    self.UIModels = [UIHelp getRecordingTimeUI];
    _shotTime = [self maxTimestamp:_images];
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
    if (_isEdit) {
        cell.Title.text = indexPath.row == 1 ? @"创建时间" : uimodel.Title;
    } else {
        cell.Title.text = uimodel.Title;
    }
    if (indexPath.row == 0) {
        if (_images.count == 0) {
            cell.TextField.text = @"";
        } else {
            cell.TextField.text = _shotTime.length != 0 ? _shotTime : uimodel.TextFieldPlaceholder;
        }
    } else {
        if (_isEdit) {
            if (_index == 2) {
                cell.TextField.text = [[[NSDate alloc] initWithTimeIntervalSince1970:_tweet.dairy.dairy.diytime/1000] ymdFormat];
            }
            if (indexPath.row == 1) {
                cell.TextField.text = [[[NSDate alloc] initWithTimeIntervalSince1970:_tweet.dairy.dairy.createtime/1000] ymdFormat];
            }
        } else {
            cell.TextField.text = uimodel.TextFieldPlaceholder;
        }
    }
    cell.TextField.userInteractionEnabled = NO;
    cell.icon.selected = NO;
    [cell.icon setImage:[UIImage imageNamed:@"relationBtnselect"] forState:UIControlStateSelected];
    if (indexPath.row == _index) {
        cell.icon.selected = YES;
    }
    if (indexPath.row == 0 && _shotTime.length == 0) {
        cell.TextField.font = [UIFont systemFontOfSize:10];
    }
//    if (indexPath.row == 2) {
//        [cell.contentView addSubview:self.dayTF];
//    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kRKBHEIGHT(50);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _index = indexPath.row;
    [tableView reloadData];
    WEAKSELF
    AddHouseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 2) {
        [BRDatePickerView showDatePickerWithTitle:@"" dateType:UIDatePickerModeDate defaultSelValue:@"" minDateStr:nil maxDateStr:[NSDate currentDateString] isAutoSelect:NO themeColor:nil resultBlock:^(NSString *selectValue) {
            if (weakSelf.selectdeTimeBlcok) {
                weakSelf.selectdeTimeBlcok(selectValue,weakSelf.index);
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } cancelBlock:^{
            XWLog(@"点击了背景或取消按钮");
        }];
        return;
    }
    if (_selectdeTimeBlcok) {
        _selectdeTimeBlcok(cell.TextField.text,weakSelf.index);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - event response
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
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.automaticallyAdjustsScrollViewInsets = YES;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).mas_offset(UIEdgeInsetsMake(IphoneX ? 88 : 64, 0, 0, 0));
        }];
    }
    return _tableView;
}


- (NSString *)maxTimestamp:(NSArray *)array {
    if (array.count == 0) return @"";
    __block NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:0];
    [array enumerateObjectsUsingBlock:^(TweetImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        lastDate = [lastDate laterDate:obj.creationDate];
    }];
    return [lastDate ymdFormat] ;
}


@end
