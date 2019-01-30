//
//  EditSoulFolderController.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "EditSoulFolderController.h"
#import "Login.h"
#import "SoulFolder.h"

NSString * const editSoulFolderNameNotification = @"editSoulFolderNameNotification";
NSString * const deleteSoulFolderNotification = @"deleteSoulFolderNotification";
NSString * const editSoulFolderContentNotification = @"editSoulFolderContentNotification";


@interface EditSoulFolderController ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation EditSoulFolderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"编辑灵感册";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    [self textField];
    [self tipLabel];
    [self.textField setText:_soulFolder.soulfoldername];
    [self deleteButton];
}

#pragma mark - getters & setters
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
        _tipLabel.text = @"请填写灵感册名称，10个字以内";
    }
    return _tipLabel;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc] init];
        [self.view addSubview:_deleteButton];
        [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@-50);
            make.centerX.equalTo(self.view);
            make.height.equalTo(@50);
            make.width.equalTo(@300);
        }];
        _deleteButton.layer.cornerRadius = 25;
        _deleteButton.backgroundColor = [UIColor whiteColor];
        [_deleteButton setTitle:@"删除灵感册" forState:UIControlStateNormal];
        _deleteButton.titleLabel.font = ZISIZE(12);
        [_deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _deleteButton.layer.borderWidth = 0.5;
        _deleteButton.layer.borderColor = [UIColor colorWithHexString:@"bfbfbf"].CGColor;
        [_deleteButton addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

#pragma mark - Target Action
- (void)save {
    if (_textField.text.length == 0) {
        [NSObject showHudTipStr:@"灵感册名称不能为空"];
        return;
    }
    
    [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/soulfolder/editSoulfoldername" withParams:@{@"uid": [NSNumber numberWithLong:[[Login curLoginUser] uid]], @"soulfolderid": [NSString stringWithFormat:@"%ld", _soulFolder.soulfolderid], @"soulfoldername": _textField.text} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue]) {
            [NSObject showHudTipStr:data[@"msg"]];
            [self sendEditSoulFolderSuccessNotification];
        } else {
            [NSObject showHudTipStr:data[@"msg"]];
        }
    }];
}

- (void)delete {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您确定要删除该灵感册吗？\n删除后，灵感册内的图片仍将保留在“全部图片”中" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)  ];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"删除" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        [self deleteSoulFolder];
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)deleteSoulFolder {
    [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/soulfolder/remove" withParams:@{@"uid": [NSNumber numberWithLong:[[Login curLoginUser] uid]], @"soulfolderid": @(_soulFolder.soulfolderid)} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue]) {
            [NSObject showHudTipStr:data[@"msg"]];
            [self sendDeleteSoulFolderSuccessNotification];
        } else {
            [NSObject showHudTipStr:data[@"msg"]];
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidChange:(UITextField *)textField {
    
    NSInteger kMaxLength = 10;
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

#pragma mark - NSNotification
- (void)sendEditSoulFolderSuccessNotification {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    _soulFolder.soulfoldername = _textField.text;
    [nc postNotificationName:editSoulFolderNameNotification object:_soulFolder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendDeleteSoulFolderSuccessNotification {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:editSoulFolderNameNotification object:nil];
    [self.navigationController popToViewController:self.navigationController.viewControllers[3] animated:YES];
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
