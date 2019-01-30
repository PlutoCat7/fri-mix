//
//  SettingAuthorityViewController.m
//  TiHouse
//
//  Created by apple on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "SettingAuthorityViewController.h"
#import "SettingAuthView.h"

@interface SettingAuthorityViewController ()

@property (nonatomic, strong) SettingAuthView *authView;

@end

@implementation SettingAuthorityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self xl_addSubviews];
    [self xl_getNewData];
}

- (void)xl_getNewData{
    self.authView.person = self.person;
    self.authView.isMaster = self.isMaster;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isExtendLayout = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isExtendLayout = NO;
}

- (void)xl_addSubviews{
    [self.view addSubview:self.authView];
    [self updateViewConstraints];
}

- (void)updateViewConstraints{
    
    [self.authView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    [super updateViewConstraints];
}

- (SettingAuthView *)authView{
    if (!_authView) {
        _authView = [SettingAuthView sharedInstanceWithViewModel:nil];
    }
    return _authView;
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
