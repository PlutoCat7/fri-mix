//
//  FeedbackCollectionViewCell.m
//  GB_Football
//
//  Created by yahua on 2018/1/12.
//  Copyright © 2018年 Go Brother. All rights reserved.
//

#import "FeedbackCollectionViewCell.h"

@implementation FeedbackCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected {
    
    [super setSelected:selected];
    self.bgView.backgroundColor = selected?[UIColor blackColor]:[UIColor colorWithHex:0x1F2021];
    self.titleLabel.textColor = selected?[ColorManager styleColor]:[UIColor colorWithHex:0xB4B5B6];
}

@end
