//
//  BudgetDetailSort.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BudgetDetailSort.h"
@interface BudgetDetailSort()

@property (nonatomic, retain) UILabel *moneyView;
@property (nonatomic, retain) UIView *line;


@end

@implementation BudgetDetailSort


-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self titleView];
        [self screenBtn];
        [self sortBtn];
        [self line];
    }
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
}



-(UIButton *)screenBtn{
    if (!_screenBtn) {
        UIImage *closeImage = [UIImage imageNamed:@"screen"];
        _screenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_screenBtn setTitle:@"筛选" forState:UIControlStateNormal];
        [_screenBtn setTitleColor:kColor333 forState:UIControlStateNormal];
        _screenBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_screenBtn setImage:closeImage forState:UIControlStateNormal];
        [_screenBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, closeImage.size.width, 0, -closeImage.size.width)];
        _screenBtn.imageEdgeInsets = UIEdgeInsetsMake(0, [_screenBtn.titleLabel.text getWidthWithFont:_screenBtn.titleLabel.font constrainedToSize:CGSizeMake(150, 40)], 0, -[_screenBtn.titleLabel.text getWidthWithFont:_screenBtn.titleLabel.font constrainedToSize:CGSizeMake(150, 40)]);
        _screenBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -closeImage.size.width, 0, closeImage.size.width);
        _screenBtn.frame = CGRectMake(self.width-5-56, 0, 56, self.height);
        [self addSubview:_screenBtn];
    }
    return _screenBtn;
}

-(UIButton *)sortBtn{
    if (!_sortBtn) {
        UIImage *closeImage = [UIImage imageNamed:@"sort"];
        _sortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sortBtn setTitle:@"综合排序" forState:UIControlStateNormal];
        [_sortBtn setTitleColor:kColor333 forState:UIControlStateNormal];
        _sortBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_sortBtn setImage:closeImage forState:UIControlStateNormal];
        _sortBtn.imageEdgeInsets = UIEdgeInsetsMake(0, [_sortBtn.titleLabel.text getWidthWithFont:_sortBtn.titleLabel.font constrainedToSize:CGSizeMake(150, 40)], 0, -[_sortBtn.titleLabel.text getWidthWithFont:_sortBtn.titleLabel.font constrainedToSize:CGSizeMake(150, 40)]);
        _sortBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -closeImage.size.width, 0, closeImage.size.width);
        _sortBtn.frame = CGRectMake(_screenBtn.x-90, 0, 90, self.height);
        [self addSubview:_sortBtn];
//        [_sortBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(self.height, 190));
//            make.right.equalTo(_screenBtn.mas_left).offset(0);
//            make.top.bottom.equalTo(self);
//        }];
    }
    return _sortBtn;
}

-(UILabel *)titleView{
    if (!_titleView) {
        _titleView = [[UILabel alloc]init];
        _titleView.textColor = kColor666;
        _titleView.font = [UIFont systemFontOfSize:15 weight:10];
        _titleView.text = @"主材总费用¥1234356644545";
        [_titleView sizeToFit];
        [self addSubview:_titleView];
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(12);
            make.top.equalTo(self);
            make.width.equalTo(@(_titleView.size.width));
            make.height.equalTo(@(50));
        }];
    }
    return _titleView;
}
-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = XWColorFromHex(0xdbdbdb);
        [self addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.equalTo(@(0.5));
            make.top.equalTo(@(49.5));
        }];
    }
    return _line;
}



@end
