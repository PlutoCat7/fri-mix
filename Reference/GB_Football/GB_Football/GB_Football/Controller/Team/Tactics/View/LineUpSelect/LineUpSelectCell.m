//
//  UIComboBoxCell.m
//  GB_Team
//
//  Created by weilai on 16/9/19.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "LineUpSelectCell.h"

@implementation LineUpSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.selectedBackgroundView.backgroundColor = [[UIColor alloc]initWithRed:0.0 green:0.0 blue:0.0 alpha:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.teamName.textColor = (selected)?[UIColor greenColor]:[UIColor whiteColor];
    // Configure the view for the selected state
}

@end
