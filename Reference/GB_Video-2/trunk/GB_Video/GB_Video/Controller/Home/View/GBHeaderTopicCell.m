//
//  GBHeaderTopicCell.m
//  GB_Video
//
//  Created by gxd on 2018/1/25.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "GBHeaderTopicCell.h"

@implementation GBHeaderTopicCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.imageView.clipsToBounds = YES;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.imageView.layer setCornerRadius:self.imageView.width/2];
        [self.imageView.layer setMasksToBounds:YES];
    });
}

@end
