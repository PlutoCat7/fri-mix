//
//  NotificationTableViewCell.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "NotificationTableViewCell.h"

@interface NotificationTableViewCell()

@property (nonatomic, strong) UIImageView *arrow;

@end

@implementation NotificationTableViewCell

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
        [self titleLabel];
        if ([self.reuseIdentifier isEqualToString:@"switchCellId"]) {
            [self switchControl];
        } else if ([self.reuseIdentifier isEqualToString:@"openNotificationCellId"]) {
            [self subLabel];
        } else {
            [self arrow];
        }
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
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

- (UILabel *)subLabel {
    if (!_subLabel) {
        _subLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_subLabel];
        [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(@-12);
        }];
        _subLabel.font = ZISIZE(13);
        _subLabel.textColor = [UIColor colorWithHexString:@"bfbfbf"];
    }
    return _subLabel;
}

- (UIImageView *)arrow {
    if (!_arrow) {
        _arrow = [[UIImageView alloc] init];
        [self.contentView addSubview:_arrow];
        [_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-12);
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(@9);
            make.height.equalTo(@15);
        }];
        _arrow.image = [UIImage imageNamed:@"mine_grayarrow"];
    }
    return _arrow;
}


- (void)switchAction:(UISwitch *)switchControl {
    if ([_delegate respondsToSelector:@selector(modifyNotificationStatus:title:)]) {
        [_delegate modifyNotificationStatus:[switchControl isOn] title:self.titleLabel.text];
    }
}

@end
