//
//  UIMessageInputView.m
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/21.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#define kKeyboardView_Height 216.0
#define kMessageInputView_Height 55.0
#define kMessageInputView_HeightMax 120.0
#define kMessageInputView_PadingHeight 11.0
#define kMessageInputView_Width_Tool 25.0
#define kMessageInputView_Left 12.0
#define kMessageInputView_MediaPadding 1.0

#import "UIMessageInputView.h"
#import "UIPlaceHolderTextView.h"
#import "AGEmojiKeyBoardView.h"

static NSMutableDictionary *_inputStrDict;

@interface UIMessageInputView()<AGEmojiKeyboardViewDelegate, AGEmojiKeyboardViewDataSource>

@property (strong, nonatomic) UIScrollView *contentView;
@property (strong, nonatomic) UIButton *emotionButton;
@property (strong, nonatomic) AGEmojiKeyboardView *emojiKeyboardView;
@property (strong, nonatomic) UIPlaceHolderTextView *inputTextView;

@property (assign, nonatomic) CGFloat viewHeightOld;

@property (assign, nonatomic) UIMessageInputViewState inputState;

@end

@implementation UIMessageInputView


- (void)setFrame:(CGRect)frame{
    CGFloat oldheightToBottom = kScreen_Height - CGRectGetMinY(self.frame);
    CGFloat newheightToBottom = kScreen_Height - CGRectGetMinY(frame);
    [super setFrame:frame];
    if (fabs(oldheightToBottom - newheightToBottom) > 0.1) {
        if (oldheightToBottom > newheightToBottom) {//降下去的时候保存
            [self saveInputStr];
        }
        if (_delegate && [_delegate respondsToSelector:@selector(messageInputView:heightToBottomChenged:)]) {
            [self.delegate messageInputView:self heightToBottomChenged:newheightToBottom];
        }
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = kColorNavBG;
        [self addLineUp:YES andDown:NO andColor:kColorCCC];
        _viewHeightOld = CGRectGetHeight(frame);
        _inputState = UIMessageInputViewStateSystem;
        _isAlwaysShow = NO;
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
        [self addGestureRecognizer:panGesture];
    }
    return self;
}

- (void)didPan:(UIPanGestureRecognizer *)panGesture
{
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        CGFloat verticalDiff = [panGesture translationInView:self].y;
        if (verticalDiff > 60) {
            [self isAndResignFirstResponder];
        }
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setInputState:(UIMessageInputViewState)inputState{
    if (_inputState != inputState) {
        _inputState = inputState;
        switch (_inputState) {
            case UIMessageInputViewStateSystem:
            {
                [self.emotionButton setImage:[UIImage imageNamed:@"keyboard_emotion"] forState:UIControlStateNormal];
            }
                break;
            case UIMessageInputViewStateEmotion:
            {
                [self.emotionButton setImage:[UIImage imageNamed:@"keyboard_keyboard"] forState:UIControlStateNormal];
            }
                break;
            default:
                break;
        }
//        [self updateContentViewBecauseOfMedia:NO];
    }
}


+ (instancetype)messageInputView{
    return [self messageInputViewWithPlaceHolder:nil];
}
+ (instancetype)messageInputViewWithPlaceHolder:(NSString *)placeHolder{
    UIMessageInputView *messageInputView = [[UIMessageInputView alloc] initWithFrame:CGRectMake(0, kScreen_Height, kScreen_Width, kMessageInputView_Height)];
    messageInputView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
    messageInputView.layer.shadowRadius = 3.0;
    messageInputView.layer.shadowOffset = CGSizeMake(0, -3);
    [messageInputView addSubviews];
    if (placeHolder) {
        messageInputView.placeHolder = placeHolder;
    }else{
        messageInputView.placeHolder = @"说点什么......点评一下";
    }
    return messageInputView;
}


-(void)addSubviews{
    
    CGFloat contentViewHeight = kMessageInputView_Height -2*kMessageInputView_PadingHeight;
    if (!_contentView) {
        _contentView = [[UIScrollView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
//        _contentView.layer.borderWidth = 0.5;
//        _contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        _contentView.layer.cornerRadius = contentViewHeight/2;
//        _contentView.layer.masksToBounds = YES;
        _contentView.alwaysBounceVertical = YES;
        [self addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//            CGFloat left = hasVoiceBtn ? (7+kMessageInputView_Width_Tool+7) : kPaddingLeftWidth;
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(kMessageInputView_PadingHeight,  kMessageInputView_PadingHeight + kMessageInputView_Left + kMessageInputView_Width_Tool, kMessageInputView_PadingHeight, kMessageInputView_Left));
        }];
    }
    
    if (!_inputTextView) {
        _inputTextView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width - kPaddingLeftWidth*2 - kMessageInputView_Width_Tool - kMessageInputView_PadingHeight, contentViewHeight)];
        _inputTextView.font = [UIFont systemFontOfSize:14];
        _inputTextView.returnKeyType = UIReturnKeySend;
        _inputTextView.layer.cornerRadius = 4.0;
        _inputTextView.layer.masksToBounds = YES;
        _inputTextView.backgroundColor = XWColorFromHex(0xebebeb);
        _inputTextView.scrollsToTop = NO;
        _inputTextView.delegate = self;
        
        //输入框缩进
        UIEdgeInsets insets = _inputTextView.textContainerInset;
        insets.left += 8.0;
        insets.right += 8.0;
        _inputTextView.textContainerInset = insets;
        _inputTextView.delegate = self;
        [self.contentView addSubview:_inputTextView];
    }
    
    __weak typeof(self) weakSelf = self;
    //监听self.inputTextView高度
    if (_inputTextView) {
        [[RACObserve(self.inputTextView, contentSize) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSValue *contentSize) {
            [weakSelf updateContentViewBecauseOfMedia:NO];
        }];
    }

    
    if (!_emotionButton) {
        _emotionButton = [[UIButton alloc] init];
        [_emotionButton setImage:[UIImage imageNamed:@"keyboard_emotion"] forState:UIControlStateNormal];
        [_emotionButton addTarget:self action:@selector(emotionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_emotionButton];
        [_emotionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kMessageInputView_Width_Tool, kMessageInputView_Width_Tool));
            make.left.equalTo(self).offset(kMessageInputView_Left);
            make.centerY.equalTo(self);
        }];
    }
    
    if (!_emojiKeyboardView) {
        _emojiKeyboardView = [[AGEmojiKeyboardView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kKeyboardView_Height) dataSource:self showBigEmotion:NO];
        _emojiKeyboardView.delegate = self;
        [_emojiKeyboardView setY:kScreen_Height];
    }

}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 100) {
        textView.text = [textView.text substringToIndex:100];
    }
}

- (void)setPlaceHolder:(NSString *)placeHolder{
    _placeHolder = placeHolder;
    if (_inputTextView && ![_inputTextView.placeholder isEqualToString:placeHolder]) {
        _inputTextView.placeholder = placeHolder;
    }
}

- (void)emotionButtonClicked:(id)sender{
    CGFloat endY = kScreen_Height;
    if (self.inputState == UIMessageInputViewStateEmotion) {
        self.inputState = UIMessageInputViewStateSystem;
        [_inputTextView becomeFirstResponder];
    }else{
        self.inputState = UIMessageInputViewStateEmotion;
        [_inputTextView resignFirstResponder];
        endY = kScreen_Height - kKeyboardView_Height;
    }
    [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        [_emojiKeyboardView setY:endY];
        if (ABS(kScreen_Height - endY) > 0.1) {
            [self setY:endY- CGRectGetHeight(self.frame)];
        }
    } completion:^(BOOL finished) {
    }];
}

#pragma mark Public M
- (void)prepareToShow{
    if ([self superview] == kKeyWindow) {
        return;
    }
    [self setY:kScreen_Height];
    [kKeyWindow addSubview:self];
    [kKeyWindow addSubview:_emojiKeyboardView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    if (_isAlwaysShow && ![self isCustomFirstResponder]) {
        [UIView animateWithDuration:0.25 animations:^{
            [self setY:kScreen_Height - CGRectGetHeight(self.frame)];
        }];
    }
}

- (void)prepareToDismiss{
    if ([self superview] == nil) {
        return;
    }
    [self isAndResignFirstResponder];
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        [self setY:kScreen_Height];
    } completion:^(BOOL finished) {
        [_emojiKeyboardView removeFromSuperview];
        [self removeFromSuperview];
    }];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)notAndBecomeFirstResponder{
    self.inputState = UIMessageInputViewStateSystem;
    if ([_inputTextView isFirstResponder]) {
        return NO;
    }else{
        [_inputTextView becomeFirstResponder];
        return YES;
    }
}
- (BOOL)isAndResignFirstResponder{
    if (self.inputState == UIMessageInputViewStateEmotion) {
        [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            [_emojiKeyboardView setY:kScreen_Height];
            if (self.isAlwaysShow) {
                [self setY:kScreen_Height- CGRectGetHeight(self.frame)];
            }else{
                [self setY:kScreen_Height];
            }
        } completion:^(BOOL finished) {
            self.inputState = UIMessageInputViewStateSystem;
        }];
        return YES;
    }else{
        if ([_inputTextView isFirstResponder]) {
            [_inputTextView resignFirstResponder];
            return YES;
        }else{
            return NO;
        }
    }
}

- (BOOL)isCustomFirstResponder{
    return ([_inputTextView isFirstResponder] || self.inputState == UIMessageInputViewStateEmotion );
}

#pragma mark - KeyBoard Notification Handlers
- (void)keyboardChange:(NSNotification*)aNotification{
    if ([aNotification name] == UIKeyboardDidChangeFrameNotification) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
    }
    if (self.inputState == UIMessageInputViewStateSystem && [self.inputTextView isFirstResponder]) {
        NSDictionary* userInfo = [aNotification userInfo];
        CGRect keyboardEndFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyboardY =  keyboardEndFrame.origin.y;
        
        CGFloat selfOriginY = keyboardY == kScreen_Height? self.isAlwaysShow? kScreen_Height - CGRectGetHeight(self.frame): kScreen_Height : keyboardY - CGRectGetHeight(self.frame);
        if (selfOriginY == self.frame.origin.y) {
            return;
        }
        
        
        __weak typeof(self) weakSelf = self;
        void (^endFrameBlock)(void) = ^(){
            [weakSelf setY:selfOriginY];
        };
        if ([aNotification name] == UIKeyboardWillChangeFrameNotification) {
            NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
            UIViewAnimationCurve animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
            [UIView animateWithDuration:animationDuration delay:0.0f options:[UIView animationOptionsForCurve:animationCurve] animations:^{
                endFrameBlock();
            } completion:nil];
        }else{
            endFrameBlock();
        }
    }
}



- (void)updateContentViewBecauseOfMedia:(BOOL)becauseOfMedia{
    
    CGSize textSize = _inputTextView.contentSize, mediaSize = CGSizeZero;
    if (!becauseOfMedia) {
        if (ABS(CGRectGetHeight(_inputTextView.frame) - textSize.height) > 0.5) {
            [_inputTextView setHeight:textSize.height];
        }
    }
    if (_contentView.hidden) {
        textSize.height = kMessageInputView_Height - 2*kMessageInputView_PadingHeight;
    }
    CGSize contentSize = CGSizeMake(textSize.width, textSize.height + mediaSize.height);
    CGFloat selfHeight = MAX(kMessageInputView_Height, contentSize.height + 2*kMessageInputView_PadingHeight);
    
    CGFloat maxSelfHeight = kScreen_Height/2;
    if (kDevice_Is_iPhone5){
        maxSelfHeight = 230;
    }else if (kDevice_Is_iPhone6) {
        maxSelfHeight = 290;
    }else if (kDevice_Is_iPhone6Plus){
        maxSelfHeight = kScreen_Height/2;
    }else{
        maxSelfHeight = 140;
    }
    
    selfHeight = MIN(maxSelfHeight, selfHeight);
    CGFloat diffHeight = selfHeight - _viewHeightOld;
    if (ABS(diffHeight) > 0.5) {
        CGRect selfFrame = self.frame;
        selfFrame.size.height += diffHeight;
        selfFrame.origin.y -= diffHeight;
        [self setFrame:selfFrame];
        self.viewHeightOld = selfHeight;
    }
    [self.contentView setContentSize:contentSize];
    
    CGFloat bottomY = becauseOfMedia? contentSize.height: textSize.height;
    CGFloat offsetY = MAX(0, bottomY - (CGRectGetHeight(self.frame)- 2* kMessageInputView_PadingHeight));
    [self.contentView setContentOffset:CGPointMake(0, offsetY) animated:YES];
}


#pragma mark UITextViewDelegate M
- (void)sendTextStr{
    NSMutableString *sendStr = [NSMutableString stringWithString:self.inputTextView.text];
    if (sendStr && ![sendStr isEmpty] && _delegate && [_delegate respondsToSelector:@selector(messageInputView:sendText:)]) {
        [self.delegate messageInputView:self sendText:sendStr];
    }
    _inputTextView.selectedRange = NSMakeRange(0, _inputTextView.text.length);
    [_inputTextView insertText:@""];
    [self updateContentViewBecauseOfMedia:NO];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        if (![self.inputTextView.text hasListenChar]) {
            [self sendTextStr];
        }
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (self.inputState != UIMessageInputViewStateSystem) {
        self.inputState = UIMessageInputViewStateSystem;
        [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            [_emojiKeyboardView setY:kScreen_Height];
        } completion:^(BOOL finished) {
            self.inputState = UIMessageInputViewStateSystem;
        }];
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (self.inputState == UIMessageInputViewStateSystem) {
        [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            if (_isAlwaysShow) {
                [self setY:kScreen_Height- CGRectGetHeight(self.frame)];
            }else{
                [self setY:kScreen_Height];
            }
        } completion:^(BOOL finished) {
        }];
    }
    return YES;
}

#pragma mark remember input
- (NSMutableDictionary *)shareInputStrDict{
    if (!_inputStrDict) {
        _inputStrDict = [[NSMutableDictionary alloc] init];
    }
    return _inputStrDict;
}

- (void)saveInputStr{
    NSString *inputStr = _inputTextView.text;
    NSString *inputKey = [self inputKey];
    if (inputKey && inputKey.length > 0) {
        if (inputStr && inputStr.length > 0) {
            [[self shareInputStrDict] setObject:inputStr forKey:inputKey];
        }else{
            [[self shareInputStrDict] removeObjectForKey:inputKey];
        }
    }
}

- (NSString *)inputKey{
    NSString *inputKey = @"key";
    return inputKey;
}

#pragma mark AGEmojiKeyboardView

- (void)emojiKeyBoardView:(AGEmojiKeyboardView *)emojiKeyBoardView didUseEmoji:(NSString *)emoji {
    NSString *emotion_monkey = [emoji emotionSpecailName];
    if (emotion_monkey) {
        if (_delegate && [_delegate respondsToSelector:@selector(messageInputView:sendBigEmotion:)]) {
            [self.delegate messageInputView:self sendBigEmotion:emotion_monkey];
        }
    }else{
        [self.inputTextView insertText:emoji];
    }
}

- (void)emojiKeyBoardViewDidPressBackSpace:(AGEmojiKeyboardView *)emojiKeyBoardView {
    [self.inputTextView deleteBackward];
}

- (void)emojiKeyBoardViewDidPressSendButton:(AGEmojiKeyboardView *)emojiKeyBoardView{
    [self sendTextStr];
}

- (UIImage *)emojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView imageForSelectedCategory:(AGEmojiKeyboardViewCategoryImage)category {
    UIImage *img = [UIImage imageNamed:(category == AGEmojiKeyboardViewCategoryImageEmoji? @"keyboard_emotion_emoji":
                                        category == AGEmojiKeyboardViewCategoryImageMonkey? @"keyboard_emotion_monkey":
                                        category == AGEmojiKeyboardViewCategoryImageMonkey_Gif? @"keyboard_emotion_monkey_gif":
                                        @"keyboard_emotion_emoji_code")] ?: [UIImage new];
    return img;
}

- (UIImage *)emojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView imageForNonSelectedCategory:(AGEmojiKeyboardViewCategoryImage)category {
    return [self emojiKeyboardView:emojiKeyboardView imageForSelectedCategory:category];
}

- (UIImage *)backSpaceButtonImageForEmojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView {
    UIImage *img = [UIImage imageNamed:@"keyboard_emotion_delete"];
    return img;
}



@end
