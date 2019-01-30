//
//  TallyVoiceInputView.h
//  Demo2018
//
//  Created by AlienJunX on 2018/2/1.
//  Copyright © 2018年 AlienJunX. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TallyVoiceInputViewDelegate<NSObject>

- (void)voiceFinish:(NSString *)soundFilePath;

@end

@interface TallyVoiceInputView : UIView

@property (weak, nonatomic) id<TallyVoiceInputViewDelegate> delegate;


- (void)startRecord;

- (void)stopRecord;

- (void)cancelRecord;

// 识别错误
- (void)recogError;

- (void)recogFinish;

@end
