//
//  HProgressView.h
//  Join
//
//  Created by 黄克瑾 on 2017/2/2.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HProgressView : UIView

@property (assign, nonatomic) NSInteger timeMax;

- (void)clearProgress;

@end
