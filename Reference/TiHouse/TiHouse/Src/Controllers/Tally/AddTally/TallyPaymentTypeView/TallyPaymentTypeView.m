//
//  AddTallyPaymentTypeView.m
//  TiHouse
//
//  Created by AlienJunX on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "TallyPaymentTypeView.h"
#import "TallyPaymentTypeViewCell.h"

#define CUSTOM_CONTAINER_HEIGHT  300

@interface TallyPaymentTypeView()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) UITableView *tableView;

@property (weak, nonatomic) UIView *containerView;
@property (strong, nonatomic) NSArray *paymentTypeArray;

@end

@implementation TallyPaymentTypeView

- (id)init {
    self = [super init];
    if (self) {
        // 添加背景
        self.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
        self.backgroundColor = XWColorFromHexAlpha(0x000000, 0.2);
        
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height, kScreen_Width, CUSTOM_CONTAINER_HEIGHT)];
        [self addSubview:containerView];
        containerView.backgroundColor = [UIColor whiteColor];
        self.containerView = containerView;
        
        // title
        UILabel *titleLabel = [UILabel new];
        [containerView addSubview:titleLabel];
        titleLabel.text = @"请选择支付途径";
        titleLabel.textColor = XWColorFromHex(0xb7b7b7);
        [titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(containerView);
            make.centerX.equalTo(containerView);
            make.height.equalTo(@50);
        }];
        
        // lineh
        UIView *lineH = [UIView new];
        lineH.backgroundColor = XWColorFromHex(0xdadada);
        [containerView addSubview:lineH];
        [lineH mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom);
            make.leading.and.trailing.equalTo(containerView);
            make.height.equalTo(@0.5);
        }];
        
        // uitablview
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[TallyPaymentTypeViewCell class] forCellReuseIdentifier:@"cell"];
        [containerView addSubview:tableView];
        self.tableView = tableView;
        [tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.and.bottom.trailing.equalTo(containerView);
            make.top.equalTo(titleLabel.mas_bottom).offset(1);
        }];
        
        UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bgBtn.backgroundColor = [UIColor clearColor];
        [bgBtn addTarget:self action:@selector(bgViewTapAction) forControlEvents:UIControlEventTouchUpInside];
        [self insertSubview:bgBtn atIndex:0];
        [bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];

        _paymentTypeArray = @[@"现金",@"支付宝",@"微信",@"储蓄卡",@"信用卡"];
        
        _selectedIndex = -1;
    }
    return self;
}

- (void)bgViewTapAction {
    [UIView animateWithDuration:0.2 animations:^{
        self.containerView.frame = CGRectMake(0, kScreen_Height, kScreen_Width, CUSTOM_CONTAINER_HEIGHT);
    } completion:^(BOOL finished) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.hidden = YES;
    }];
}


- (void)show {
    self.backgroundColor = XWColorFromHexAlpha(0x000000, 0.2);
    [UIView animateWithDuration:0.2 animations:^{
        self.containerView.frame = CGRectMake(0, kScreen_Height-CUSTOM_CONTAINER_HEIGHT, kScreen_Width, CUSTOM_CONTAINER_HEIGHT);
        
    } completion:^(BOOL finished) {
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.paymentTypeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TallyPaymentTypeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setInfo:self.paymentTypeArray[indexPath.row] isSelected:indexPath.row == self.selectedIndex];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    [tableView reloadData];
    
    if (_selectedBlock) {
        _selectedBlock(self.selectedIndex, _paymentTypeArray[self.selectedIndex]);
        
        [self bgViewTapAction];
    }
}

@end
