//
//  RKBButton.h
//  app
//
//  Created by 融口碑 on 2017/9/16.
//  Copyright © 2017年 王小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RKBButton : UIButton


typedef NS_ENUM(NSInteger, ItemLineStyle) {
    ItemLineStyleDefault,
    ItemLineStyleRightTop,
    ItemLineStyleRightBottom,
    ItemLineStyleRight,
    ItemLineStyleNone,
};


@property (nonatomic, copy) NSString *subTitle;

@property (nonatomic, assign) CGFloat topDistance;//图标距离顶部距离
@property (nonatomic, assign) ItemLineStyle itemLineStyle;
@property (nonatomic, retain) UIImageView *imageV;
@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UIView *bottomLine;
@property (nonatomic, retain) UIImage *icon;



-(instancetype) initWithFrame:(CGRect)frame Image:(UIImage *)icon Title:(NSString *)title;

-(instancetype) initWithImage:(UIImage *)icon Title:(NSString *)title;

@end
