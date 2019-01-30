//
//  OneClassMenus.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/25.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "OneClassMenus.h"
#import "oneMuneBtn.h"
#import "BudgetOneClass.h"

@interface OneClassMenus()

@property (nonatomic, retain) oneMuneBtn *oldBtn;
@property (nonatomic, retain) UIImageView *slidingBlock;
@end

@implementation OneClassMenus

-(instancetype)init{
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(void)setBtnDatas:(NSArray *)btnDatas{
    _btnDatas = btnDatas;
    if (![btnDatas.firstObject isKindOfClass:[BudgetOneClass class]]) {
        return;
    }
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat btnPi = (self.width - (btnDatas.count *kRKBWIDTH(50)))/4;
    for (int i = 0; i<btnDatas.count; i++) {
        
        oneMuneBtn *btn = [[oneMuneBtn alloc]init];
        btn.frame = CGRectMake(i*(kRKBWIDTH(50)+btnPi), 0, kRKBWIDTH(50), self.height);
        btn.OneClass = btnDatas[i];
        btn.tag = 10+i;
        [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        if (i==0) {
            btn.selected = YES;
            _oldBtn = btn;
            [self addSubview:self.slidingBlock];
            [_slidingBlock mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(btn.mas_centerX);
            }];
        }
    }
    
}

-(UIImageView *)slidingBlock{
    if (!_slidingBlock) {
        UIImage *image = [UIImage imageNamed:@"slidingBlock"];
        _slidingBlock = [[UIImageView alloc]init];
        _slidingBlock.image = image;
        _slidingBlock.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_slidingBlock];
        [_slidingBlock mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self);
            make.size.mas_equalTo(image.size);
        }];
    }
    return _slidingBlock;
}


-(void)BtnClick:(oneMuneBtn *)btn{
    _oldBtn.selected = NO;
    btn.selected = YES;
    _oldBtn = btn;
    
    if (_MenuClikcWihtTag) {
        _MenuClikcWihtTag(btn.tag-10);
    }
    [_slidingBlock mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btn.mas_centerX);
        make.bottom.equalTo(self);
        make.size.mas_equalTo(_slidingBlock.image.size);
    }];
    [UIView animateWithDuration:0.3 delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        [self layoutIfNeeded];
    } completion:nil];
}


@end
