//
//  CollectionSoulFolderCreateTableViewCell.m
//  TiHouse
//
//  Created by admin on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "SoulFolderCreateTableViewCell.h"

@interface SoulFolderCreateTableViewCell()

@property (nonatomic, strong) UIImageView *add;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation SoulFolderCreateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubview];
    }
    return self;
}

- (void)initSubview {
    if (!_add) {
        _add = [[UIImageView alloc] init];
        [self.contentView addSubview:_add];
        _add.image = [UIImage imageNamed:@"add_soulfolder"];
        [_add mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(kRKBWIDTH(20));
            make.centerY.equalTo(self.contentView);
        }];
    }
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_titleLabel];
        _titleLabel.text = @"创建新的灵感册";
        _titleLabel.textColor = XWColorFromHex(0xBFBFBF);
        _titleLabel.font = ZISIZE(12);
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(kRKBWIDTH(40));
            make.right.equalTo(self.contentView).offset(kRKBWIDTH(-20));
            make.centerY.equalTo(self.contentView);
        }];
    }
}


@end
