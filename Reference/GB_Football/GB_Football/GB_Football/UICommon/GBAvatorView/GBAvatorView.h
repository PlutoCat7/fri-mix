//
//  GBAvatorView.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/24.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXNibBridge.h"

@interface GBAvatorView : UIView <XXNibBridge>

@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;

/**
 设置颜色  默认0x242526
 */
@property (nonatomic, strong) UIColor *bgColor;

/**
 设置间距  默认2.f
 */
@property (nonatomic, assign) CGFloat padding;

@end
