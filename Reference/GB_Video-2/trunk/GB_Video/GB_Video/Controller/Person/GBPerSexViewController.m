//
//  GBPerSexViewController.m
//  GB_TransferMarket
//
//  Created by gxd on 17/1/3.
//  Copyright © 2017年 gxd. All rights reserved.
//

#import "GBPerSexViewController.h"

#import "GBPerChooseCell.h"

#import "UserRequest.h"

@interface GBPerSexViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, assign) SexType originSexType;
@property (nonatomic, assign) SexType curSexType;
@property (nonatomic, strong) NSArray *sexTypeArray;
@property (nonatomic, strong) NSArray *sexStringArray;

@end

@implementation GBPerSexViewController

#pragma mark - Life Cycle
- (instancetype)initWithSex:(SexType)sexType {
    if (self = [super init]) {
        _originSexType = sexType;
        _curSexType = sexType;
    }
    return self;
}

- (void)loadData {
    _sexTypeArray = @[@(SexType_Female),@(SexType_Male)];
    _sexStringArray = @[LS(@"personal.label.female"),LS(@"personal.label.male")];
}

-(void)setupUI {
    
    self.title = LS(@"personal.hint.gender");
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
    
    self.saveButton.enabled = (self.curSexType != SexType_Unknow);
}

#pragma mark - Action

- (void)cancelClick {
    [self.navigationController yh_popViewController:self animated:YES];
}

- (void)saveClick {
    
    if (self.curSexType == self.originSexType) {
        BLOCK_EXEC(self.saveBlock, self.curSexType);
        [self.navigationController yh_popViewController:self animated:YES];
    }else {
        UserInfo *userInfo = [RawCacheManager sharedRawCacheManager].userInfo;
        userInfo.sexType = self.curSexType;
        @weakify(self)
        [UserRequest updateUserInfo:userInfo handler:^(id result, NSError *error) {
            
            @strongify(self)
            if (!error) {
                BLOCK_EXEC(self.saveBlock, self.curSexType);
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_User_BaseInfo object:nil];
                
                [self.navigationController yh_popViewController:self animated:YES];
            }else {
                [self showToastWithText:error.domain];
            }
        }];
    }
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
    return [self.sexStringArray count];
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GBPerChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBPerChooseCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.nameLbl.text = self.sexStringArray[indexPath.row];
    cell.selImageView.hidden = ([self.sexTypeArray[indexPath.row] integerValue] != self.curSexType);
    cell.lineView.hidden = (indexPath.row + 1 == [self.sexStringArray count]);
    
    return cell;
    
}

// 选择row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.curSexType = (SexType)[self.sexTypeArray[indexPath.row] integerValue];
    
    [self.tableView reloadData];
    [self checkSaveEnable];
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46.f;
}


@end
