//
//  GBAvatorView.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/24.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBAvatorView.h"

@implementation GBAvatorView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.padding = 2.0f;
    //self.bgColor = [UIColor colorWithHex:0x242526];
}

- (void)setBgColor:(UIColor *)bgColor {
    
    _bgColor = bgColor;
    self.backgroundColor = bgColor;
}

- (void)setPadding:(CGFloat)padding {
    
    _padding = padding;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.layer.cornerRadius = self.width/2;
    
    self.avatorImageView.frame = CGRectMake(self.padding, self.padding, (self.width-self.padding*2), (self.width-self.padding*2));
    self.avatorImageView.layer.cornerRadius = self.avatorImageView.width/2;
}

@end
