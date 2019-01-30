//
//  RemindListVC.m
//  TiHouse
//  提醒列表界面
//
//  Created by ccx on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "RemindListVC.h"
#import "RemindListView.h"

@interface RemindListVC ()
@property (strong, nonatomic) RemindListView * remindListView;

@end

@implementation RemindListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"通知";
    
    [self addSubviews];
    [self bindViewModel];
}

-(void)addSubviews {
    [self.view addSubview:self.remindListView];
}

#pragma mark - model action
-(void)bindViewModel {
    
}

- (void)updateViewConstraints{
    
    [self.remindListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64 + kNavigationBarTop);
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kScreen_Width);
    }];
    [super updateViewConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - get fun
-(RemindListView *)remindListView {
    if (!_remindListView) {
        _remindListView = [RemindListView shareInstanceWithViewModel:nil];
        _remindListView.scheduletiptype = self.scheduletiptype;
        
        WEAKSELF;
        _remindListView.SelectRemindBlock = ^(NSString *value, NSInteger index) {
            if (weakSelf.remindListSelectBlock) {
                weakSelf.remindListSelectBlock(value, index);
            }
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    return _remindListView;
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
