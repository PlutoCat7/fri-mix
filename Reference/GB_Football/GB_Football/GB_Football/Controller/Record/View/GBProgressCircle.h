//
//  GBProgressCircle.h
//  GB_Football
//
//  Created by Pizza on 16/9/8.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBProgressCircle : UIView
@property (nonatomic, strong) UIColor *backColor;
@property (nonatomic, strong) UIColor *progressColor;
- (void)setPercent:(CGFloat)percent;
@end
