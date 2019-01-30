//
//  CloudRecordListCell.m
//  TiHouse
//
//  Created by 陈晨昕 on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CloudRecordListCell.h"

@implementation CloudRecordListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)delBtnAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(CloudRecordListCellDelegateDelAction:)]) {
        [self.delegate CloudRecordListCellDelegateDelAction:sender.tag];
    }
}

@end
