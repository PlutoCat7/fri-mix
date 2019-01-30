//
//  GBScanTableViewCell.m
//  GB_Football
//
//  Created by weilai on 16/8/29.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBScanTableViewCell.h"

@implementation GBScanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bindButton.enabled = YES;
    [self.bindButton setTitle:LS(@"pair.button.bind") forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)actionPressBind:(id)sender
{
    BLOCK_EXEC(self.clickBlock);
}

@end
