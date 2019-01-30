//
//  LMColorSelectView.h
//  TiHouse
//
//  Created by yahua on 2018/2/7.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMColorSelectView : UIView

+ (instancetype)showWithView:(UIView *)view completeBlock:(void(^)(UIColor *color))completeBlock cancelBlock:(void(^)(void))cancelBlock;

- (void)close;

@end
