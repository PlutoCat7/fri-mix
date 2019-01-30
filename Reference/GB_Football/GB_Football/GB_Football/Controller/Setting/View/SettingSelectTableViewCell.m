//
//  SettingSelectTableViewCell.m
//  GB_Football
//
//  Created by 王时温 on 2017/6/9.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "SettingSelectTableViewCell.h"

@interface SettingSelectTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation SettingSelectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    [super setHighlighted:highlighted animated:animated];
    if (self.type == SettingSelectTableViewCellType_Arrow) {
        self.bgView.backgroundColor = highlighted?[UIColor colorWithHex:0x202020 andAlpha:0.5]:[UIColor colorWithHex:0x202020];
    }else {
        self.bgView.backgroundColor = [UIColor colorWithHex:0x202020];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setType:(SettingSelectTableViewCellType)type {
    
    _type = type;
    switch (type) {
        case SettingSelectTableViewCellType_Text:
            self.nextImageView.hidden = YES;
            self.selectImageView.hidden = YES;
            break;
        case SettingSelectTableViewCellType_Arrow:
            self.nextImageView.hidden = NO;
            self.selectImageView.hidden = YES;
            break;
        case SettingSelectTableViewCellType_Select:
            self.nextImageView.hidden = YES;
            self.selectImageView.hidden = NO;
            break;
            
        default:
            break;
    }
}

@end
