//
//  AddTallyPaymentTypeViewCell.m
//  TiHouse
//
//  Created by AlienJunX on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "TallyPaymentTypeViewCell.h"

@interface TallyPaymentTypeViewCell()

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UIImageView *selectedImageView;

@end


@implementation TallyPaymentTypeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *titleLabel = [UILabel new];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = XWColorFromHex(0x5c5c5c);
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.contentView).offset(15);
            make.centerY.equalTo(self.contentView);
        }];
        
        UIImageView *selectedImageView = [UIImageView new];
        [self.contentView addSubview:selectedImageView];
        self.selectedImageView = selectedImageView;
        [selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.contentView).offset(-10);
            make.centerY.equalTo(self.contentView);
        }];
        self.selectedImageView.image = [UIImage imageNamed:@"photo_select"];
    }
    return self;
}


- (void)setInfo:(NSString *)title isSelected:(BOOL)isSelected {
    self.titleLabel.text = title;
    self.selectedImageView.hidden = !isSelected;
}

@end
