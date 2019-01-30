//
//  GBLoginTextField.m
//  GB_Football
//
//  Created by Leo Lin Software Engineer on 16/7/12.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBLoginTextField.h"
#import "XXNibBridge.h"
#import "UIImage+RTTint.h"
@interface GBLoginTextField ()<XXNibBridge>
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@end

@implementation GBLoginTextField

-(void)awakeFromNib
{
    [super awakeFromNib];
   [self setupUI];
}

-(void)setupUI
{
    UIColor *placeHolderColor = [ColorManager placeholderColor];
    switch (self.tag)
    {
        case TEXT_TYPE_LOGIN_ACCOUNT:
        {
            self.leftImageView.image = [UIImage imageNamed:@"regsiter_i"];
            self.textField.attributedPlaceholder = [[NSAttributedString alloc]
                                                    initWithString:LS(@"login.hint.moblie")
                                                    attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        break;
        case TEXT_TYPE_LOGIN_PASSWORD:
        {
            self.leftImageView.image = [UIImage imageNamed:@"regsiter_s"];
            self.textField.attributedPlaceholder = [[NSAttributedString alloc]
                                                    initWithString:LS(@"login.hint.password")
                                                    attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
            self.textField.returnKeyType = UIReturnKeyDone;
            self.textField.secureTextEntry = YES;
        }
            break;
        case TEXT_TYPE_REGIST_ACCOUNT:
        {
            self.leftImageView.image = [UIImage imageNamed:@"regsiter_i"];
            self.textField.attributedPlaceholder = [[NSAttributedString alloc]
                                                    initWithString:LS(@"signup.hint.moblie")
                                                    attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
        case TEXT_TYPE_REGIST_PASSWORD:
        {
            self.leftImageView.image = [UIImage imageNamed:@"regsiter_s"];
            self.textField.attributedPlaceholder = [[NSAttributedString alloc]
                                                    initWithString:LS(@"signup.hint.password")
                                                    attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
            self.textField.returnKeyType = UIReturnKeyDone;
            self.textField.secureTextEntry = YES;
        }
            break;
        case TEXT_TYPE_REGIST_REPEATWORD:
        {
            self.leftImageView.image = [UIImage imageNamed:@"regsiter_s"];
            self.textField.attributedPlaceholder = [[NSAttributedString alloc]
                                                    initWithString:LS(@"signup.hint.again")
                                                    attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
            self.textField.returnKeyType = UIReturnKeyDone;
            self.textField.secureTextEntry = YES;
        }
            break;
        case TEXT_TYPE_REGIST_VERIFYCODE:
        {
            self.leftImageView.image = [UIImage imageNamed:@"regsiter_y"];
            self.textField.attributedPlaceholder = [[NSAttributedString alloc]
                                                    initWithString:LS(@"signup.hint.vercode")
                                                    attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
        case TEXT_TYPE_SERIALNUMBER:
        {
            self.leftImageView.image = [UIImage imageNamed:@"lock"];
            self.textField.attributedPlaceholder = [[NSAttributedString alloc]
                                                    initWithString:LS(@"scan.label.serial")
                                                    attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
        case TEXT_TYPE_MODIFY_ACC_ACCOUNT:
        {
            self.leftImageView.image = [UIImage imageNamed:@"regsiter_i"];
            self.textField.attributedPlaceholder = [[NSAttributedString alloc]
                                                    initWithString:LS(@"modify.hint.new.mobile")
                                                    attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
        case TEXT_TYPE_MODIFY_ACC_PASSWORD:
        {
            self.leftImageView.image = [UIImage imageNamed:@"regsiter_s"];
            self.textField.attributedPlaceholder = [[NSAttributedString alloc]
                                                    initWithString:LS(@"modify.hint.old.password")
                                                    attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
            self.textField.secureTextEntry = YES;
        }
            break;
        case TEXT_TYPE_MODIFY_ACC_VERIFYCODE:
        {
            self.leftImageView.image = [UIImage imageNamed:@"regsiter_y"];
            self.textField.attributedPlaceholder = [[NSAttributedString alloc]
                                                    initWithString:LS(@"modify.hint.vercode")
                                                    attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
        case TEXT_TYPE_MODIFY_PWD_OLD:
        {
            self.leftImageView.image = [UIImage imageNamed:@"regsiter_s"];
            self.textField.attributedPlaceholder = [[NSAttributedString alloc]
                                                    initWithString:LS(@"modify.hint.old.password")
                                                    attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
            self.textField.secureTextEntry = YES;
        }
            break;
        case TEXT_TYPE_MODIFY_PWD_NEW:
        {
            self.leftImageView.image = [UIImage imageNamed:@"regsiter_s"];
            self.textField.attributedPlaceholder = [[NSAttributedString alloc]
                                                    initWithString:LS(@"modify.hint.new")
                                                    attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
            self.textField.secureTextEntry = YES;
        }
            break;
        case TEXT_TYPE_MODIFY_PWD_AGAIN:
        {
            self.leftImageView.image = [UIImage imageNamed:@"regsiter_s"];
            self.textField.attributedPlaceholder = [[NSAttributedString alloc]
                                                    initWithString:LS(@"modify.hint.again.password")
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
    
    self.rightImageView.image  = [UIImage imageNamed:correct?@"regsiter_yes":@"regsiter_yesx"];
    _correct = correct;
}


@end
