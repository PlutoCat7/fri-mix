//
//  AddHouseTableViewCell.m
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/16.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "AddHouseTableViewCell.h"

@interface AddHouseTableViewCell()


@end

@implementation AddHouseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.TextField];
        [self icon];
        [self imageV];
        [self Title];
    }
    return self;
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.TextField];
        [self icon];
        [self imageV];
        [self Title];
    
    }
    return self;
}

-(void)layoutSubviews{
    self.leftFreeSpace = 12;
    self.rightFreeSpace = 12;
    [super layoutSubviews];
    
    if (_imageV.image) {
        [_imageV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(self.contentView.height-16, self.contentView.height-16));
            make.left.equalTo(_icon.mas_right).offset(10);
        }];
    }
    
    if (self.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
        
        [_TextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(0);
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(100);
        }];
    }else{
        
        [_TextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-14);
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(100);
        }];
    }

}

-(void)setImage:(UIImage *)image{
    
    _image = image;
    [_icon setImage:image forState:UIControlStateNormal];
    [_icon mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(image.size);
    }];
    [_Title mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageV.mas_right).offset(5);
    }];
    
}


-(UITextField *)TextField{
    if (!_TextField) {
        _TextField = [[UITextField alloc]init];
        _TextField.textAlignment = NSTextAlignmentRight;
        _TextField.font = [UIFont systemFontOfSize:16.0f];
        _TextField.textColor = kTitleAddHouseCOLOR;
    }
    return _TextField;
}

-(UIButton *)icon{
    
    if (!_icon) {
        _icon = [UIButton buttonWithType:UIButtonTypeCustom];
        [_icon addTarget:self action:@selector(SelectedBen:) forControlEvents:UIControlEventTouchUpInside];
        _icon.userInteractionEnabled = NO;
        _icon.selected = NO;
        [self.contentView addSubview:_icon];
        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(16);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
    }
    return _icon;
}

-(UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc]init];
        _imageV.contentMode = UIViewContentModeScaleAspectFill;
        _imageV.clipsToBounds = YES;
        _imageV.layer.cornerRadius = 6.0f;
        _imageV.layer.masksToBounds = YES;
        [self.contentView addSubview:_imageV];
        [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_icon.mas_right).offset(0);
            make.top.equalTo(self.contentView).offset(8);
            make.bottom.equalTo(self.contentView).offset(-8);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
    }
    return _imageV;
}

-(UILabel *)Title{
    if (!_Title) {
        _Title = [[UILabel alloc]init];
        _Title.textColor = kTitleAddHouseTitleCOLOR;
        _Title.font = [UIFont systemFontOfSize:14 * [[UIScreen mainScreen] bounds].size.width / 375];
        [self.contentView addSubview:_Title];
        [_Title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imageV.mas_right);
            make.top.bottom.equalTo(self);
            make.width.equalTo(@(200));
        }];
    }
    return _Title;
}

-(void)SelectedBen:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
