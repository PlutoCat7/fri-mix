//
//  GBGameTimeDivisionTableViewCell.m
//  GB_Football
//
//  Created by 王时温 on 2017/5/11.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBGameTimeDivisionTableViewCell.h"

@implementation GBGameTimeDivisionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
