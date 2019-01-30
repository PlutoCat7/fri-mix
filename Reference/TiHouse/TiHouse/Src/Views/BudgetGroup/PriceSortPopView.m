//
//  screenPopView.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "PriceSortPopView.h"
#import "Budgetpro.h"
@interface PriceSortPopView()

@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) UIButton *defaultBtn;
@property (nonatomic, retain) UIButton *descendingBtn;
@property (nonatomic, retain) UIButton *ascendingBtn;
@property (nonatomic, retain) UIImageView *icon;

@end

@implementation PriceSortPopView

-(instancetype)init{
    
    if (self = [super initWithFrame:kScreen_Bounds]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self contentView];
        [self icon];
        
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close)];
        [self addGestureRecognizer:tap];
    }
    return self;
}


-(void)setBudgetpro:(Budgetpro *)budgetpro{
    _budgetpro = budgetpro;
    if (!budgetpro.isSort) {
        UIButton *btn = [_contentView viewWithTag:1];
        [btn setTitleColor:XWColorFromHex(0xfec00c) forState:UIControlStateNormal];
        _icon.centerY = btn.centerY;
        return;
    }
    if (budgetpro.ascending) {
        UIButton *btn = [_contentView viewWithTag:3];
        [btn setTitleColor:XWColorFromHex(0xfec00c) forState:UIControlStateNormal];
        _icon.centerY = btn.centerY;
        return;
    }
    UIButton *btn = [_contentView viewWithTag:2];
    [btn setTitleColor:XWColorFromHex(0xfec00c) forState:UIControlStateNormal];
    _icon.centerY = btn.centerY;
}




-(UIView *)contentView{
    
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreen_Height, kScreen_Width, 150)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        NSArray * titles = @[@"默认排序",@"价格由高到低",@"价格由低到高"];
        for (int i=1; i<4; i++) {
           UIButton *_defaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_defaultBtn setTitle:titles[i-1] forState:UIControlStateNormal];
            _defaultBtn.frame = CGRectMake(0, 50*(i-1), _contentView.width, 50);
            _defaultBtn.tag = i;
            [_defaultBtn setTitleColor:kColor333 forState:UIControlStateNormal];
            [_defaultBtn addTarget:self action:@selector(reset:) forControlEvents:UIControlEventTouchUpInside];
            [_contentView addSubview:_defaultBtn];
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, _defaultBtn.width, 0.5)];
            line.backgroundColor = kLineColer;
            [_defaultBtn addSubview:line];
        }
        
    }
    return _contentView;
}

-(UIImageView *)icon{
    if (!_icon) {
        UIImage *image = [UIImage imageNamed:@"photo_select"];
        _icon = [[UIImageView alloc]init];
        _icon.image = image;
        _icon.size = image.size;
        _icon.centerX = _contentView.width - 30;
        _icon.centerY = 25;
        _icon.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_icon];
    }
    return _icon;
}


-(void)reset:(UIButton *)btn{
    
    [btn setTitleColor:XWColorFromHex(0xfec00c) forState:UIControlStateNormal];
    
    if (btn.tag == 1) {
        _budgetpro.isSort = NO;
    }else if(btn.tag == 2){
        _budgetpro.isSort = YES;
        _budgetpro.ascending = NO;
    }else{
        _budgetpro.isSort = YES;
        _budgetpro.ascending = YES;
    }
    
    if (_finishSelectde) {
        _finishSelectde(0,0);
    }
    [self close];
}


#pragma mark - private methods 私有方法
-(void)Show{
    
    [UIView animateWithDuration:0.2 delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        _contentView.y = kScreen_Height-150;
    } completion:nil];
    
}

-(void)close{
    [UIView animateWithDuration:0.2 delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        _contentView.y = kScreen_Height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



@end
