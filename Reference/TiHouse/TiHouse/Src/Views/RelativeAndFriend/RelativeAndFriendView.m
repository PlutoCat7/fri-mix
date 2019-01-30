//
//  RelativeAndFriendView.m
//  TiHouse
//
//  Created by 陈晨昕 on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "RelativeAndFriendView.h"
#import "RelativeAndFriendTableViewCell.h"
#import "UITableView+RegisterNib.h"
#import "RelativeAndFriendHeadView.h"
#import "RelativeAndFriendViewModel.h"
#import "House.h"
#import "Login.h"
#define TABLE_FOOTER_HEIGHT 140
#define LEFT_MARGIN 12
#define TOP_MARGIN 15
#define HORIZON_SPACE 20
#define VERTICAL_SPACE 10
#define BUTTON_HEIGHT 50

@interface RelativeAndFriendView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) RelativeAndFriendHeadView *headView;

@property (nonatomic, strong) RelativeAndFriendViewModel *viewModel;

@property (nonatomic, strong) UIView *tableFooterView;

@end

@implementation RelativeAndFriendView

- (instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    _viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)xl_bindViewModel{
    
    
    
    @weakify(self);
    [self.viewModel.successSubject subscribeNext:^(id x) {
        @strongify(self);
        self.headView.masters = self.viewModel.masters;
        self.headView.house = self.viewModel.house;
        [self.tableView reloadData];
    }];
    
}

- (void)xl_setupViews{
    [self addSubview:self.tableView];
    [self configTableView];
    [self updateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)configTableView{
    self.tableView.tableHeaderView = self.headView;
    
    [self.tableView registerNibName:NSStringFromClass([RelativeAndFriendTableViewCell class])];
}

- (void)updateConstraints{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    [super updateConstraints];
}

- (RelativeAndFriendHeadView *)headView{
    if (!_headView) {
        _headView = [RelativeAndFriendHeadView sharedInstanceWithViewModel:nil];
        _headView.frame = CGRectMake(0, 0, kScreen_Width, 164);
        WS(weakSelf);
        _headView.callback = ^(Houseperson *per) {
            
            if (per) {
                [weakSelf.viewModel.cellClickSubject sendNext:per];
            } else {
                [weakSelf.viewModel.cellClickSubject sendNext:nil];
            }
            
        };
    }
    return _headView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-kNavigationBarHeight) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGBA(248, 248, 248, 1);
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.tableFooterView = [self tableFooterView];
    }
    return _tableView;
}

- (UIView *)tableFooterView {
    if (!_tableFooterView) {
        _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, TABLE_FOOTER_HEIGHT)];
        [self setupInviteButtons];
    }
    return _tableFooterView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.others.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RelativeAndFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RelativeAndFriendTableViewCell class]) forIndexPath:indexPath];
    [cell loadViewWtithModel:self.viewModel.others[indexPath.row]];
    cell.isLastRow = indexPath.row == self.viewModel.others.count - 1;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.viewModel.cellClickSubject sendNext:self.viewModel.others[indexPath.row]];
}

- (void)setupInviteButtons {
    CGFloat buttonWidth = (kScreen_Width - LEFT_MARGIN * 2 - HORIZON_SPACE) / 2.0;
    NSArray *titleArray = @[@"  亲人", @"  朋友", @"  设计方", @"  施工方"];
    for (NSInteger i = 0; i < titleArray.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        [_tableFooterView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(BUTTON_HEIGHT);
            make.left.mas_equalTo(LEFT_MARGIN + (buttonWidth + HORIZON_SPACE) * (i % 2));
            make.top.mas_equalTo(TOP_MARGIN + (BUTTON_HEIGHT + VERTICAL_SPACE) * (i / 2));
            make.width.mas_equalTo(buttonWidth);
        }];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.5];
        [button setTitleColor:[UIColor colorWithHexString:@"0xbfbfbf"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"invite_plus"] forState:UIControlStateNormal];
        button.layer.cornerRadius = 3;
        button.layer.borderWidth = 1;
        button.backgroundColor = [UIColor whiteColor];
        button.layer.borderColor = [UIColor colorWithHexString:@"0xdbdbdb"].CGColor;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 0x1000 + i;
    }
}

- (void)buttonClick:(UIButton *)sender {
    if (self.viewModel.house.uidcreater != [Login curLoginUser].uid) {
        [NSObject showHudTipStr:@"只有房屋创建者可以邀请亲友"];
    } else {
        if (_inviteCallback) {
            _inviteCallback(sender.tag - 0x1000);
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
