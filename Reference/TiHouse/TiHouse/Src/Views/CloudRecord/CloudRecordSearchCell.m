//
//  CloudRecordSearchCell.m
//  TiHouse
//
//  Created by 陈晨昕 on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CloudRecordSearchCell.h"

@implementation CloudRecordSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)closeBtnAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(CloudRecordSearchCellDelegateCloseAction:)]) {
        [self.delegate CloudRecordSearchCellDelegateCloseAction:sender.tag];
    }
}

@end
