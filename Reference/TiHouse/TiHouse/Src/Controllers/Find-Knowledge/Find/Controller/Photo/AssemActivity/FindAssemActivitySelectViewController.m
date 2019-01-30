//
//  FindAssemActivitySelectViewController.m
//  TiHouse
//
//  Created by yahua on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindAssemActivitySelectViewController.h"

#import "FindAssemActivitySelectCell.h"

#import "FindAssemActivityRequest.h"

@interface FindAssemActivitySelectViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) FindAssemActivityInfo *selectAssemActivityInfo;
@property (nonatomic, strong) NSArray<FindAssemActivityInfo *> *dataList;
@property (nonatomic, copy) void(^doneBlock)(FindAssemActivityInfo *selectActivityInfo);

@end

@implementation FindAssemActivitySelectViewController

- (instancetype)initWithActivityInfo:(FindAssemActivityInfo *)activiInfo doneBlock:(void(^)(FindAssemActivityInfo *selectActivityInfo))doneBlock {
    
    self = [super init];
    if (self) {
        _selectAssemActivityInfo = activiInfo;
        _doneBlock = doneBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)loadData {
    
    [NSObject showHUDQueryStr:nil];
    WEAKSELF
    [FindAssemActivityRequest getActivityListWithHandler:^(id result, NSError *error) {
        
        if (!error) {
            weakSelf.dataList = result;
            [weakSelf.tableView reloadData];
        }
        [NSObject hideHUDQuery];
    }];
}

- (void)setupUI {
    
    [self wr_setNavBarBarTintColor:XWColorFromHex(0xfcfcfc)];
    self.title = @"正在进行的美家征集";
    
    [self setupTableView];
}

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FindAssemActivitySelectCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FindAssemActivitySelectCell class])];
    self.tableView.rowHeight = kFindAssemActivitySelectCellHeight;
}

#pragma mark - UITableViewDelegate

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}

// section头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FindAssemActivitySelectCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FindAssemActivitySelectCell class])];
    FindAssemActivityInfo *info = _dataList[indexPath.row];
    [cell refreshWithName:info.assemtitle isSelect:info.assemid==self.selectAssemActivityInfo.assemid];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FindAssemActivityInfo *info = _dataList[indexPath.row];
    if (info.assemid == self.selectAssemActivityInfo.assemid) {
        self.selectAssemActivityInfo = nil;
    }else {
        self.selectAssemActivityInfo = info;
    }
    [self.tableView reloadData];
    if (_doneBlock) {
        _doneBlock(self.selectAssemActivityInfo);
    }
}

@end
