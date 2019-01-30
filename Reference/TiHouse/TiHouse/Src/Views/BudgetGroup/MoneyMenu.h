//
//  MoneyMenu.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/22.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoneyMenu : UIView

@property (nonatomic, retain) UILabel *titleView;
@property (nonatomic, retain) UILabel *moneyView;


-(instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title Money:(NSString *)money Icon:(UIImage *)icon ShowLine:(BOOL)line;
-(instancetype)initWithTitle:(NSString *)title Money:(NSString *)money Icon:(UIImage *)icon ShowLine:(BOOL)line;
-(instancetype)initWithTitle:(NSString *)title Money:(NSString *)money ShowLine:(BOOL)line;
-(instancetype)initWithTitle:(NSString *)title Money:(NSString *)money;
@end
