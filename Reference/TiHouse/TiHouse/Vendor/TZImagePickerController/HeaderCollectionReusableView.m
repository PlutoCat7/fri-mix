//
//  HeaderCollectionReusableView.m
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/18.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "HeaderCollectionReusableView.h"

@implementation HeaderCollectionReusableView

-(id)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor=[UIColor clearColor];
        [self createBasicView];
    }
    return self;
    
}

/**
 *   进行基本布局操作,根据需求进行.
 */
-(void)createBasicView{
    
    [self addSubview:self.rightBtn];
    [self addSubview:self.rightLabel];
    [self addSubview:self.leftLabel];
    
}

-(void)setIsAllSelect:(BOOL)isAllSelect{
    _isAllSelect = isAllSelect;
    if (isAllSelect) {
        [_rightBtn setImage:[UIImage imageNamed:@""]forState:UIControlStateNormal];
        [_rightBtn setTitle:@"全选" forState:UIControlStateNormal];
        _rightBtn.titleLabel.textColor = [UIColor blueColor];
    }else{
        [_rightBtn setImage:[UIImage imageNamed:@"aa"]forState:UIControlStateNormal];
    }
}

-(UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self addSubview:_rightBtn];
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.height.equalTo(@(self.height-20));
            make.width.equalTo(@(40));
            make.top.equalTo(@(10));
        }];
    }
    return _rightBtn;
}

-(UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc]init];
        _leftLabel.font = [UIFont systemFontOfSize:14];
        _leftLabel.textColor = kTitleAddHouseTitleCOLOR;
        [self addSubview:_leftLabel];
        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.height.equalTo(@(self.height-20));
            make.width.equalTo(@(150));
            make.top.equalTo(@(10));
        }];
    }
    return _leftLabel;
}
-(UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc]init];
        _rightLabel.textAlignment = NSTextAlignmentRight;
        _rightLabel.font = [UIFont systemFontOfSize:14];
        _rightLabel.textColor = kTitleAddHouseTitleCOLOR;
        [self addSubview:_rightLabel];
        [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_rightBtn.mas_left);
            make.height.equalTo(@(self.height-20));
            make.width.equalTo(@(150));
            make.top.equalTo(@(10));
        }];
    }
    return _rightLabel;
}



@end
