//
//  NickViewController.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/29.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "NickViewController.h"

#import "UserRequest.h"

@interface NickViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nickTextField;
@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic,copy) NSString* defaltName;

@end

@implementation NickViewController

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - Notification

- (void)textFieldTextDidChange:(NSNotification *)notification {
    
    NSString *newName = [self.nickTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.saveButton.enabled = !([NSString stringIsNullOrEmpty:newName] || [newName isEqualToString:self.defaltName]);
}

#pragma mark - Action

- (IBAction)actionDelete:(id)sender {
    
    self.nickTextField.text = @"";
}

// 保存
-(void)actionSave {
    
    [self.nickTextField resignFirstResponder];
    NSString *newName = [self.nickTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    [UserRequest saveUserNick:newName handler:^(id result, NSError *error) {
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            [RawCacheManager sharedRawCacheManager].userInfo.nick = newName;
            [[RawCacheManager sharedRawCacheManager].userInfo saveCache];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Nick_Change_Success object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

#pragma mark - Private

- (void)loadData {
    
    self.defaltName = [RawCacheManager sharedRawCacheManager].userInfo.nick;
    self.nickTextField.text = self.defaltName;
}

- (void)setupUI {
    
    self.title = @"昵称";
    [self setupBackButtonWithBlock:nil];
    [self setupNavigationBarRight];
}

- (void)setupNavigationBarRight {
    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveButton setSize:CGSizeMake(48, 24)];
    [self.saveButton.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.saveButton setTitle:@"保存" forState:UIControlStateHighlighted];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateDisabled];
    self.saveButton.backgroundColor = [UIColor clearColor];
    self.saveButton.enabled = NO;
    [self.saveButton addTarget:self action:@selector(actionSave) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:self.saveButton];
    rightButton.enabled = NO;
    [self.navigationItem setRightBarButtonItem:rightButton];
}

@end
