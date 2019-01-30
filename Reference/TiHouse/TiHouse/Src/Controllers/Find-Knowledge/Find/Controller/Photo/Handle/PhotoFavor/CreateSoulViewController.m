//
//  CreateSoulViewController.m
//  TiHouse
//
//  Created by weilai on 2018/2/5.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CreateSoulViewController.h"
#import "NotificationConstants.h"

#import "ModelLabelRequest.h"

@interface CreateSoulViewController () <
UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end

@implementation CreateSoulViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [self.nameTextField becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - Notification

- (void)textFieldTextDidChange:(NSNotification *)notification {
}

#pragma mark - Delegate

// 字数限制
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.nameTextField)
    {
        if(strlen([textField.text UTF8String]) >= 10 && range.length != 1)return NO;
    }
    
    return YES;
}

// Done键盘回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - private

- (void)setupUI {
    
    self.title = @"创建灵感册";
    
    [self setupNavigationBarRight];
}

- (void)setupNavigationBarRight {
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setSize:CGSizeMake(48, 24)];
    [saveButton.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    [saveButton setTitle:@"创建" forState:UIControlStateNormal];
    [saveButton setTitle:@"创建" forState:UIControlStateHighlighted];
    [saveButton setTitleColor:[UIColor colorWithRGBHex:0x2D2F35] forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor colorWithRGBHex:0x2D2F35] forState:UIControlStateDisabled];
    saveButton.backgroundColor = [UIColor clearColor];
    [saveButton addTarget:self action:@selector(actionSave) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    [self.navigationItem setRightBarButtonItem:rightButton];
}

-(void)actionSave {
    
    [self.nameTextField resignFirstResponder];
    NSString *newName = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (newName.length == 0) {
        [NSObject showHudTipStr:@"请输入内容"];
        return;
    }
    
    [NSObject showHUDQueryStr:@"正在创建"];
    [ModelLabelRequest addSoulFolderWithName:newName handler:^(id result, NSError *error) {
        [NSObject hideHUDQuery];
        if (!error) {
            [NSObject showHudTipStr:self.view tipStr:@"创建成功"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Create_Soul object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end
