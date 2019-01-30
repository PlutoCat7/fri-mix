//
//  UIMessageInputView.h
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/21.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef NS_ENUM(NSInteger, UIMessageInputViewContentType) {
//    UIMessageInputViewContentTypeTweet = 0,
//    UIMessageInputViewContentTypePriMsg,
//    UIMessageInputViewContentTypeTopic,
//    UIMessageInputViewContentTypeTask
//};

typedef NS_ENUM(NSInteger, UIMessageInputViewState) {
    UIMessageInputViewStateSystem,
    UIMessageInputViewStateEmotion
};
@protocol UIMessageInputViewDelegate;

@interface UIMessageInputView : UIView<UITextViewDelegate>
@property (strong, nonatomic) NSString *placeHolder;
@property (assign, nonatomic) BOOL isAlwaysShow;

@property (nonatomic, weak) id<UIMessageInputViewDelegate> delegate;
+ (instancetype)messageInputView;
+ (instancetype)messageInputViewWithPlaceHolder:(NSString *)placeHolder;

- (void)prepareToShow;
- (void)prepareToDismiss;
- (BOOL)notAndBecomeFirstResponder;
- (BOOL)isAndResignFirstResponder;
- (BOOL)isCustomFirstResponder;

@end

@protocol UIMessageInputViewDelegate <NSObject>
@optional
- (void)messageInputView:(UIMessageInputView *)inputView sendText:(NSString *)text;
- (void)messageInputView:(UIMessageInputView *)inputView sendBigEmotion:(NSString *)emotionName;
- (void)messageInputView:(UIMessageInputView *)inputView sendVoice:(NSString *)file duration:(NSTimeInterval)duration;
- (void)messageInputView:(UIMessageInputView *)inputView addIndexClicked:(NSInteger)index;
- (void)messageInputView:(UIMessageInputView *)inputView heightToBottomChenged:(CGFloat)heightToBottom;
@end
