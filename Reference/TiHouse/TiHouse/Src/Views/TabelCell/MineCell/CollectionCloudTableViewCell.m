//
//  CollectionCloudTableViewCell.m
//  TiHouse
//
//  Created by admin on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//


#import "CollectionCloudTableViewCell.h"

@interface CollectionCloudTableViewCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;
@end

@implementation CollectionCloudTableViewCell

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
        _titleLabel.text = _collectionCloud.name;
    }
    return _titleLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_countLabel];
        [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_right).offset(-60);
            make.centerY.equalTo(self.contentView);
        }];
        _countLabel.font = ZISIZE(11);
        _countLabel.textColor = XWColorFromHex(0xBFBFBF);
        _countLabel.text = [NSString stringWithFormat:@"%ld条记录", _collectionCloud.count];

    }
    return _countLabel;
}

-(void)setCollectionCloud:(CollectionCloud *)collectionCloud {
    _collectionCloud = collectionCloud;
    _titleLabel.text = collectionCloud.name;
    _countLabel.text = [NSString stringWithFormat:@"%ld条记录", collectionCloud.count];
}

@end

