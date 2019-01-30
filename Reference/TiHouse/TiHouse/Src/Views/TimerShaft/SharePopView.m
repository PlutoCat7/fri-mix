//
//  screenPopView.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "SharePopView.h"
#import "zhIconLabel.h"
@interface SharePopView()<UIGestureRecognizerDelegate>

@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) UIButton *closeBtn;
@property (nonatomic, retain) UILabel *title;

@end

@implementation SharePopView

-(instancetype)init{
    
    if (self = [super initWithFrame:kScreen_Bounds]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self contentView];
        [self closeBtn];
        [self title];
        
        zhIconLabelModel *model1 = [zhIconLabelModel modelWithTitle:@"微信好友" image:[UIImage imageNamed:@"c_wchat"]];
        zhIconLabelModel *model2 = [zhIconLabelModel modelWithTitle:@"微信朋友圈" image:[UIImage imageNamed:@"c_wchat_circle"]];
        zhIconLabelModel *model3 = [zhIconLabelModel modelWithTitle:@"QQ好友" image:[UIImage imageNamed:@"c_qq"]];
        zhIconLabelModel *model4 = [zhIconLabelModel modelWithTitle:@"新浪微博" image:[UIImage imageNamed:@"c_sina"]];
        [self setModels:@[model1,model2,model3,model4]];
        
        //        self.userInteractionEnabled = YES;
        //        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close)];
        //        [self addGestureRecognizer:tap];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)dismiss {
    [self removeFromSuperview];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:_contentView]) {
        return NO;
    }
    return YES;
}

-(UIView *)contentView{
    
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreen_Height, kScreen_Width, 200)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.userInteractionEnabled = YES;
        [self addSubview:_contentView];
    }
    return _contentView;
}

-(UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setTitle:@"取消" forState:UIControlStateNormal];
        _closeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_closeBtn setTitleColor:kTitleAddHouseTitleCOLOR forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.frame = CGRectMake(0, _contentView.height - 55, _contentView.width, 55);
        [_contentView addSubview:_closeBtn];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(13, 0, _closeBtn.width-26, 0.5)];
        line.backgroundColor = XWColorFromHex(0xdbdbdb);
        [_closeBtn addSubview:line];
    }
    return _closeBtn;
}

-(UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc]initWithFrame:CGRectMake(16, 18, 100, 20)];
        _title.text = @"分享到";
        _title.font = [UIFont systemFontOfSize:12];
        _title.textColor = kColor999;
        [_contentView addSubview:_title];
    }
    return _title;
}

- (void)setModels:(NSArray<zhIconLabelModel *> *)models {
    
    CGFloat w = (_contentView.width - models.count*50 -44)/3;
    for (NSInteger i = 0; i < 4; i++) {
        zhIconLabel *item = [[zhIconLabel alloc]initWithFrame:CGRectMake(22 + i*(w+50), 50, 50,75)];
        [item addTarget:self action:@selector(ShareClick:) forControlEvents:UIControlEventTouchUpInside];
        item.model = models[i];
        item.tag = 1 + i;
        [item verticalLayoutSubviews];
        [_contentView addSubview:item];
    }
}

-(void)ShareClick:(zhIconLabel *)lab
{
    if (_finishSelectde) {
        _finishSelectde(lab.tag);
    }
}


#pragma mark - private methods 私有方法
-(void)Show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.2 delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        _contentView.y = kScreen_Height-200;
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

