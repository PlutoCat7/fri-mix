//
//  GBLoginTextField.h
//  GB_Football
//
//  Created by Leo Lin Software Engineer on 16/7/12.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TEXT_TYPE) {
    TEXT_TYPE_ACCOUNT = 1,        //登录账号
    TEXT_TYPE_PASSWORD,           //登录密码
    TEXT_TYPE_SUREPASS,           //确定密码
    TEXT_TYPE_VERIFYCODE,         //验证码
    TEXT_TYPE_PWD_OLD,            //旧密码
};

@interface GBLoginTextField : UIView
// 编辑框
@property (weak, nonatomic) IBOutlet UITextField *textField;
// 提示文本
@property (strong, nonatomic) NSString *placeholder;
@end
