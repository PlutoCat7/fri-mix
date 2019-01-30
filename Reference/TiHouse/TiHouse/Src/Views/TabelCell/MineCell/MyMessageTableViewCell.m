//
//  MyMessageTableViewCell.m
//  TiHouse
//
//  Created by admin on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "MyMessageTableViewCell.h"

@interface MyMessageTableViewCell()
@end

@implementation MyMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.separatorInset = UIEdgeInsetsMake(0, 70, 0, 0);
        [self avatarImgView];
        [self titleLabel];
        [self detailsLabel];
        [self timeLabel];
    }
    return self;
}

- (UIImageView *)avatarImgView {
    if (!_avatarImgView) {
        _avatarImgView = [[UIImageView alloc] init];
        _avatarImgView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImgView.clipsToBounds = YES;
        _avatarImgView.layer.cornerRadius = kRKBWIDTH(25);
        _avatarImgView.layer.masksToBounds = YES;
        [self.contentView addSubview:_avatarImgView];
        [_avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(kRKBWIDTH(12.5));
            make.centerY.equalTo(self.contentView);
            make.size.equalTo(@(kRKBWIDTH(50)));
        }];
    }
    return _avatarImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarImgView.mas_right).offset(12);
            make.right.equalTo(self.contentView).offset(kRKBWIDTH(-60));
            make.top.equalTo(self.contentView).offset(kRKBHEIGHT(16));
        }];
        _titleLabel.font = ZISIZE(15);
        _titleLabel.textColor = XWColorFromHex(0x5186AA);
        _titleLabel.text = @"";
    }
    return _titleLabel;
}

- (UILabel *)detailsLabel {
    if (!_detailsLabel) {
        _detailsLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_detailsLabel];
        [_detailsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.top.equalTo(self.titleLabel).offset(kRKBHEIGHT(30));
            make.right.equalTo(self.contentView).offset(kRKBWIDTH(-60));
        }];
        _detailsLabel.font = ZISIZE(12);
        _detailsLabel.textColor = XWColorFromHex(0x999999);
    }
    return _detailsLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(kRKBWIDTH(-15));
            make.top.equalTo(self.contentView).offset(kRKBHEIGHT(16));
        }];
        _timeLabel.font = ZISIZE(13);
        _timeLabel.textColor = XWColorFromHex(0xBFBFBF);
        _timeLabel.text = @"";
    }
    return _timeLabel;
}

@end
