//
//  HomeTableViewCell.m
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/15.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "House.h"
#import "Login.h"
#import "POPSpringAnimation.h"

@interface HomeTableViewCell()

@property (nonatomic, strong) UIImageView *iconImageV;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UIImageView *ownerImageview;
@property (nonatomic, strong) UIImageView *relationIcon;

@end

@implementation HomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [self iconImageV];
        [self titleLabel];
        [self locationLabel];
        [self ownerImageview];
        [self relationIcon];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_relationIcon]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_relationIcon)]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.relationIcon attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    }
    return self;
}

-(void)layoutSubviews{
    
    self.leftFreeSpace = 12;
    [super layoutSubviews];
    self.topLine.y = 0;
    self.bottomLine.y = self.frame.size.height - _bottomLine.height;
    [self setBottomLineStyle:_bottomLineStyle];
    [self setTopLineStyle:_topLineStyle];
    

}



-(UIImageView *)iconImageV{
    
    if (!_iconImageV) {
        _iconImageV = [[UIImageView alloc]init];
        _iconImageV.layer.masksToBounds = YES;
        _iconImageV.layer.cornerRadius = kRKBHEIGHT(23);
        [self.contentView addSubview:_iconImageV];
        [_iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(kRKBWIDTH(20));
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(@(kRKBHEIGHT(46)));
            make.height.equalTo(@(kRKBHEIGHT(46)));
        }];
    }
    return _iconImageV;
}


-(UILabel *) titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = kTitleBlcakCOLOR;
        _titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:18]];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_iconImageV).offset(_iconImageV.height/9);
            make.left.equalTo(_iconImageV.mas_right).offset(10.f);
            make.width.equalTo(@(self.contentView.width-CGRectGetMaxX(_iconImageV.frame)-80));
            make.height.equalTo(@(20));
        }];
    }
    return _titleLabel;
}

-(UILabel *) locationLabel{
    
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc]init];
        _locationLabel.textColor = kTitleGaryCOLOR;
        _locationLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:10]];
        [self.contentView addSubview:_locationLabel];
        [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_iconImageV).offset(_iconImageV.height/9);
            make.left.equalTo(_iconImageV.mas_right).offset(10.f);
            make.width.equalTo(@(self.contentView.width-CGRectGetMaxX(_iconImageV.frame)-80));
            make.height.equalTo(@(15));
        }];
        
    }
    return _locationLabel;
}

- (UIImageView *)ownerImageview {
    if (!_ownerImageview) {
        _ownerImageview = [[UIImageView alloc] init];
        [self.contentView addSubview:_ownerImageview];
        [_ownerImageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(_iconImageV);
            make.size.equalTo(@(kRKBHEIGHT(16)));
        }];
        _ownerImageview.image = [UIImage imageNamed:@"owner"];
        _ownerImageview.hidden = YES;
    }
    return _ownerImageview;
}

-(void)setHouse:(House *)house{
    _house = house;
    //头像
    [_iconImageV sd_setImageWithURL:[NSURL URLWithString:house.urlfront] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    _titleLabel.text = house.housename;
    _locationLabel.text = [NSString stringWithFormat:@"%@, 共%ld条记录",house.residentname,house.numrecord];
    _ownerImageview.hidden = house.houseisself != 1;
    self.backgroundColor =  _house.housepersonisstick == 1 ? [UIColor colorWithHexString:@"0xfffef9"] : [UIColor whiteColor];
    self.relationIcon.image = [UIImage imageNamed:@"gx"];
    self.relationIcon.hidden = house.typerelation != 0;
    
    POPSpringAnimation* springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    springAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)];
    springAnimation.toValue =[NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    springAnimation.springBounciness = 20;
    [self.relationIcon.layer pop_addAnimation:springAnimation forKey:@"SpringAnimation"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setTopLineStyle:(CellLineStyle)style
{
    
    _topLineStyle = style;
    if (style == CellLineStyleDefault) {
        self.topLine.left = _leftFreeSpace;
        self.topLine.width = self.width - _leftFreeSpace - _rightFreeSpace;
        [self.topLine setHidden:NO];
    }
    else if (style == CellLineStyleFill) {
        self.topLine.x = 0;
        self.topLine.width = self.frame.size.width;
        [self.topLine setHidden:NO];
    }
    else if (style == CellLineStyleNone) {
        [self.topLine setHidden:YES];
    }
}

- (void) setBottomLineStyle:(CellLineStyle)style
{
    _bottomLineStyle = style;
    if (style == CellLineStyleDefault) {
        self.bottomLine.x = _leftFreeSpace;
        self.bottomLine.width = self.width - _leftFreeSpace - _rightFreeSpace;
        [self.bottomLine setHidden:NO];
    }
    else if (style == CellLineStyleFill) {
        self.bottomLine.x = 0;
        self.bottomLine.width = self.width;
        [self.bottomLine setHidden:NO];
    }
    else if (style == CellLineStyleNone) {
        [self.bottomLine setHidden:YES];
    }
}

- (UIView *) bottomLine
{
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.height =0.5f;
        [_bottomLine setBackgroundColor:kLineColer];
        [_bottomLine setAlpha:1];
        [self.contentView addSubview:_bottomLine];
    }
    return _bottomLine;
}

- (UIView *) topLine
{
    if (_topLine == nil) {
        _topLine = [[UIView alloc] init];
        _topLine.height = 0.5f;
        [_topLine setBackgroundColor:kLineColer];
        [_topLine setAlpha:1];
        [self.contentView addSubview:_topLine];
    }
    return _topLine;
}

- (UIImageView *)relationIcon
{
    if (!_relationIcon)
    {
        _relationIcon = [KitFactory imageView]; 
        _relationIcon.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_relationIcon];
        
    }
    return _relationIcon;
}

@end
