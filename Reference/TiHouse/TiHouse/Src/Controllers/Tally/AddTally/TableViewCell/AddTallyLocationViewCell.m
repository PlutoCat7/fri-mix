//
//  AddTallyLocationViewCell.m
//  TiHouse
//
//  Created by AlienJunX on 2018/2/6.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AddTallyLocationViewCell.h"

@interface AddTallyLocationViewCell()
@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UILabel *descLabel;

@end

@implementation AddTallyLocationViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *titleLabel = [UILabel new];
        titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.contentView).offset(15);
            make.trailing.equalTo(self.contentView).offset(-15);
            make.top.equalTo(self.contentView).offset(7);
        }];
        
        UILabel *descLabel = [UILabel new];
        descLabel.textColor = [UIColor lightGrayColor];
        descLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:descLabel];
        self.descLabel = descLabel;
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(titleLabel.mas_leading);
            make.trailing.equalTo(titleLabel.mas_trailing);
            make.top.equalTo(titleLabel.mas_bottom).offset(2);
        }];
    }
    return self;
}

- (void)setInfo:(NSString *)title desc:(NSString *)desc {
    self.titleLabel.text = title;
    self.descLabel.text = desc;
    
    
    self.titleLabel.textColor = [UIColor blackColor];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(7);
    }];
}

- (void)setNoInfo {
    self.titleLabel.text = @"不显示位置";
    self.titleLabel.textColor = XWColorFromHex(0x576b95);
    self.descLabel.text = @"";
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(15);
    }];
}

@end
