//
//  AccountBooksEditViewController.m
//  TiHouse
//
//  Created by gaodong on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AccountBooksEditViewController.h"
#import "AccountBooksViewController.h"
#import "Tally_NetAPIManager.h"
#import <IQKeyboardManager.h>

@interface AccountBooksEditViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (weak, nonatomic) IBOutlet UITextField *tallyTextField;

@end

@implementation AccountBooksEditViewController

#pragma mark - init
+ (instancetype)initWithStoryboard {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AccountBooks" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"AccountBooksEditViewController"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"账本设置";
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    self.delBtn.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.delBtn.layer.shadowOffset = CGSizeMake(0,-1.5);
    self.delBtn.layer.shadowOpacity = 0.3;
    
    UIBarButtonItem *btnDelfunc = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(clickSaveAction:)];
    self.navigationItem.rightBarButtonItem = btnDelfunc;
    
    
    if (self.tDetail) {
        self.tallyTextField.text = self.tDetail.tallyname;
    }
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [_tallyTextField becomeFirstResponder];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - textfeild delegate
//完成
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - action
//删除
- (IBAction)clickDelAction:(UIButton *)sender {
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"确定删除此账本吗？" message:nil preferredStyle:
                                  UIAlertControllerStyleAlert];
    WEAKSELF
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf deleteTally];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVc addAction:action2];
    [alertVc addAction:action1];
    [action1 setValue:XWColorFromHex(0x5186aa) forKey:@"_titleTextColor"];
    [action2 setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
    [self presentViewController:alertVc animated:YES completion:nil];
}

//保存
- (IBAction)clickSaveAction:(UIButton *)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *tallyName = [self.tallyTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([tallyName length] == 0 || [tallyName length] > 6) {
        hud.mode = MBProgressHUDModeText;
        hud.label.text = [NSString stringWithFormat:@"账本名称不得超过6个字"];
        [hud hideAnimated:YES afterDelay:2];
        return;
    }
    
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"保存数据...";
    [[Tally_NetAPIManager sharedManager] request_TallyEditWithTallyID:self.tDetail.tallyid TallyName:tallyName Block:^(id data, NSError *error) {
        if (data) {
            hud.mode = MBProgressHUDModeText;
            hud.label.text = [NSString stringWithFormat:@"保存成功"];
            [hud hideAnimated:YES afterDelay:1];
            [hud setCompletionBlock:^{
                self.completionBlock(data);
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            
            [hud hideAnimated:YES];
        }
    }];
    
}

#pragma mark - data
//删除
- (void)deleteTally{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"正在删除";
    WEAKSELF
    [[Tally_NetAPIManager sharedManager] request_TallyDeleteWithTallyID:self.tDetail.tallyid Block:^(id data, NSError *error) {
        if (data) {
            hud.mode = MBProgressHUDModeText;
            hud.label.text = [NSString stringWithFormat:@"删除成功。"];
            [hud hideAnimated:YES afterDelay:1];
            [hud setCompletionBlock:^{
                
//                [weakSelf.navigationController popViewControllerAnimated:YES];
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[AccountBooksViewController class]]) {
                        AccountBooksViewController *vc =(AccountBooksViewController *)controller;
                        [weakSelf.navigationController popToViewController:vc animated:YES];
                    }
                }
                
            }];
        }else{
            
            [hud hideAnimated:YES];
        }
    }];
    
}



@end
