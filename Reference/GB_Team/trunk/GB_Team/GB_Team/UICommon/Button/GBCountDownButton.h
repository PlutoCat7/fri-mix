//
//  GBCountDownButton.h
//  GB_Football
//
//  Created by Pizza on 16/8/2.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBCountDownButton : UIButton

//是否正在倒计时
@property (nonatomic, assign) BOOL isCountdown;

- (void)startCountDown:(NSInteger)seconds;
- (void)stopCountDown;
@end
