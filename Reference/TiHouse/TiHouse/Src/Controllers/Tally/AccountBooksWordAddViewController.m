//
//  AccountBooksWordAddViewController.m
//  TiHouse
//
//  Created by gaodong on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AccountBooksWordAddViewController.h"
#import <IQKeyboardManager.h>
#import "Tally_NetAPIManager.h"

@interface AccountBooksWordAddViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblMsg;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UITextField *textKeyword;

@property (weak, nonatomic) IBOutlet UIView *msgNormal;
@property (weak, nonatomic) IBOutlet UIView *msgError;


@end

@implementation AccountBooksWordAddViewController

#pragma mark - init
+ (instancetype)initWithStoryboard {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AccountBooks" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"AccountBooksWordAddViewController"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    self.inputView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.inputView.layer.shadowOffset = CGSizeMake(0,-1.5);
    self.inputView.layer.shadowOpacity = 0.3;
    
    self.textKeyword.layer.cornerRadius = 3;
    self.textKeyword.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
    self.textKeyword.leftViewMode = UITextFieldViewModeAlways;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //键盘出现
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //键盘退出
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification
                                               object:nil];
    [self.textKeyword becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - textfeild notification
//键盘出现
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-height);
    }];
}

//键盘退出
- (void)keyboardWillHide:(NSNotification *)aNotification{

    [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
    }];
}

#pragma mark - textfeild delegate
//完成，提交识别
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self intelWord:textField.text];
    return YES;
}

- (BOOL)textChange:(NSNotification *)aNotification{
    
    if ([_textKeyword.text length] == 0) {
        self.lblMsg.text = @"发送文字 智能入账";
        [self.msgNormal setHidden:NO];
        [self.msgError setHidden:YES];
    }
    
    return YES;
}


#pragma mark - action
- (IBAction)clickClose:(UIButton *)sender {
    [_textKeyword resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)intelWord:(NSString *)word{
    
    self.lblMsg.text = [NSString stringWithFormat:@"“%@”",word];
    
    [[Tally_NetAPIManager sharedManager] request_TallyTransWithWord:word Block:^(id data, NSError *error) {
        
        if (data) {
            [self dismissViewControllerAnimated:YES completion:^{
                self.completionBlock(data);
            }];
        }else{
            [self.msgNormal setHidden:YES];
            [self.msgError setHidden:NO];
        }
        
    }];
}



@end
