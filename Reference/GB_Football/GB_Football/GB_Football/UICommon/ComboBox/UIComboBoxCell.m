//
//  UIComboBoxCell.m
//  GB_Team
//
//  Created by weilai on 16/9/19.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "UIComboBoxCell.h"

@interface UIComboBoxCell()
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;
@end

@implementation UIComboBoxCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self.teamName setTextColor:selected?[UIColor whiteColor]:[UIColor colorWithHex:0xb7b6b6]];
}
-(void)setupShowLine:(BOOL)top bottom:(BOOL)bottom
{
    self.line1.hidden = !top;
    self.line2.hidden = !bottom;
}
@end
