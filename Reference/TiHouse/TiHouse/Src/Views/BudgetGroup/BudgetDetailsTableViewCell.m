//
//  BudgetDetailsTableViewCell.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BudgetDetailsTableViewCell.h"
#import "BudgetThreeClass.h"
@interface BudgetDetailsTableViewCell()

@property (nonatomic, retain) UIView *contentBgView;
@property (nonatomic, retain) UIImageView *buyIcon;
@property (nonatomic, retain) UIImageView *starIcon;
@property (nonatomic, retain) UIImageView *rightIcon;
@property (nonatomic, retain) UILabel *titleView;
@property (nonatomic, retain) UILabel *proremarkView;
@property (nonatomic, retain) UILabel *moneyView;

@end

@implementation BudgetDetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.accessoryType = UITableViewCellAccessoryNone;
        self.bottomLineStyle = CellLineStyleNone;
        
        [self contentBgView];
        [self buyIcon];
        [self starIcon];
        [self titleView];
        [self proremarkView];
        [self rightIcon];
        [self moneyView];
        [self deletebtn];
    }
    return self;
}




#pragma mark - getters and setters
-(void)setThreeClass:(BudgetThreeClass *)threeClass{
    _threeClass = threeClass;
    _titleView.text = threeClass.proname;
    
    if (threeClass.proremark.length > 10) {
        _proremarkView.text = [NSString stringWithFormat:@"- %@...",[threeClass.proremark substringToIndex:9]];
    } else if (threeClass.proremark.length > 0) {
        _proremarkView.text = [NSString stringWithFormat:@"- %@",threeClass.proremark];
    } else {
        _proremarkView.text = @"";
    }

    [_titleView sizeToFit];
    _moneyView.text = [NSString stringWithFormat:@"¥%@",[NSString strmethodComma:[NSString stringWithFormat:@"%.0f",threeClass.amountzj / 100.0f]]];
    [_moneyView sizeToFit];
    
    if (!threeClass.protypexb) {
        [_buyIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentBgView).offset(0);
            make.centerY.equalTo(_contentBgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
    }else{
        [_buyIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentBgView).offset(10);
            make.centerY.equalTo(_contentBgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(12.5f, 12.5f));
        }];
    }
    if (!threeClass.protypeyg) {
        [_starIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_buyIcon.mas_right).offset(0);
            make.centerY.equalTo(_contentBgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
    }else{
        [_starIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_buyIcon.mas_right).offset(threeClass.protypexb?4:10);
            make.centerY.equalTo(_contentBgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(12.5f, 12.5f));
        }];
    }
    _deletebtn.hidden = YES;
    if (!threeClass.catethreestatus) {
        _deletebtn.hidden = NO;
    }
    [_titleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_starIcon.mas_right).offset(!threeClass.protypeyg && !threeClass.protypexb ? 10 : threeClass.protypeyg || threeClass.protypexb ? 4 : 0);
        make.centerY.equalTo(_contentBgView.mas_centerY);
        make.size.mas_equalTo(_titleView.size);
    }];
    [_proremarkView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleView.mas_right).offset(4);
        make.centerY.equalTo(_contentBgView.mas_centerY);
        make.size.mas_equalTo([_proremarkView sizeThatFits:CGSizeMake(100, 20)]);
    }];
    [_moneyView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_rightIcon.mas_left).offset(-10);
        make.centerY.equalTo(_contentBgView.mas_centerY);
        make.size.mas_equalTo(_moneyView.size);
    }];

    
}

-(void)setIsAdd:(BOOL)isAdd{
    
    if (isAdd) {
        _titleView.text = @"添加项目";
        _contentBgView.backgroundColor = [UIColor clearColor];
        _rightIcon.hidden = YES;
        _moneyView.hidden = YES;
        _deletebtn.hidden = YES;
        _proremarkView.hidden = YES;
        [_titleView sizeToFit];
        _buyIcon.image = [UIImage imageNamed:@"BudgetDetails_add"];
        [_buyIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentBgView).offset(10);
            make.centerY.equalTo(_contentBgView.mas_centerY);
            make.size.mas_equalTo(_buyIcon.image.size);
        }];
        [_starIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_starIcon.mas_right).offset(0);
            make.centerY.equalTo(_contentBgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(0.1, 0.1));
        }];
        [_titleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_starIcon.mas_right).offset(4);
            make.centerY.equalTo(_contentBgView.mas_centerY);
            make.size.mas_equalTo(_titleView.size);
        }];
    }else{
        _starIcon.image = [UIImage imageNamed:@"moey_icon"];
        _contentBgView.backgroundColor = [UIColor whiteColor];
        _rightIcon.hidden = NO;
        _moneyView.hidden = NO;
        _proremarkView.hidden = NO;
        _buyIcon.image = [UIImage imageNamed:@"buyIcon"];
        [_buyIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentBgView).offset(10);
            make.centerY.equalTo(_contentBgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(12.5f, 12.5f));
        }];
        [_starIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_buyIcon.mas_right).offset(4);
            make.centerY.equalTo(_contentBgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(12.5f, 12.5f));
        }];
    }
}



-(UIView *)contentBgView{
    if (!_contentBgView) {
        _contentBgView = [[UIView alloc]init];
        _contentBgView.backgroundColor = [UIColor whiteColor];
        _contentBgView.layer.cornerRadius = 3;
        _contentBgView.layer.shadowColor = [UIColor blackColor].CGColor;
        _contentBgView.layer.shadowOffset = CGSizeMake(-1, -1);
        _contentBgView.layer.shadowOpacity = 0.1;
        [self.contentView addSubview:_contentBgView];
        [_contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.left.equalTo(self.contentView).offset(12);
            make.right.equalTo(self.contentView).offset(-12);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return _contentBgView;
}


-(UIImageView *)buyIcon{
    if (!_buyIcon) {
        UIImage *image =[UIImage imageNamed:@"buyIcon"];
        _buyIcon = [[UIImageView alloc]init];
        _buyIcon.image = image;
        _buyIcon.contentMode = UIViewContentModeScaleAspectFit;
        [_contentBgView addSubview:_buyIcon];
        [_buyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentBgView).offset(10);
            make.centerY.equalTo(_contentBgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(12.5f, 12.5f));
        }];
    }
    return _buyIcon;
}

-(UIImageView *)starIcon{
    if (!_starIcon) {
        UIImage *image =[UIImage imageNamed:@"moey_icon"];
        _starIcon = [[UIImageView alloc]init];
        _starIcon.image = image;
        _starIcon.contentMode = UIViewContentModeScaleAspectFit;
        [_contentBgView addSubview:_starIcon];
        [_starIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_buyIcon.mas_right).offset(4);
            make.centerY.equalTo(_contentBgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(12.5f, 12.5f));
        }];
    }
    return _starIcon;
}

-(UIImageView *)rightIcon{
    if (!_rightIcon) {
        UIImage *image =[UIImage imageNamed:@"bu_right"];
        _rightIcon = [[UIImageView alloc]init];
        _rightIcon.contentMode = UIViewContentModeScaleAspectFit;
        _rightIcon.image = image;
        [_contentBgView addSubview:_rightIcon];
        [_rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_contentBgView).offset(-10);
            make.centerY.equalTo(_contentBgView.mas_centerY);
            make.size.mas_equalTo(image.size);
        }];
    }
    return _rightIcon;
}

-(UILabel *)titleView{
    if (!_titleView) {
        _titleView = [[UILabel alloc]init];
        _titleView.textColor = XWColorFromHex(0x5186aa);
        _titleView.font = [UIFont systemFontOfSize:17];
        [_contentBgView addSubview:_titleView];
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_starIcon.mas_right).offset(4);
            make.centerY.equalTo(_contentBgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
    }
    return _titleView;
}

-(UILabel *)proremarkView{
    if (!_proremarkView) {
        _proremarkView = [[UILabel alloc]init];
        _proremarkView.textColor = kColor999;
        _proremarkView.font = [UIFont systemFontOfSize:15];
        [_contentBgView addSubview:_proremarkView];
        [_proremarkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleView.mas_right).offset(4);
            make.centerY.equalTo(_contentBgView.mas_centerY);
            make.size.mas_equalTo([_proremarkView sizeThatFits:CGSizeMake(100, 20)]);
        }];
    }
    return _proremarkView;
}

-(UIButton *)deletebtn{
    if (!_deletebtn) {
        _deletebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deletebtn.backgroundColor = [UIColor redColor];
        [_deletebtn setTitle:@"删除" forState:UIControlStateNormal];
        _deletebtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_deletebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _deletebtn.layer.cornerRadius = 6;
        _deletebtn.tag = 10;
        _deletebtn.hidden = YES;
        [_deletebtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [_contentBgView addSubview:_deletebtn];
        [_deletebtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_proremarkView.mas_right).offset(6);
            make.centerY.equalTo(_contentBgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(46, 23));
        }];
    }
    return _deletebtn;
}


-(void)deleteClick{
    if (_deleteBudget) {
        _deleteBudget();
    }
}



-(UILabel *)moneyView{
    if (!_moneyView) {
        _moneyView = [[UILabel alloc]init];
        _moneyView.textColor = XWColorFromHex(0xfec00c);
        _moneyView.font = [UIFont systemFontOfSize:16];
        [_contentBgView addSubview:_moneyView];
        [_moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_rightIcon.mas_left).offset(-10);
            make.centerY.equalTo(_contentBgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
    }
    return _moneyView;
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
