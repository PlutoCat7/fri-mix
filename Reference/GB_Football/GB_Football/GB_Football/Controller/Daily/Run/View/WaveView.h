//
//  WaveView.h
//  GB_Football
//
//  Created by gxd on 17/7/4.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^WaveViewAnimEndBlocck)();

@interface WaveView : UIView

+ (instancetype)showInView:(UIView *)view center:(CGPoint)center beginRadiu:(CGFloat)beginRadiu endRadiu:(CGFloat)endRadiu endBlock:(WaveViewAnimEndBlocck)endBlock;

@end
