//
//  EditNicknameController.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "EditNicknameController.h"
#import "Login.h"

@interface EditNicknameController ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation EditNicknameController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改昵称";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    [self.textField setText:[[Login curLoginUser] username]];
    [self tipLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 0)];
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        [self.view addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(@(kNavigationBarHeight));
            make.height.equalTo(@(54));
        }];
        _textField.font = ZISIZE(13);
    }
    return _textField;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        [self.view addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_textField.mas_bottom).offset(10);
            make.left.equalTo(@10);
        }];
        _tipLabel.textColor = [UIColor colorWithHexString:@"bfbfbf"];
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.text = @"请不要超过20个字符，支持中英文、数字的组合";
    }
    return _tipLabel;
}



- (void)save {
    [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/user/editUsername" withParams:@{@"uid": [NSNumber numberWithLong:[[Login curLoginUser] uid]], @"username": _textField.text} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue]) {
            [NSObject showHudTipStr:data[@"msg"]];
            [[Login curLoginUser] setUsername:data[@"data"][@"username"]];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [NSObject showHudTipStr:data[@"msg"]];
        }
    }];
}

- (void)textFieldDidChange:(UITextField *)textField {
    
    NSInteger kMaxLength = 20;
//    NSInteger kMaxLength = 10;
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];
        // 获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange offset:0];
        if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        }
        else{//有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    } else {
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
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
