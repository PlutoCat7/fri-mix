//
//  GBLoginTextField.h
//  GB_Team
//
//  Created by weilai on 16/9/9.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TEXT_TYPE) {
    TEXT_TYPE_LOGIN_ACCOUNT = 1,        //登录账号
    TEXT_TYPE_LOGIN_PASSWORD,           //登录密码
    TEXT_TYPE_REGIST_ACCOUNT,           //注册账号
    TEXT_TYPE_REGIST_PASSWORD,          //注册密码
    TEXT_TYPE_REGIST_REPEATWORD,        //注册再次输入密码
    TEXT_TYPE_REGIST_VERIFYCODE,        //验证码
    TEXT_TYPE_MODIFY_ACC_ACCOUNT,       //账号修改账号
    TEXT_TYPE_MODIFY_ACC_PASSWORD,      //账号修改密码
    TEXT_TYPE_MODIFY_ACC_REPEATWORD,    //账号修改再次输入密码
    TEXT_TYPE_MODIFY_ACC_VERIFYCODE,    //账号修改输入验证码
    TEXT_TYPE_MODIFY_PWD_OLD,           //密码修改旧密码
    TEXT_TYPE_MODIFY_PWD_NEW,           //密码修改新密码
    TEXT_TYPE_MODIFY_PWD_AGAIN,         //密码修改再输入新密码
};

@interface GBLoginTextField : UIView
// 编辑框
@property (weak, nonatomic) IBOutlet UITextField *textField;
// 是否正确
@property (assign, nonatomic) BOOL correct;

@end
