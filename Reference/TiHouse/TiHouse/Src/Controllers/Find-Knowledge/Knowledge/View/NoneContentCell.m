//
//  NoneContentCell.m
//  MTTemplate
//
//  Created by Teen Ma on 2017/10/7.
//  Copyright © 2017年 Teen ma. All rights reserved.
//

#import "NoneContentCell.h"
#import "NoneContentViewModel.h"

@implementation NoneContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)resetCellWithViewModel:(BaseViewModel *)model
{
    [super resetCellWithViewModel:model];
    self.backgroundColor = model.cellBackgroundColor;
}

@end
