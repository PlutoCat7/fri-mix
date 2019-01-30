//
//  GBModifyPwdViewController.m
//  GB_Video
//
//  Created by gxd on 2018/2/1.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "GBModifyPwdViewController.h"
#import "GBLoginTextField.h"

#import "UserRequest.h"

@interface GBModifyPwdViewController ()
@property (weak, nonatomic) IBOutlet GBLoginTextField *oldPwdView;
@property (weak, nonatomic) IBOutlet GBLoginTextField *firstPwdView;
@property (weak, nonatomic) IBOutlet GBLoginTextField *againPwdView;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@end

@implementation GBModifyPwdViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLayoutSubviews {
    self.okButton.layer.cornerRadius = self.okButton.height/2;
    
}

#pragma mark - Action

- (IBAction)actionOk:(id)sender {
    NSString *oldpass = [self.oldPwdView.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [self.firstPwdView.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *surepass = [self.againPwdView.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if ([NSString stringIsNullOrEmpty:oldpass] || [NSString stringIsNullOrEmpty:password] || [NSString stringIsNullOrEmpty:surepass]) {
        [self showToastWithText:@"请填写所有项信息"];
        return;
    }
    
    if (![password isEqualToString:surepass]) {
        [self showToastWithText:@"两次输入的密码不一致"];
        return;
    }
    
    [self showLoadingToastWithText:LS(@"login.tip.waiting")];
    @weakify(self)
    [UserRequest modifyUserPassword:oldpass newPassword:password handler:^(id result, NSError *error) {
        
        @strongify(self)
        [self dismissToast];
        if (error != nil) {
            [self showToastWithText:error.domain];
            
        } else {
            //更新密码
            [RawCacheManager sharedRawCacheManager].lastPassword = password;
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
    }];
}

#pragma mark - Private

-(void)setupUI {
    self.title = LS(@"setting.label.passord");
    [self setupBackButtonWithBlock:nil];
}

@end
