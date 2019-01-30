//
//  RKBButton.m
//  app
//
//  Created by 融口碑 on 2017/9/16.
//  Copyright © 2017年 王小伟. All rights reserved.
//

#import "RKBButton.h"

@interface RKBButton()

{

    CGFloat imageVH;
    CGFloat imageVW;

}

@property (nonatomic, retain) UIView *topLine;
@property (nonatomic, retain) UIView *leftLine;
@property (nonatomic, retain) UIView *rightLine;
@property (nonatomic, retain) UILabel *subTitleV;

@end

@implementation RKBButton


-(instancetype) initWithFrame:(CGRect)frame Image:(UIImage *)icon Title:(NSString *)title{

    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        imageVH = icon.size.height/2;
        imageVW = icon.size.width/2;
        _icon = icon;
        
        //图标
        [self addSubview:self.imageView];
        self.imageView.image = icon;
        
        //标题
        [self addSubview:self.title];
        self.title.text = title;
        [self.title sizeToFit];
        
        
        
    }

    return self;
    
}

-(instancetype) initWithImage:(UIImage *)icon Title:(NSString *)title{
    
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        imageVH = icon.size.height;
        imageVW = icon.size.width;
        
        //图标
        [self addSubview:self.imageView];
        self.imageView.image = icon;
        
        //标题
        [self addSubview:self.title];
        self.title.text = title;
        
        
    }
    
    return self;
    
}


-(void)layoutSubviews{

    
    imageVH = _icon.size.height/2;
    imageVW = _icon.size.width/2;
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.height/2, self.height/2));
        make.top.equalTo(self).offset(self.height/8);
        make.centerX.equalTo(self);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(self.height/8);
        make.centerX.equalTo(self);
    }];
    
    

}


-(UIImageView *)imageView {

    if (!_imageV) {
        _imageV = [[UIImageView alloc]init];
    }
    return _imageV;
}

-(UILabel *) title{

    if (!_title) {
        
        _title = [[UILabel alloc]init];
        _title.textColor = [UIColor blackColor];
        _title.font = [UIFont systemFontOfSize:13];
        _title.adjustsFontSizeToFitWidth = YES;
        _title.textAlignment = NSTextAlignmentCenter;
        [self.title sizeToFit];
        
    }
    return _title;
    
}

@end
