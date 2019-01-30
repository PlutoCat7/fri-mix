//
//  ClearCacheTableViewCell.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ClearCacheTableViewCell.h"

@interface ClearCacheTableViewCell()

@property (nonatomic, strong) UIImageView *iconImgv;

@end

@implementation ClearCacheTableViewCell

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
        if (![self.reuseIdentifier isEqualToString:@"totalCellId"]) {
            [self iconImgv];
        }
        [self subLabel];
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

- (UIImageView *)iconImgv {
    if (!_iconImgv) {
        _iconImgv = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconImgv];
        [_iconImgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(@-12);
            make.size.equalTo(@14);
        }];
        _iconImgv.image = [UIImage imageNamed:@"mine_trash"];
    }
    return _iconImgv;
}

- (UILabel *)subLabel {
    if (!_subLabel) {
        _subLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_subLabel];
        [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(_iconImgv ? _iconImgv.mas_left : self.contentView).offset(-10);
        }];
        _subLabel.font = ZISIZE(13);
        _subLabel.textColor = kColor999;
    }
    return _subLabel;
}
@end
