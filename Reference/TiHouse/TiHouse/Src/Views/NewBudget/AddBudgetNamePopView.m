//
//  NewBudgetPopView.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/24.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AddBudgetNamePopView.h"

@interface AddBudgetNamePopView()

@property (nonatomic, retain) UIImageView *imageV;
@property (nonatomic, retain) UIButton *iKnowBtn;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) UITextField *nameTextField;

@end

@implementation AddBudgetNamePopView

-(instancetype)init{
    if (self = [super initWithFrame:kScreen_Bounds]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        [self contentView];
        [self imageV];
        [self iKnowBtn];
        [self nameTextField];
    }
    return self;
}

#pragma mark - event response
-(void)Show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration: 0.6 delay:0.1f usingSpringWithDamping:0.5 initialSpringVelocity:0.3 options:0 animations:^{
        _contentView.y = 140;
    } completion:^(BOOL finished) {
//        _nameTextField
    }];
    
}

-(void)close{
    [UIView animateWithDuration:0.2 delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        _contentView.y = kScreen_Height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)finish{
    NSString *name = _nameTextField.text;
    if (self.finishBlock && name.length>0) {
        self.finishBlock(name);
        [self close];
    }else{
        [NSObject showHudTipStr:@"请输入项目名称"];
    }
}

#pragma mark - getters and setters
-(UIView *)contentView{
    if (!_contentView) {
        UIImage *image = [UIImage new];
        image = [UIImage imageNamed:@"addBudgetName_icon"];
        _contentView = [[UIView alloc]init];
        [self addSubview:_contentView];
        _contentView.size = image.size;
        _contentView.height = image.size.height + 75;
        _contentView.centerX = self.centerX;
        _contentView.y = -kScreen_Height;
        _contentView.userInteractionEnabled = YES;
        
        UIImage *closeImage = [UIImage imageNamed:@"budget_ close"];
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.size = closeImage.size;
        closeBtn.y = _contentView.height-closeImage.size.height;
        closeBtn.centerX = _contentView.width/2;
        [closeBtn setImage:closeImage forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:closeBtn];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(closeBtn.centerX, image.size.height, 0.5, closeBtn.y - image.size.height)];
        line.backgroundColor = [UIColor whiteColor];
        [_contentView addSubview:line];
        
    }
    return _contentView;
}



-(UIImageView *)imageV{
    if (!_imageV) {
        UIImage *image = [UIImage new];
        image = [UIImage imageNamed:@"addBudgetName_icon"];
        _imageV = [[UIImageView alloc]init];
        _imageV.contentMode = UIViewContentModeTop;
        _imageV.layer.cornerRadius = 6;
        _imageV.layer.masksToBounds = YES;
        _imageV.image = image;
        [_contentView addSubview:_imageV];
        _imageV.size = image.size;
        _imageV.height = image.size.height;
        _imageV.x = 0;
        _imageV.y = 0;
        _imageV.userInteractionEnabled = YES;
    }
    return _imageV;
}


-(UITextField *)nameTextField{
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc]init];
        _nameTextField.textAlignment = NSTextAlignmentCenter;
        [_nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_imageV addSubview:_nameTextField];
        [_nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(40));
            make.left.equalTo(_imageV.mas_left).offset(35);
            make.right.equalTo(_imageV.mas_right).offset(-35);
            make.bottom.equalTo(_iKnowBtn.mas_top).offset(-45);
        }];
    }
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = XWColorFromHex(0xeaeaea);
    [_nameTextField addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(1));
        make.left.right.bottom.equalTo(_nameTextField);
    }];
    
    return _nameTextField;
}

- (void)textFieldDidChange:(UITextField *)textField {
    NSInteger kMaxLength = 6;
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange offset:0];
        if (!position) {
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        } else {
        }
    } else {
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
}


-(UIButton *)iKnowBtn{
    if (!_iKnowBtn) {
        _iKnowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _iKnowBtn.backgroundColor = XWColorFromHex(0xfec00c);
        [_iKnowBtn setTitle:@"确定添加" forState:UIControlStateNormal];
        [_iKnowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_iKnowBtn addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
        [_imageV addSubview:_iKnowBtn];
        [_iKnowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_imageV);
            make.height.equalTo(@(60));
        }];
    }
    return _iKnowBtn;
    
}



@end
