//
//  PSharePopView.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/2/10.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "PSharePopView.h"
#import "RKBButton.h"

@interface PSharePopView()

@property (nonatomic ,retain) UIView *bg;

@end

@implementation PSharePopView


-(instancetype)init{
    
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close)];
        [self addGestureRecognizer:tap];
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
        
        
        _bg = [[UIView alloc]initWithFrame:CGRectMake(0, kScreen_Height, kScreen_Width, 200)];
        _bg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        [self addSubview:_bg];
        
        UILabel *titleV = [[UILabel alloc]init];
        titleV.font = [UIFont systemFontOfSize:12];
        titleV.textColor = XWColorFromHex(0x999999);
        titleV.text = @"分享到";
        [titleV sizeToFit];
        titleV.x = 14;
        titleV.y = 17;
        [_bg addSubview:titleV];
        
        NSArray *titles = @[@"微信好友", @"微信朋友圈", @"qq好友", @"新浪微博", @"收藏", @"下载"];
        NSArray *icons = @[@"c_wchat",@"c_wchat_circle",@"c_qq",@"c_sina",@"c_star",@"c_load"];
        CGFloat ItemW = (kScreen_Width - 23*2 -((3)*35))/4;
        CGFloat ItemH = (_bg.height - 50)/2;
        
        for (int i = 0; i<titles.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i+1;
            btn.frame = CGRectMake(23 + i%4*(35+ItemW), 50+i/4*(ItemH), ItemW, ItemH);
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:11];
            [btn.titleLabel setFrame:CGRectMake(btn.titleLabel.x+10, btn.titleLabel.y, btn.titleLabel.width+20, btn.titleLabel.height)];
            [btn setImage:[UIImage imageNamed:icons[i]]  forState:UIControlStateNormal];
            btn.titleEdgeInsets = UIEdgeInsetsMake(8, -btn.imageView.frame.size.width, -btn.imageView.frame.size.height, 0);
            btn.imageEdgeInsets = UIEdgeInsetsMake(-btn.titleLabel.intrinsicContentSize.height, 0, 0, -btn.titleLabel.intrinsicContentSize.width);
            [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(ClickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_bg addSubview:btn];
            
            
            UILabel *titlev = [[UILabel alloc]init];
            titlev.text = titles[i];
            titlev.textColor = kTitleAddHouseCOLOR;
            titlev.font = [UIFont systemFontOfSize:11];
            [titlev sizeToFit];
//            titlev.centerX = btn.titleLabel.centerX +(btn.width-btn.titleLabel.centerX*2)/2;
            titlev.y = 0;
            [btn.titleLabel addSubview:titlev];
            if (i == 1) {
                titlev.x = -6;
            }
        }
        
    }
    return self;
}

-(void)show{
    UIButton *Btn = (UIButton *)[self viewWithTag:5];
    [Btn setImage:[UIImage imageNamed:_collected == YES ? @"c_select_star" : @"c_star"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        _bg.y = kScreen_Height-_bg.height;
    }];
}

-(void)close{
    [UIView animateWithDuration:0.3 animations:^{
        _bg.y = kScreen_Height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)ClickBtn:(UIButton *)btn{
    if (_ClickBtnWithTag) {
        _ClickBtnWithTag(btn.tag);
    }
    [self close];
}


@end
