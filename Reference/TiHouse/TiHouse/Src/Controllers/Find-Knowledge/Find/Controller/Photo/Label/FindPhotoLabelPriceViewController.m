//
//  FindPhotoLabelPriceViewController.m
//  TiHouse
//
//  Created by yahua on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindPhotoLabelPriceViewController.h"

@interface FindPhotoLabelPriceViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSString *oldText;
@property (nonatomic, copy) void(^doneBlock)(NSString *inputName);

@end

@implementation FindPhotoLabelPriceViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithPlaceholder:(NSString *)placeholder text:(NSString *)text doneBlock:(void(^)(NSString *inputName))doneBlock {
    
    self = [super init];
    if (self) {
        _oldText = text;
        _placeholder = placeholder;
        _doneBlock = doneBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - Notification

- (void)textFieldTextDidChange:(NSNotification *)notification {
    
    UITextField *textField = notification.object;
    if (textField == self.textField) {
        static NSInteger const maxIntegerLength=8;//最大整数位
        static NSInteger const maxFloatLength=2;//最大精确到小数位
        NSString *x = textField.text;
        if (x.length) {
            //第一个字符处理
            //第一个字符为0,且长度>1时
            if ([[x substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"]) {
                if (x.length>1) {
                    if ([[x substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"0"]) {
                        //如果第二个字符还是0,即"00",则无效,改为"0"
                        textField.text=@"0";
                    }else if (![[x substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"."]){
                        //如果第二个字符不是".",比如"03",清除首位的"0"
                        textField.text=[x substringFromIndex:1];
                    }
                }
            }
            //第一个字符为"."时,改为"0."
            else if ([[x substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"."]){
                textField.text=@"0.";
            }
            
            //2个以上字符的处理
            NSRange pointRange = [x rangeOfString:@"."];
            NSRange pointsRange = [x rangeOfString:@".."];
            if (pointsRange.length>0) {
                //含有2个小数点
                textField.text=[x substringToIndex:x.length-1];
            }
            else if (pointRange.length>0){
                //含有1个小数点时,并且已经输入了数字,则不能再次输入小数点
                if ((pointRange.location!=x.length-1) && ([[x substringFromIndex:x.length-1]isEqualToString:@"."])) {
                    textField.text=[x substringToIndex:x.length-1];
                }
                if (pointRange.location+maxFloatLength<x.length) {
                    //输入位数超出精确度限制,进行截取
                    textField.text=[x substringToIndex:pointRange.location+maxFloatLength+1];
                }
            }
            else{
                if (x.length>maxIntegerLength) {
                    textField.text=[x substringToIndex:maxIntegerLength];
                }
            }
        }
    }
}

#pragma mark - Action

- (void)doneAction {
    
    if (_doneBlock) {
        _doneBlock(self.textField.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionClose:(id)sender {
    
    self.textField.text = @"";
}

#pragma mark - Private

- (void)setupUI {
    
    [self wr_setNavBarBarTintColor:XWColorFromHex(0xfcfcfc)];
    self.title = @"添加物品";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
    self.textField.placeholder = _placeholder;
    self.textField.text = _oldText;
    [self.textField becomeFirstResponder];
}

@end
