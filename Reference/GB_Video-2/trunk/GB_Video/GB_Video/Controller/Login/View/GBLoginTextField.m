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
    switch (self.tag) {
        case TEXT_TYPE_ACCOUNT:
        {
            self.textField.attributedPlaceholder = [[NSAttributedString alloc]
                                                    initWithString:LS(@"login.label.phone")
                                                    attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        break;
        case TEXT_TYPE_PASSWORD:
        {
            self.textField.attributedPlaceholder = [[NSAttributedString alloc]
                                                    initWithString:LS(@"login.label.password")
                                                    attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
            self.textField.returnKeyType = UIReturnKeyDone;
            self.textField.secureTextEntry = YES;
        }
            break;
        case TEXT_TYPE_SUREPASS:
        {
            self.textField.attributedPlaceholder = [[NSAttributedString alloc]
                                                    initWithString:LS(@"login.label.surepass")
                                                    attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
            self.textField.returnKeyType = UIReturnKeyDone;
            self.textField.secureTextEntry = YES;
        }
            break;
        case TEXT_TYPE_PWD_OLD:
        {
            self.textField.attributedPlaceholder = [[NSAttributedString alloc]
                                                    initWithString:LS(@"login.label.oldpass")
                                                    attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
            self.textField.returnKeyType = UIReturnKeyDone;
            self.textField.secureTextEntry = YES;
        }
            break;
        case TEXT_TYPE_VERIFYCODE:
        {
            self.textField.attributedPlaceholder = [[NSAttributedString alloc]
                                                    initWithString:LS(@"login.label.verify")
                                                    attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
            
        default:
            break;
    }
}


@end
