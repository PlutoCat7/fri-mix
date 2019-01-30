//
//  ArticleMoreCollectionViewCell.m
//  TiHouse
//
//  Created by yahua on 2018/2/4.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ArticleMoreCollectionViewCell.h"

@implementation ArticleMoreCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.userAvatorImageView.layer.cornerRadius = self.userAvatorImageView.height/2;
    });
}

@end
