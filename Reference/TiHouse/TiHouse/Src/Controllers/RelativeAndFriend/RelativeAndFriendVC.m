//
//  RelativeAndFriendVC.m
//  TiHouse
//  亲友界面
//
//  Created by ccx on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "RelativeAndFriendVC.h"
#import "RelativeAndFriendView.h"
#import "RelativeAndFriendViewModel.h"
#import "RelativeFriDetailTableViewController.h"
#import "SendInvitationViewController.h"
#import "Login.h"

@interface RelativeAndFriendVC ()

@property (nonatomic, strong) RelativeAndFriendView *relFriView;
@property (nonatomic, strong) RelativeAndFriendViewModel *relFriViewModel;

@end

@implementation RelativeAndFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"亲友";
    [self setupSubViews];
    [self xl_bindViewModel];
    
    
    if (@available(iOS 11.0, *)) {
        self.automaticallyAdjustsScrollViewInsets = YES;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    WEAKSELF;
    self.relFriView.inviteCallback = ^(NSInteger tag) {
        [weakSelf btn_yaoqingAction:nil];
    };
}

- (void)xl_bindViewModel{
    @weakify(self);
    [self.relFriViewModel.cellClickSubject subscribeNext:^(id x) {
        @strongify(self);
        
        if (x) {
            UIStoryboard *std = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            RelativeFriDetailTableViewController *rdVC = [std instantiateViewControllerWithIdentifier:NSStringFromClass([RelativeFriDetailTableViewController class])];
            rdVC.person = x;
            rdVC.house = self.house;
            [self.navigationController pushViewController:rdVC animated:YES];
        } else {
            [self btn_yaoqingAction:nil];
        }
        
        
    }];
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (@available(iOS 11, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self.relFriViewModel loadData];
    
}


- (void)setupSubViews{
    [self.view addSubview:self.relFriView];
    
    User *user = [Login curLoginUser];
    
    if (self.house.uidcreater == user.uid) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"邀请" style:UIBarButtonItemStylePlain target:self action:@selector(btn_yaoqingAction:)];

    }
    
    [self updateViewConstraints];
    
}

-(void) btn_yaoqingAction:(id) sender{
    UIStoryboard *std = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    SendInvitationViewController *siVC = [std instantiateViewControllerWithIdentifier:NSStringFromClass([SendInvitationViewController class])];
    siVC.house = self.house;
    
    [self.navigationController pushViewController:siVC animated:YES];
    
}




- (void)updateViewConstraints{
    
    [self.relFriView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.top.mas_equalTo(64);
        make.width.mas_equalTo(kScreen_Width);
    }];
    
    [super updateViewConstraints];
}

- (RelativeAndFriendView *)relFriView{
    if (!_relFriView) {
        _relFriView = [[RelativeAndFriendView alloc] initWithViewModel:self.relFriViewModel];
    }
    return _relFriView;
}
- (RelativeAndFriendViewModel *)relFriViewModel{
    if (!_relFriViewModel) {
        _relFriViewModel = [[RelativeAndFriendViewModel alloc] init];
        _relFriViewModel.houseId = self.house.houseid;
        _relFriViewModel.house = self.house;
    }
    return _relFriViewModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
