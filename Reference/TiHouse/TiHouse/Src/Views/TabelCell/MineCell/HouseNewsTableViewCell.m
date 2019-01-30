//
//  HouseNewsTableViewCell.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "HouseNewsTableViewCell.h"

@interface HouseNewsTableViewCell()

@end

@implementation HouseNewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self portraitImgv];
        [self titleLabel];
        [self switchControl];
    }
    return self;
}

- (UIImageView *)portraitImgv {
    if (!_portraitImgv) {
        _portraitImgv = [[UIImageView alloc] init];
        [self.contentView addSubview:_portraitImgv];
        [_portraitImgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.centerY.equalTo(self.contentView);
            make.size.equalTo(@30);
        }];
        _portraitImgv.layer.cornerRadius = 15;
        _portraitImgv.layer.masksToBounds = YES;
    }
    return _portraitImgv;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_portraitImgv.mas_right).offset(10);
            make.centerY.equalTo(self.contentView);
        }];
        _titleLabel.font = ZISIZE(13);
    }
    return _titleLabel;
}

- (UISwitch *)switchControl {
    if (!_switchControl) {
        _switchControl = [[UISwitch alloc] init];
        [self.contentView addSubview:_switchControl];
        [_switchControl addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [_switchControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(@-12);
            make.height.equalTo(@30);
            make.width.equalTo(@50);
        }];
        _switchControl.onTintColor = [UIColor colorWithHexString:@"FEC00D"];
    }
    return _switchControl;
}

- (void)switchAction:(UISwitch *)switchControl {
    if (switchControl.isOn) {
        if ([_delegate respondsToSelector:@selector(editIsreceiOpen:)]) {
            [_delegate editIsreceiOpen:self];
        }
    } else {
        if ([_delegate respondsToSelector:@selector(editIsreceiClose:)]) {
            [_delegate editIsreceiClose:self];
        }
    }
    
    
}

@end
