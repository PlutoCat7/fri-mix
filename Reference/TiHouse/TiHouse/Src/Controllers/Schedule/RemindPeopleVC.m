//
//  RemindPeopleVC.m
//  TiHouse
//
//  Created by 陈晨昕 on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "RemindPeopleVC.h"
#import "RemindPeopleView.h"

@interface RemindPeopleVC ()
@property (strong, nonatomic) RemindPeopleView * remindPeopleView;

@end

@implementation RemindPeopleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"提醒谁看";
    
    self.navigationItem.hidesBackButton = YES;
    [self addBackBtn];
    [self addSureBtn];
    
    [self addSubviews];
    [self bindViewModel];
}

-(void)addSubviews {
    [self.view addSubview:self.remindPeopleView];
}

#pragma mark - model action
-(void)bindViewModel {
    
}

#pragma mark - add back btn
-(void)addBackBtn {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 32, 32);
    [btn addTarget:self action:@selector(cancleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:XWColorFromRGB(38,38,38) forState:UIControlStateNormal];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:btn];

    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -10;
    self.navigationItem.leftBarButtonItems = @[spaceItem, leftItem];
}

-(void)cancleBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 添加搜索按钮
- (void)addSureBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 36, 36);
    [btn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:XWColorFromRGB(38,38,38) forState:UIControlStateNormal];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -10;
    self.navigationItem.rightBarButtonItems = @[spaceItem, rightItem];
}

-(void)sureBtnAction:(UIButton *)sender {
    if (_RemindPeopleBlock) {
        _RemindPeopleBlock(self.remindPeopleView.selectPeopleArray);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateViewConstraints {
    
    [self.remindPeopleView mas_makeConstraints:^(MASConstraintMaker *make) {
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

-(RemindPeopleView *)remindPeopleView {
    if (!_remindPeopleView) {
        _remindPeopleView = [RemindPeopleView shareInstanceWithViewModel:nil withHouse:self.house];
        _remindPeopleView.schedulearruidtip = self.schedulearruidtip;
    }
    return _remindPeopleView;
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
