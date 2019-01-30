//
//  TacticsNameView.m
//  GB_Football
//
//  Created by yahua on 2018/1/17.
//  Copyright © 2018年 Go Brother. All rights reserved.
//

#import "TacticsNameView.h"

@interface TacticsNameView () <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (nonatomic, copy) void(^nameBlock)(NSString *name);

@end

@implementation TacticsNameView

+ (void)showWithName:(NSString *)name block:(void(^)(NSString *name))block {
    
    TacticsNameView *view = [[NSBundle mainBundle] loadNibNamed:@"TacticsNameView" owner:self options:nil].firstObject;
    view.frame = [UIApplication sharedApplication].keyWindow.bounds;
    view.nameBlock = block;
    if (![NSString stringIsNullOrEmpty:name]) {
        view.nameTextField.text = name;
    }
    [view.nameTextField becomeFirstResponder];
    
    [[UIApplication sharedApplication].keyWindow addSubview:view];
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.nameTextField.delegate = self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"]) {
        //收起键盘
        [textField resignFirstResponder];
        [self removeFromSuperview];
        BLOCK_EXEC(self.nameBlock, textField.text);
        return NO;
    }else if (textField.text.length>20) {
        return NO;
    }
    return YES;
}

@end
