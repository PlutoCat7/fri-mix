//
//  GBHomeCell.m
//  GB_Video
//
//  Created by gxd on 2018/1/25.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "GBHomeCell.h"

@implementation GBHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imageView.clipsToBounds = YES;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.imageView.layer setCornerRadius:5.f];
        [self.imageView.layer setMasksToBounds:YES];
    });
}

@end
