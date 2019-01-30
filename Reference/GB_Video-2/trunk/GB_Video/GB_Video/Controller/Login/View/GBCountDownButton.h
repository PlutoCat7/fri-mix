//
//  GBCountDownButton.h
//  GB_Football
//
//  Created by Pizza on 16/8/2.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBCountDownButton : UIButton
- (void)startCountDown:(NSInteger)seconds;
- (void)stopCountDown;
- (void)setButtonEnable:(BOOL)enble;
@end
