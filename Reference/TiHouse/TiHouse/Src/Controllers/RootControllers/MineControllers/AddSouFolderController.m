//
//  AddSouFolderController.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/2/11.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AddSouFolderController.h"
#import "UIView+Common.h"
#import "Login.h"

@interface AddSouFolderController ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation AddSouFolderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"创建灵感册";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStylePlain target:self action:@selector(create)];
    [self textField];
    [self tipLabel];
}

#pragma mark - Target Action
- (void)create {
    
    if (_textField.text.length == 0) {
        [NSObject showHudTipStr:@"灵感册名称不能为空"];
        return;
    }
    
    User *user = [Login curLoginUser];
    WEAKSELF
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/soulfolder/add" withParams:@{@"uid":@(user.uid), @"soulfoldername":_textField.text} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue]) {
            [NSObject showHudTipStr:data[@"msg"]];
            weakSelf.callback();
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [NSObject showHudTipStr:data[@"msg"]];
        }
    }];
}

#pragma mark - getters & setters

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        [self.view addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(@(kNavigationBarHeight));
            make.height.equalTo(@(54));
        }];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 0)];
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.view layoutIfNeeded];
        [_textField addLineUp:NO andDown:YES];
        _textField.font = ZISIZE(13);
        _textField.placeholder = @"请输入灵感册名称";
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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
        _tipLabel.text = @"请填写灵感册名称，10个字以内";
    }
    return _tipLabel;
}

#pragma mark - private method

- (void)textFieldDidChange:(UITextField *)textField {
    
    NSInteger kMaxLength = 10;
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];
        // 获取高亮部分
        UITextPosition *position = [textField positionFromPosition:(UITextPosition *)selectedRange offset:0];
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

@end
