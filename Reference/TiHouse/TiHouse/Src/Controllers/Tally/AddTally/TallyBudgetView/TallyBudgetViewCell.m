//
//  AddTallyPaymentTypeViewCell.m
//  TiHouse
//
//  Created by AlienJunX on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "TallyBudgetViewCell.h"

@interface TallyBudgetViewCell()

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UILabel *timeLabel;
@property (weak, nonatomic) UIImageView *selectedImageView;

@end


@implementation TallyBudgetViewCell

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
        
        UILabel *timeLabel = [UILabel new];
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        timeLabel.font = [UIFont systemFontOfSize:10];
        timeLabel.textColor = [UIColor lightGrayColor];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.contentView).offset(-5);
            make.centerY.equalTo(self.contentView);
        }];
        
        UIImageView *selectedImageView = [UIImageView new];
        [self.contentView addSubview:selectedImageView];
        self.selectedImageView = selectedImageView;
        [selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.contentView);
        }];
        self.selectedImageView.image = [UIImage imageNamed:@"photo_select"];
    }
    return self;
}


- (void)setInfo:(NSString *)title upDate:(NSString *)time isSelected:(BOOL)isSelected {
    self.titleLabel.text = title;
    self.timeLabel.text = [NSString stringWithFormat:@"最近修改：%@",time];
    self.selectedImageView.hidden = !isSelected;
}

@end
