//
//  UserTextField.m
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/25.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "UserTextField.h"

@interface UserTextField()

@property (nonatomic, retain) UIImageView *icon;
@property (nonatomic, retain) UIView *line;


@end

@implementation UserTextField

-(instancetype)initWithPlaceholder:(NSString *)placeholder IconImage:(NSString *)icon{
    if (self = [super init]) {
        if (icon) {
            [self icon];
            _icon.image = [UIImage imageNamed:icon];
        }
        [self textField];
        _textField.placeholder = placeholder;
        [self line];
    }
    return self;
}

-(void)setTextFieldInsets:(UIEdgeInsets)textFieldInsets{
    
    _textFieldInsets = textFieldInsets;
    [_textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(textFieldInsets.right);
    }];
    [_textField.superview layoutIfNeeded];
}


#pragma mark - getters and setters
-(UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
        _icon.contentMode = UIViewContentModeCenter;
        _icon.userInteractionEnabled = YES;
        [self addSubview:_icon];
        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.and.left.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(26, 26));
        }];
    }
    return _icon;
}
-(UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.font = [UIFont systemFontOfSize:14];
        [self addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(5);
            make.bottom.equalTo(self).offset(-5);
            make.right.equalTo(self);
            make.left.equalTo(_icon ? _icon.mas_right : @(0));
        }];
    }
    return _textField;
}
-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = kLineColer;
        [self addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_textField);
            make.height.equalTo(@(0.5f));
            make.bottom.equalTo(self);
            make.right.equalTo(self);
        }];
    }
   return _line;
}

@end
