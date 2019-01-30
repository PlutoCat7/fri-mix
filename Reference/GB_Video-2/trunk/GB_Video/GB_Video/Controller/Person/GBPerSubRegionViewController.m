//
//  GBPerSubRegionViewController.m
//  GB_TransferMarket
//
//  Created by gxd on 17/1/4.
//  Copyright © 2017年 gxd. All rights reserved.
//

#import "GBPerSubRegionViewController.h"

#import "GBPerChooseCell.h"

@interface GBPerSubRegionViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, strong) AreaInfo *areaInfo;
@property (nonatomic, assign) NSInteger curCityId;

@end

@implementation GBPerSubRegionViewController

- (instancetype)initWithRegion:(AreaInfo *)areaInfo cityId:(NSInteger)cityId {
    if (self = [super init]) {
        _areaInfo = areaInfo;
        _curCityId = cityId;
    }
    return self;
}

- (void)loadData {
}

-(void)setupUI {
    
    self.title = LS(@"personal.hint.region");
    [self setupBackButtonWithBlock:nil];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"GBPerChooseCell" bundle:nil] forCellReuseIdentifier:@"GBPerChooseCell"];
    
    [self setupNavigationBarLeft];
    [self setupNavigationBarRight];
    
    [self checkSaveEnable];
}

- (void)setupNavigationBarLeft {
    
    UIButton *leftMenuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftMenuBtn setSize:CGSizeMake(60, 24)];
    [leftMenuBtn.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    [leftMenuBtn setTitle:LS(@"common.btn.cancel") forState:UIControlStateNormal];
    [leftMenuBtn setTitle:LS(@"common.btn.cancel") forState:UIControlStateHighlighted];
    [leftMenuBtn setTitleColor:[ColorManager textColor] forState:UIControlStateNormal];
    [leftMenuBtn setTitleColor:[ColorManager textColor] forState:UIControlStateHighlighted];
    leftMenuBtn.backgroundColor = [UIColor clearColor];
    [leftMenuBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:leftMenuBtn];
    [self.navigationItem setLeftBarButtonItem:leftButton];
}

- (void)setupNavigationBarRight {
    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveButton setSize:CGSizeMake(48, 24)];
    [self.saveButton.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    [self.saveButton setTitle:LS(@"common.btn.save") forState:UIControlStateNormal];
    [self.saveButton setTitle:LS(@"common.btn.save") forState:UIControlStateHighlighted];
    [self.saveButton setTitleColor:[ColorManager textColor] forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[ColorManager textColor] forState:UIControlStateDisabled];
    self.saveButton.backgroundColor = [UIColor clearColor];
    self.saveButton.enabled = NO;
    [self.saveButton addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:self.saveButton];
    rightButton.enabled = NO;
    [self.navigationItem setRightBarButtonItem:rightButton];
}

- (void)checkSaveEnable {
    
    BOOL enabled = NO;
    for (AreaInfo *info in self.areaInfo.areaChidlArray) {
        if (info.areaID == self.curCityId) {
            enabled = YES;
            break;
        }
    }
    self.saveButton.enabled = enabled;
}

#pragma mark - Action

- (void)cancelClick {
    [self.navigationController yh_popViewController:self animated:YES];
}

- (void)saveClick {
    
    BLOCK_EXEC(self.saveBlock, self.curCityId);
}

#pragma mark - Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.f;
}

// section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.areaInfo.areaChidlArray count];
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GBPerChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBPerChooseCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    AreaInfo *areaInfo = self.areaInfo.areaChidlArray[indexPath.row];
    cell.nameLbl.text = areaInfo.areaName;
    cell.selImageView.hidden = (areaInfo.areaID != self.curCityId);
    cell.lineView.hidden = (indexPath.row + 1 == [self.areaInfo.areaChidlArray count]);
    
    return cell;
    
}

// 选择row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AreaInfo *areaInfo = self.areaInfo.areaChidlArray[indexPath.row];
    self.curCityId = areaInfo.areaID;
    
    [self.tableView reloadData];
    [self checkSaveEnable];
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46.f;
}


@end
