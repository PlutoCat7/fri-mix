//
//  CollectionSoulFolderTableViewCell.m
//  TiHouse
//
//  Created by admin on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CollectionSoulFolderTableViewCell.h"

@interface CollectionSoulFolderTableViewCell()
@end

@implementation CollectionSoulFolderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.topLineStyle = CellLineStyleFill;
        self.bottomLineStyle = CellLineStyleFill;
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
            make.left.equalTo(self.contentView).offset(kRKBWIDTH(20));
            make.centerY.equalTo(self.contentView);
        }];
        _titleLabel.font = ZISIZE(13);
        _titleLabel.textColor = XWColorFromHex(0x000000);
    }
    return _titleLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_countLabel];
        [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(kRKBWIDTH(-5));
            make.centerY.equalTo(self.contentView);
        }];
        _countLabel.font = ZISIZE(11);
        _countLabel.textColor = XWColorFromHex(0xBFBFBF);
    }
    return _countLabel;
}

-(void)setSoulfolder:(SoulFolder *)soulfolder {
    _soulfolder = soulfolder;
    _titleLabel.text = [NSString stringWithFormat:@"%@", soulfolder ? soulfolder.soulfoldername : @""];
    _countLabel.text = [NSString stringWithFormat:@"%d条记录", soulfolder ? soulfolder.countAssemblefile : 0];
}

@end


