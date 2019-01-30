//
//  GBMessageTeamCell.m
//  GB_Football
//
//  Created by 王时温 on 2017/8/3.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBMessageTeamCell.h"

@implementation GBMessageTeamCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.refuseButton.enabled = YES;
    self.refuseButton.backgroundColor = [UIColor colorWithHex:0x171717];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)agreeAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickAgreeButton:)]) {
        [self.delegate didClickAgreeButton:self];
    }
}

- (IBAction)refuseButton:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickRefuseButton:)]) {
        [self.delegate didClickRefuseButton:self];
    }
}

@end
