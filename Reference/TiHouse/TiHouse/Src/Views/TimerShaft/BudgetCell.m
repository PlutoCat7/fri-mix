//
//  BudgetCell.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BudgetCell.h"
#import "Budget.h"
@interface BudgetCell()


@end

@implementation BudgetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = XWColorFromHex(0xfcfcfc);
        [self moneyLabel];
        [self icon];
        [self titleLabel];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _moneyLabel.right = self.contentView.width-12;
    _moneyLabel.height = 35;
    _icon.centerY = self.contentView.height/2;
}

-(void)setBudget:(Budget *)Budget{
    _Budget = Budget;
    NSString *transformStr;
    NSString *image;
    switch (Budget.budgetopetype) {
        case 1:
            transformStr = @"添加了：";
            image = @"jia_icon";
            break;
        case 2:
            transformStr = @"修改了：";
            image = @"cha_icon";
            break;
        case 3:
            transformStr = @"删除了：";
            image = @"shan_icon";
            break;
        case 4:
            transformStr = @"设置了星标项目：";
            image = @"buyIcon";
            break;
        case 5:
            transformStr = @"设置了已购项目：";
            image = @"moey_icon";
            
            break;
            
        default:
            break;
    }
    _icon.image = [UIImage imageNamed:image];
    _titleLabel.text =  [NSString stringWithFormat:@"%@%@",transformStr,_Budget.budgetopename];
    _moneyLabel.text = [NSString stringWithFormat:@"¥%@",[NSString strmethodComma:[NSString stringWithFormat:@"%ld",_Budget.amountzj/100]]];
    
}

-(UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(12, 0, 14, 14)];
        _icon.centerY = self.contentView.height/2;
        [self.contentView addSubview:_icon];
    }
    return _icon;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_icon.frame)+2, 0, 200, 35)];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}
-(UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.contentView.width-12-200, 0, 200, 25)];
        _moneyLabel.font = [UIFont systemFontOfSize:12 weight:10];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        _moneyLabel.right = self.contentView.width-12;
        _moneyLabel.textColor = XWColorFromHex(0xfbc33b);
        [self.contentView addSubview:_moneyLabel];
    }
    return _moneyLabel;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
