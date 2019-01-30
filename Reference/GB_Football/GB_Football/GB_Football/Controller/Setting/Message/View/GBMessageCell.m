//
//  GBMessageCell.m
//  GB_Football
//
//  Created by Pizza on 16/9/8.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBMessageCell.h"
#import "UILabel+AutoSize.h"
@implementation GBMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
