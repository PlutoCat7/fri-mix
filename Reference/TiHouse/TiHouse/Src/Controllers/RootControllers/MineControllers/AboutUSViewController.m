//
//  AboutUSViewController.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AboutUSViewController.h"
#import "AboutUSTableViewCell.h"
#import "CustomerServiceChatViewController.h"
#import "HelpCenterViewController.h"
#import "TermServiceViewController.h"

#define kAppId @"1358579360"

@interface AboutUSViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *UIModels;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;

@end

@implementation AboutUSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于有数啦";
    [self tableView];
    self.UIModels = [UIHelp getAboutUSUI];
    [self label1];
    [self label2];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getters && setters

- (UILabel *)label1 {
    if (!_label1) {
        _label1 = [[UILabel alloc] init];
        [self.view addSubview:_label1];
        _label1.font = ZISIZE(10);
        _label1.text = @"免责信息和版权声明";
        _label1.textColor = [UIColor colorWithHexString:@"bfbfbf"];
        [_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(@-40);
        }];
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(label1Click)];
        [_label1 addGestureRecognizer:labelTapGestureRecognizer];
        _label1.userInteractionEnabled = YES;
    }
    return _label1;
}

- (UILabel *)label2 {
    if (!_label2) {
        _label2 = [[UILabel alloc] init];
        [self.view addSubview:_label2];
        _label2.font = ZISIZE(10);
        _label2.text = @"Copyright ©2017 youshula.com.cn all right reserved";
        _label2.textColor = [UIColor colorWithHexString:@"bfbfbf"];
        [_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(@-20);
        }];
    }
    return _label2;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.scrollEnabled = NO;
        _tableView.tableHeaderView = [self _logoView];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(@(kNavigationBarHeight));
            make.height.equalTo(@290);
        }];

    }
    return _tableView;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    AboutUSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[AboutUSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (indexPath.row == 0) {
        cell.topLineStyle = CellLineStyleFill;
    }
    cell.titleLabel.text = [self.UIModels[indexPath.row] Title];
    cell.subLabel.text = [self.UIModels[indexPath.row] TextFieldPlaceholder];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?action=write-review",kAppId]];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication]openURL:url];
        }
    }
    else if (indexPath.section == 0 && indexPath.row == 2) {
        CustomerServiceChatViewController *rcclvc = [CustomerServiceChatViewController new];
        rcclvc.title = @"有数啦客服";
        rcclvc.conversationType = ConversationType_CUSTOMERSERVICE;
        rcclvc.targetId = RY_KEFU_ID;
        [self.navigationController pushViewController:rcclvc animated:YES];
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        HelpCenterViewController *helpVC = [[HelpCenterViewController alloc] init];
        [self.navigationController pushViewController:helpVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - private method
- (UIView *)_logoView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 140)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *logoImgv = [[UIImageView alloc] init];
    [view addSubview:logoImgv];
    [logoImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(@26);
        make.size.equalTo(@72);
    }];
    logoImgv.layer.cornerRadius = 8;
    logoImgv.layer.masksToBounds = YES;
    logoImgv.image = [UIImage imageNamed:@"mine_logo"];
    logoImgv.backgroundColor = [UIColor redColor];
    
    UILabel *label = [[UILabel alloc] init];
    [view addSubview:label];
    label.font = ZISIZE(10);
    label.text = [NSString stringWithFormat:@"有数啦 V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    label.textColor = [UIColor colorWithHexString:@"bfbfbf"];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(logoImgv.mas_bottom).offset(10);
    }];
    
    return view;
}

-(void) label1Click {
    TermServiceViewController *helpVC = [[TermServiceViewController alloc] init];
    [self.navigationController pushViewController:helpVC animated:YES];
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
