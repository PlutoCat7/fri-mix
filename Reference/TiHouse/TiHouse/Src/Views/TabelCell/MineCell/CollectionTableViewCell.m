//
//  CollectionTableViewCell.m
//  TiHouse
//
//  Created by admin on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CollectionTableViewCell.h"

@interface CollectionTableViewCell()
@end

@implementation CollectionTableViewCell

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
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self titleLabel];
        [self countLabel];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(12);
            make.centerY.equalTo(self.contentView);
        }];
        _titleLabel.font = ZISIZE(13);
        _titleLabel.text = @"";
    }
    return _titleLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_countLabel];
        [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_right).offset(-50);
            make.centerY.equalTo(self.contentView);
        }];
        _countLabel.textColor = XWColorFromHex(0xBFBFBF);
        _countLabel.font = ZISIZE(11);
        _countLabel.text = @"0";
    }
    return _countLabel;
}

@end
