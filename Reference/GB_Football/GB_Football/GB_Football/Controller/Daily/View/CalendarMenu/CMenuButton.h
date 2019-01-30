//
//  CMenuButton.h
//  GB_Football
//
//  Created by gxd on 17/6/7.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMenuButton : UIControl

@property (nonatomic, unsafe_unretained) BOOL isActive;
@property (nonatomic) CGGradientRef spotlightGradientRef;
@property (unsafe_unretained) CGFloat spotlightStartRadius;
@property (unsafe_unretained) float spotlightEndRadius;
@property (unsafe_unretained) CGPoint spotlightCenter;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *arrow;

@end
