//
//  CommentPopView.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CommentPopView.h"
#import "Login.h"
#import "UIImage+Scale.h"

@interface CommentPopView()

@property (nonatomic, retain) UIView *popView;
@property (nonatomic, retain) UIImageView *rightIcon;
@property (nonatomic, retain) UIView *btnsBgView;

@property (nonatomic, retain) UIButton *praiseBtn;
@property (nonatomic, retain) UIButton *commentBtn;
@property (nonatomic, retain) UIButton *shareBtn;
@property (nonatomic, retain) UIButton *editBtn;
@property (nonatomic, assign) CGFloat width;

@end


@implementation CommentPopView

-(instancetype)init{
    if (self = [super initWithFrame:kScreen_Bounds]) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled =YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Close)];
        [self addGestureRecognizer:tap];
        _width = (246 - 70) / 3;
        [self popView];
        [self rightIcon];
    }
    return self;
}



-(UIView *)popView{
    if (!_popView) {
        _popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 250, 37)];
        _popView.backgroundColor = [UIColor clearColor];
        _popView.clipsToBounds = YES;
        [self addSubview:_popView];
        [self btnsBgView];
    }
    return _popView;
}
-(UIView *)btnsBgView{
    if (!_btnsBgView) {
        _btnsBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 246, 37)];
        _btnsBgView.backgroundColor = XWColorFromHex(0x44444b);
        _btnsBgView.layer.cornerRadius = 4.0f;
        [_popView addSubview:_btnsBgView];
        [self praiseBtn];
        [self commentBtn];
        [self shareBtn];
        [self editBtn];
    }
    return _btnsBgView;
}
-(UIButton *)praiseBtn{
    if (!_praiseBtn) {
        _praiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_praiseBtn setTitle:@" 点赞" forState:UIControlStateNormal];
        _praiseBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//        [_praiseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -4)];
        _praiseBtn.tag = 1;
        [_praiseBtn addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
        [_praiseBtn setImage:[[UIImage imageNamed:@"praise_icon"]zs_scaledToSize:CGSizeMake(13, 11)] forState:UIControlStateNormal];
        [_praiseBtn setImage:[[UIImage imageNamed:@"praise_iconS"]zs_scaledToSize:CGSizeMake(13, 11)] forState:UIControlStateSelected];
        _praiseBtn.selected = NO;
        _praiseBtn.frame = CGRectMake(0, 0, _width, 37);
        [_btnsBgView addSubview:_praiseBtn];
    }
    return _praiseBtn;
}
-(UIButton *)commentBtn{
    if (!_commentBtn) {
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentBtn setTitle:@" 评论" forState:UIControlStateNormal];
        _commentBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _commentBtn.tag = 2;
//        [_commentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -4)];
        [_commentBtn addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
        [_commentBtn setImage:[[UIImage imageNamed:@"Shcomment_icon"]zs_scaledToSize:CGSizeMake(12, 12)] forState:UIControlStateNormal];
        _commentBtn.frame = CGRectMake(_width * 1, 0, _width, 37);
        [_btnsBgView addSubview:_commentBtn];
    }
    return _commentBtn;
}
-(UIButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setTitle:@" 分享" forState:UIControlStateNormal];
//        [_shareBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -4)];
        _shareBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _shareBtn.tag = 3;
        [_shareBtn addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
        [_shareBtn setImage:[[UIImage imageNamed:@"Tshare_icon"]zs_scaledToSize:CGSizeMake(23/2, 23/2)] forState:UIControlStateNormal];
        _shareBtn.frame = CGRectMake(_width * 2, 0, _width, 37);
        [_btnsBgView addSubview:_shareBtn];
    }
    return _shareBtn;
}
-(UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn setTitle:@" 编辑" forState:UIControlStateNormal];
//        [_editBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -2)];
        _editBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _editBtn.tag = 4;
        [_editBtn addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
        [_editBtn setImage:[[UIImage imageNamed:@"edit_icon"] zs_scaledToSize:CGSizeMake(13, 13)] forState:UIControlStateNormal];
        _editBtn.frame = CGRectMake(_btnsBgView.width-70, 0, 70, 37);
        [_btnsBgView addSubview:_editBtn];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 0.5, 17)];
        line.backgroundColor = XWColorFromHex(0x626268);
        [_editBtn addSubview:line];
        UIView *linetwo = [[UIView alloc]initWithFrame:CGRectMake(0.5, 10, 0.5, 17)];
        linetwo.backgroundColor = [UIColor blackColor];
        [_editBtn addSubview:linetwo];
    }
    return _editBtn;
}

-(UIImageView *)rightIcon{
    if (!_rightIcon) {
        UIImage *image = [UIImage imageNamed:@"comment_icon_right"];
        _rightIcon = [[UIImageView alloc]initWithImage:image];
        _rightIcon.image = image;
        _rightIcon.size = image.size;
        _rightIcon.x = CGRectGetMaxX(_btnsBgView.frame);
        _rightIcon.centerY = _btnsBgView.centerY;
        [_popView addSubview:_rightIcon];
    }
    return _rightIcon;
}


-(void)Click:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (self.CommentPopBtnClick) {
        self.CommentPopBtnClick(btn.tag, btn.selected);
    }
    [self Close];
}


-(void)ShowCommentWirhToView:(UIView *)view praises:(NSArray *)praises{
    
    User *user = [Login curLoginUser];
    __block NSInteger uid = user.uid;
    WEAKSELF
    [praises enumerateObjectsUsingBlock:^(Dairyzan *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.dairyzanuid == uid) {
            weakSelf.praiseBtn.selected = YES;
        }
    }];
    
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    CGRect toViewRect = [view.superview convertRect:view.frame toView:self];
    _popView.right = toViewRect.origin.x+2;
    _popView.centerY = toViewRect.origin.y + toViewRect.size.height/2;
    
    if (!_isMaster) {
        self.editBtn.hidden = YES;
        CGRect btnsBgViewFrame = self.btnsBgView.frame;
        btnsBgViewFrame.size.width -= 70;
        btnsBgViewFrame.origin.x += 70;
        self.btnsBgView.frame = btnsBgViewFrame;
    }

    
}

-(void)Close{
    WEAKSELF
    
    __block CGFloat popViewR = _popView.right;
    [UIView animateWithDuration:1 delay:1 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
//        weakSelf.praiseBtn.width = 0;
        weakSelf.popView.right = popViewR;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
