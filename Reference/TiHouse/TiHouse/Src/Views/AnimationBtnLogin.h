//
//  AnimationBtnLogin.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/9.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimationBtnLogin : NSObject

@property (nonatomic, retain) UIView *coverView, *loginAnimView;//蒙板当用户点击注册或下一步的时候用于遮挡
@property (nonatomic,strong) CAShapeLayer *shapeLayer;//登录转圈的那条白线所在的layer

-(void)RemoveAnimationBtnLogin;
- (void)LoginFail;
-(void)AnimationBtnLoginWithTagView:(UIView *)view;

@end
