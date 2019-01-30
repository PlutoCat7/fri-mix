//
//  GBLoginTextField.m
//  GB_Team
//
//  Created by weilai on 16/9/9.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBLoginTextField.h"

@interface GBLoginTextField() <XXNibBridge>
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@end

@implementation GBLoginTextField

-(void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

-(void)setupUI {
    UIColor *placeHolderColor = [ColorManager placeholderColor];
    switch (self.tag)
    {
        case TEXT_TYPE_LOGIN_ACCOUNT:
        {
            self.leftImageView.image = [UIImage imageNamed:@"regsiter_i"];
            self.textField.attributedPlaceholder = [[NSAttributedString alloc]
                                                    initWithString:LS(@"输入手机号码")
                                                    attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
        case TEXT_TYPE_LOGIN_PASSWORD:
        {
            self.leftImageView.image = [UIImage imageNamed:@"regsiter_s"];
            self.textField.attributedPlaceholder = [[NSAttributedString alloc]
                                                    initWithString:LS(@"请输入6-17位密码")
                                                    attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
            self.textField.returnKeyType = UIReturnKeyDone;
            self.textField.secureTextEntry = YES;
        }
            break;
        case TEXT_TYPE_REGIST_ACCOUNT:
        {
            self.leftImageView.image = [UIImage imageNamed:@"regsiter_i"];
            self.textField.attributedPlaceholder = [[NSAttributedString alloc]
                                                    initWithString:LS(@"请输入手机号码")
                                                    attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
        case TEXT_TYPE_REGIST_PASSWORD:
        {
            self.leftImageView.image = [UIImage imageNamed:@"regsiter_s"];
            self.textField.attributedPlaceholder = [[NSAttributedString alloc]
                                                    initWithString:LS(@"请输入6-17位密码")
                                                    attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
            self.textField.returnKeyType = UIReturnKeyDone;
            self.textField.secureTextEntry = YES;
        }
            break;
        case TEXT_TYPE_REGIST_REPEATWORD:
        {
            self.leftImageView.image = [UIImage imageNamed:@"regsiter_s"];
            self.textField.attributedPlaceholder = [[NSAttributedString alloc]
                                                    initWithString:LS(@"请再次输入密码")
                                                    attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
            self.textField.returnKeyType = UIReturnKeyDone;
            self.textField.secureTextEntry = YES;
        }
            break;
        case TEXT_TYPE_REGIST_VERIFYCODE:
        {
            self.leftImageView.image = [UIImage imageNamed:@"regsiter_y"];
            self.textField.attributedPlaceholder = [[NSAttributedString alloc]
                                                    initWithString:LS(@"输入验证码")
                                                    attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
        case TEXT_TYPE_MODIFY_ACC_ACCOUNT:
        {
            self.leftImageView.image = [UIImage imageNamed:@"regsiter_i"];
            self.textField.attributedPlaceholder = [[NSAttributedString alloc]
                                                    initWithString:LS(@"请输入新的手机号码")
                                                    attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
        case TEXT_TYPE_MODIFY_ACC_PASSWORD:
        {
            self.leftImageView.image = [UIImage imageNamed:@"regsiter_s"];
            self.textField.attributedPlaceholder = [[NSAttributedString alloc]
                                                    initWithString:LS(@"输入旧的账号密码")
                                                    attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
            self.textField.secureTextEntry = YES;
        }
            break;
        case TEXT_TYPE_MODIFY_ACC_REPEATWORD:
        {
            self.leftImageView.image = [UIImage imageNamed:@"regsiter_s"];
            self.textField.attributedPlaceholder = [[NSAttributedString alloc]
                                                    initWithString:LS(@"请再次输入密码")
                                                    attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
            self.textField.secureTextEntry = YES;
        }
            break;
        case TEXT_TYPE_MODIFY_ACC_VERIFYCODE:
        {
            self.leftImageView.image = [UIImage imageNamed:@"regsiter_y"];
            self.textField.attributedPlaceholder = [[NSAttributedString alloc]
                                                    initWithString:LS(@"输入验证码")
                                                    attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
        case TEXT_TYPE_MODIFY_PWD_OLD:
        {
            self.leftImageView.image = [UIImage imageNamed:@"regsiter_s"];
            self.textField.attributedPlaceholder = [[NSAttributedString alloc]
                                                    initWithString:LS(@"请输入旧的账号密码")
                                                    attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
            self.textField.secureTextEntry = YES;
        }
            break;
        case TEXT_TYPE_MODIFY_PWD_NEW:
        {
            self.leftImageView.image = [UIImage imageNamed:@"regsiter_s"];
            self.textField.attributedPlaceholder = [[NSAttributedString alloc]
                                                    initWithString:LS(@"请输入6-17位新密码")
                                                    attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
            self.textField.secureTextEntry = YES;
        }
            break;
        case TEXT_TYPE_MODIFY_PWD_AGAIN:
        {
            self.leftImageView.image = [UIImage imageNamed:@"regsiter_s"];
            self.textField.attributedPlaceholder = [[NSAttributedString alloc]
                                                    initWithString:LS(@"请再次输入新密码")
                                                    attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
            
            self.textField.secureTextEntry = YES;
        }
            break;
            
        default:
            break;
    }
}

-(void)setCorrect:(BOOL)correct
{
    if (_correct == correct) {
        return;
    }
    
    self.rightImageView.image  = [UIImage imageNamed:correct?@"regsiter_yes":@"regsiter_x"];
    _correct = correct;
}

@end
