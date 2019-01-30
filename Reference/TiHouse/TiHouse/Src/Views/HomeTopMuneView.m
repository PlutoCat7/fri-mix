//
//  HomeTopMuneView.m
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/16.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "HomeTopMuneView.h"
#import "FSCustomButton.h"
#import "RKBButton.h"

@interface HomeTopMuneView()

@property (nonatomic, retain) RKBButton *LeftItem;
@property (nonatomic, retain) RKBButton *RigttItem;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation HomeTopMuneView

-(instancetype)init{
    
    if (self = [super init]) {
        
        [self addSubview:self.LeftItem];
        [self addSubview:self.RigttItem];
   
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.bottomLine.frame = CGRectMake(0, self.frame.size.height - _bottomLine.height, self.width, 0.5f);
    [self.LeftItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.centerX.equalTo(@(-self.width/4));
        make.centerY.equalTo(self);
    }];
    
    [self.RigttItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.centerX.equalTo(@(self.width/4));
        make.centerY.equalTo(self);
    }];
}

-(RKBButton *)LeftItem{
    
    if (!_LeftItem) {
         _LeftItem = [[RKBButton alloc]initWithFrame:CGRectMake(40, 20, 100, 100) Image:[UIImage imageNamed:@"aa"]  Title:@"添加我的房屋"];
        _LeftItem.tag = 1;
        [_LeftItem addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _LeftItem;
}

-(RKBButton *)RigttItem{
    
    if (!_RigttItem) {
        _RigttItem = [[RKBButton alloc]initWithFrame:CGRectMake(40, 20, 100, 100) Image:[UIImage imageNamed:@"bb"]  Title:@"输入邀请码"];
        _RigttItem.tag = 2;
        [_RigttItem addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _RigttItem;
}

- (UIView *) bottomLine
{
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.height =0.5f;
        [_bottomLine setBackgroundColor:XWColorFromRGB(219, 219, 219)];
        [_bottomLine setAlpha:0.4];
        [self addSubview:_bottomLine];
    }
    return _bottomLine;
}

-(void)selected:(RKBButton *)btn{
    if (self.ClickItem) {
        self.ClickItem(btn.tag);
    }
}

@end
