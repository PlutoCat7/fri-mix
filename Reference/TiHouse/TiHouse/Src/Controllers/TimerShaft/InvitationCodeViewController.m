//
//  InvitationCodeViewController.m
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/17.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#define NUM @"0123456789"
#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

#import "InvitationCodeViewController.h"
#import "Houseperson.h"
#import "XWAlertView.h"
#import "PerfectRelationViewController.h"

@interface InvitationCodeViewController ()<UITextFieldDelegate>
{
    UITextField *textField;
}
@property (nonatomic, retain) Houseperson *houseperson;
@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator;

@end

@implementation InvitationCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"输入邀请码";
    self.view.backgroundColor = kTiMainBgColor;
    
    UIView *shadow = [[UIView alloc]init];
    shadow.backgroundColor = [UIColor whiteColor];
    shadow.layer.cornerRadius = 8.f;
    shadow.layer.shadowColor = [UIColor orangeColor].CGColor;
    shadow.layer.shadowRadius = 4;
    shadow.layer.shadowOffset = CGSizeMake(1, 1);
    shadow.layer.shadowOpacity = 0.2;
    [self.view addSubview:shadow];
    [shadow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(33);
        make.right.equalTo(self.view).offset(-33);
        make.top.equalTo(self.view).offset(kDevice_Is_iPhoneX?88+85:64+85);
        make.height.equalTo(@(160));
    }];
    
    UIView *dialogBox = [[UIView alloc]init];
    dialogBox.backgroundColor = [UIColor whiteColor];
//    dialogBox.layer.masksToBounds = YES;
    dialogBox.layer.cornerRadius = 8.f;
    dialogBox.layer.shadowColor = [UIColor orangeColor].CGColor;
    dialogBox.layer.shadowRadius = 4;
    dialogBox.layer.shadowOffset = CGSizeMake(-1, -1);
    dialogBox.layer.shadowOpacity = 0.2;
    [self.view addSubview:dialogBox];
    [dialogBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(33);
        make.right.equalTo(self.view).offset(-33);
        make.top.equalTo(self.view).offset(kDevice_Is_iPhoneX?88+85:64+85);
        make.height.equalTo(@(160));
    }];

    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"验证" forState:UIControlStateNormal];
    [btn setTitleColor:XWColorFromHex(0x5186aa) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goClick:) forControlEvents:UIControlEventTouchUpInside];
    [dialogBox addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dialogBox);
        make.right.equalTo(dialogBox);
        make.bottom.equalTo(dialogBox);
        make.height.equalTo(@(60));
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kLineColer;
    [dialogBox addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn);
        make.right.equalTo(btn);
        make.bottom.equalTo(btn.mas_top);
        make.height.equalTo(@(0.5));
    }];
    
    textField = [[UITextField alloc]init];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.textColor = kTitleAddHouseTitleCOLOR;
    textField.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:25];
    textField.keyboardType = UIKeyboardTypeASCIICapable;
    textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    textField.delegate = self;
    [dialogBox addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dialogBox);
        make.right.equalTo(dialogBox);
        make.bottom.equalTo(line.mas_top);
        make.top.equalTo(dialogBox);
    }];
    [textField becomeFirstResponder];
    
    
    UILabel *text = [[UILabel alloc]init];
    text.text = @"邀请码在您收到的短信或微信邀请中";
    text.textAlignment = NSTextAlignmentCenter;
    text.textColor = XWColorFromHex(0x999999);
    text.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:text];
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(20));
        make.top.equalTo(dialogBox.mas_bottom).offset(25);
    }];
    
    //按钮菊花
    _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    _activityIndicator.color = [UIColor blackColor];
    _activityIndicator.backgroundColor = [UIColor clearColor];
    _activityIndicator.hidden = YES;
    [dialogBox addSubview:_activityIndicator];
    [_activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(60));
        make.height.equalTo(@(60));
        make.centerX.equalTo(btn.mas_centerX);
        make.centerY.equalTo(btn.mas_centerY);
    }];
    
    
    [self.view layoutIfNeeded];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@" "];
    
    return [string isEqualToString:filtered];
}

-(void)goClick:(UIButton *)btn{
    [self.view endEditing:YES];
    _activityIndicator.hidden = NO;
    [_activityIndicator startAnimating];
    [btn setTitle:@"" forState:UIControlStateNormal];
    WEAKSELF
    NSString *codeinvite = [textField.text uppercaseString];
    [[TiHouse_NetAPIManager sharedManager]request_HousepersonWithPath:@"api/inter/houseperson/add" Params:@{@"codeinvite":codeinvite} Block:^(id data, NSError *error) {
        weakSelf.activityIndicator.hidden = YES;
        [weakSelf.activityIndicator stopAnimating];
        [btn setTitle:@"验证" forState:UIControlStateNormal];
        if (![data isKindOfClass:[NSString class]]) {
            weakSelf.houseperson = data;
            XWAlertView *alert = [[XWAlertView alloc]init];
            alert.image = [UIImage imageNamed:@"alertIcon_Yes"];
            alert.message = [NSString stringWithFormat:@"您已成功关注了房屋“%@”\n现在可以看到房屋的最新变化了！",weakSelf.houseperson.housename];
            alert.BtnClikc = ^{
//                PerfectRelationViewController *PerfectRelationVC = [PerfectRelationViewController new];
//                PerfectRelationVC.houseperson = weakSelf.houseperson;
//                [self.navigationController pushViewController:PerfectRelationVC animated:YES];
                if (self.delegate && [self.delegate respondsToSelector:@selector(invitationCodeViewController:createRelationShipSuccessedWithHouseId:)])
                {
                    [self.delegate invitationCodeViewController:self createRelationShipSuccessedWithHouseId:weakSelf.houseperson.houseid];
                }
                [self.navigationController popViewControllerAnimated:YES];
            };
            [alert show];
        }else{
            XWAlertView *alert = [[XWAlertView alloc]init];
            alert.image = [UIImage imageNamed:@"alertIcon_NO"];
            alert.message = [NSString stringWithFormat:@"%@",data];
            alert.BtnClikc = ^{
                XWLog(@"点击确定");
            };
            [alert show];
        }
    }];
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
