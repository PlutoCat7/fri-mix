//
//  CommentInputView.m
//  GB_Video
//
//  Created by yahua on 2018/1/26.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "CommentInputView.h"
#import "IQKeyboardManager.h"

#define kLimitStringLength  60

@interface CommentInputView () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewBottomLayoutConstraint;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (nonatomic, copy) void(^commentBlock)(NSString *comment);

@end

@implementation CommentInputView

+ (void)showWithCommentBlock:(void(^)(NSString *comment))block {
    
    CommentInputView *view = [[NSBundle mainBundle] loadNibNamed:@"CommentInputView" owner:self options:nil].firstObject;
    view.frame = [UIApplication sharedApplication].keyWindow.bounds;
    view.commentBlock = block;
    [view.textView becomeFirstResponder];
    [view registerAllNotifications];
    
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)dealloc
{
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.textView.layer.cornerRadius = 5.0f;
    self.textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.textView.delegate = self;
    self.textView.yh_placeHolder = @"写个评论和球友们聊聊天呗";
    self.textView.yh_placeHolderColor = [UIColor colorWithHex:0xbfc6cd];
    
    self.limitLabel.text = [NSString stringWithFormat:@"0/%d", kLimitStringLength];
}

#pragma mark - Notification

-(void)registerAllNotifications
{
    //  Registering for keyboard notification.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange:) name:UITextViewTextDidChangeNotification object:nil];
}

-(void)keyboardWillShow:(NSNotification*)aNotification
{

    //  Getting keyboard animation.
    NSInteger curve = [[aNotification userInfo][UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSInteger animationCurve = curve<<16;
    
    //  Getting keyboard animation duration
    CGFloat duration = [[aNotification userInfo][UIKeyboardAnimationDurationUserInfoKey] floatValue];

    //  Getting UIKeyboardSize.
    CGRect kbFrame = [[aNotification userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    
    [UIView animateWithDuration:duration delay:0 options:(animationCurve|UIViewAnimationOptionBeginFromCurrentState) animations:^{
        
        self.inputViewBottomLayoutConstraint.constant = kbFrame.size.height;
        [self layoutIfNeeded];
    } completion:nil];
}

/*  UIKeyboardDidShowNotification. */
- (void)keyboardDidShow:(NSNotification*)aNotification
{
    //  Getting keyboard animation.
    NSInteger curve = [[aNotification userInfo][UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSInteger animationCurve = curve<<16;
    
    //  Getting keyboard animation duration
    CGFloat duration = [[aNotification userInfo][UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //  Getting UIKeyboardSize.
    CGRect kbFrame = [[aNotification userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    
    [UIView animateWithDuration:duration delay:0 options:(animationCurve|UIViewAnimationOptionBeginFromCurrentState) animations:^{
        
        self.inputViewBottomLayoutConstraint.constant = kbFrame.size.height;
        [self layoutIfNeeded];
    } completion:nil];
}

/*  UIKeyboardWillHideNotification. So setting rootViewController to it's default frame. */
- (void)keyboardWillHide:(NSNotification*)aNotification
{
    //  Getting keyboard animation.
    NSInteger curve = [[aNotification userInfo][UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSInteger animationCurve = curve<<16;
    
    //  Getting keyboard animation duration
    CGFloat duration = [[aNotification userInfo][UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration delay:0 options:(animationCurve|UIViewAnimationOptionBeginFromCurrentState) animations:^{
        
        self.inputViewBottomLayoutConstraint.constant = 0;
        [self layoutIfNeeded];
    } completion:nil];
}

/*  UIKeyboardDidHideNotification. So topViewBeginRect can be set to CGRectZero. */
- (void)keyboardDidHide:(NSNotification*)aNotification
{

}

- (void)textViewTextDidChange:(NSNotification *)notification {
    
    UITextView *textField = notification.object;

    self.sendButton.enabled = textField.text.length>0;
    self.limitLabel.text = [NSString stringWithFormat:@"%td/%d", textField.text.length, kLimitStringLength];
}

#pragma mark - Action

- (IBAction)actionClose:(id)sender {
    
    [self removeFromSuperview];
}

- (IBAction)actionSent:(id)sender {
    
    BLOCK_EXEC(self.commentBlock, self.textView.text);
    [self actionClose:nil];
}

#pragma mark - Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@""]) { //删除操作
        return YES;
    }
    if (textView.text.length >= kLimitStringLength) {
        return NO;
    }
    return YES;
}

@end
