//
//  GBLipiCountDownButton.h
//  GB_Football
//
//  Created by Pizza on 2017/3/6.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBLipiCountDownButton : UIButton
- (void)startCountDown:(NSInteger)seconds;
- (void)stopCountDown;
- (void)setButtonEnable:(BOOL)enble;
@property (nonatomic, copy) NSString *defaultTitle;
@end
