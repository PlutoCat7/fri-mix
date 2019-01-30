//
//  RelativeFriViewController.m
//  TiHouse
//
//  Created by guansong on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "RelativeFriViewController.h"
#import "Login.h"

@interface RelativeFriViewController ()///<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtName;

@end

@implementation RelativeFriViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"修改昵称";
    
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(btn_yaoqingAction:)];
    
     self.navigationItem.rightBarButtonItem = rightButton;
//    self.txtName.delegate = self;
    
    self.txtName.text = IF_NULL_TO_STRINGSTR(self.person.nickname, @"-");
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isExtendLayout = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isExtendLayout = NO;
}


-(void) btn_yaoqingAction:(id) sender{
    
    [self.txtName resignFirstResponder];
    
    if ([self.txtName.text isEqualToString:self.person.nickname]) {
        [NSObject showHudTipStr:@"您没有修改内容"];
        return;
    }
    if (self.txtName.text.length < 1 || self.txtName.text.length > 10 ) {
        [NSObject showHudTipStr:@"字符长度为0~10"];
        return;
    }
    
    //修改昵称
    [self requestData];
    

}

- (void)requestData{
    User *user = [Login curLoginUser];

    [self.view beginLoading];
    
    WS(weakSelf);
    
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:URL_Edit_RelFri_NickName withParams:@{@"uid":@(user.uid),@"housepersonid":@(self.person.housepersonid),@"nickname":self.txtName.text} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        
        [weakSelf.view endLoading];
        if ([data[@"is"] intValue]) {
            
            [NSObject showStatusBarSuccessStr:@"修改成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (weakSelf.block) {
                    weakSelf.block(weakSelf.txtName.text);
                }
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            [NSObject showStatusBarErrorStr:data[@"msg"]];
        }
       
    }];
}


//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//
//    if (textField.text.length>20) {
//        textField.text = textField.text;
//    }
//
//    return YES;
//
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
