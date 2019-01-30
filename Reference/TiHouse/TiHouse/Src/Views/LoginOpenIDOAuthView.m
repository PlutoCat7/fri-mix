//
//  LoginOpenIDOAuthView.m
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/29.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "LoginOpenIDOAuthView.h"
#import "zhIconLabel.h"
#import "UIViewAnimation.h"
#import <UMSocialCore/UMSocialCore.h>
@interface LoginOpenIDOAuthView()

@property (nonatomic, retain) NSArray *items;

@end

@implementation LoginOpenIDOAuthView

-(instancetype)initWithFrame:(CGRect)frame{
    
    _items = [self models];
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        [self setUp];
        if (![[UMSocialManager defaultManager] isInstall:(UMSocialPlatformType_Sina)] && ![WXApi isWXAppInstalled] && ![[UMSocialManager defaultManager] isInstall:(UMSocialPlatformType_QQ)]) {
            self.hidden = YES;
        }
    }
    return self;
}

-(void)setUp{
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"第三方帐号登录";
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = kLineColer;
    [titleLabel sizeToFit];
    titleLabel.centerX = self.centerX;
    [self addSubview:titleLabel];
    
    UIView *rightView = [[UIView alloc]init];
    rightView.backgroundColor = kLineColer;
    [self addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).offset(7);
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.width.equalTo(@(87));
        make.height.equalTo(@(0.5));
    }];
    
    UIView *leftLine = [[UIView alloc]init];
    leftLine.backgroundColor = kLineColer;
    [self addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(titleLabel.mas_left).offset(-7);
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.width.equalTo(@(87));
        make.height.equalTo(@(0.5));
    }];
    
    
    CGFloat itemX = (kScreen_Width - 35*3 -28*2)/2;
    for (int i = 0; i<_items.count; i++) {
        zhIconLabelModel *model = _items[i];
        zhIconLabel *item = [[zhIconLabel alloc]initWithFrame:CGRectMake(itemX + i*(35+28), self.height, 35, 60)];
        item.model = model;
        item.horizontalLayout = NO;
        item.tag = 10+i;
        item.autoresizingFlexibleSize = NO;
        [item addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [item updateLayoutBySize:CGSizeMake(35, 60) finished:^(zhIconLabel *item) {
            
        }];
        if (![WXApi isWXAppInstalled] && i == 0){
            //没有安装微信的处理
            item.hidden = YES;
        }
        if (![[UMSocialManager defaultManager] isInstall:(UMSocialPlatformType_QQ)] && i == 1) {
            //没有安装QQ
            item.hidden = YES;
        }
        if (![[UMSocialManager defaultManager] isInstall:(UMSocialPlatformType_Sina)] && i == 2) {
            //没有安装QQ
            item.hidden = YES;
        }

        
        [self addSubview:item];
    }
}

-(NSArray *)models{
    
    NSArray *title = @[@"微信", @"微博", @"QQ"];
    NSArray *Icon = @[@"weixin_icon", @"weibo_icon", @"qq_icon"];
    NSMutableArray *models = [NSMutableArray new];
    for (int i = 0; i< title.count; i++) {
        zhIconLabelModel *model = [zhIconLabelModel modelWithTitle:title[i] image:[UIImage imageNamed:Icon[i]]];
        [models addObject:model];
    }
    return models;
}

-(void)showItems{
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[zhIconLabel class]]) {
            [UIView animateWithDuration: 0.6 delay:(idx-3)*0.1f usingSpringWithDamping:0.5 initialSpringVelocity:0.3 options:0 animations:^{
                obj.y = 37;
            } completion:nil];
        }
    }];
}

-(void)hideItems{
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[zhIconLabel class]]) {
            obj.y = self.height;
        }
    }];
}


-(void)click:(zhIconLabel *)item{
    
    if (_click) {
        _click(item.tag-10);
    }
    
}


@end
