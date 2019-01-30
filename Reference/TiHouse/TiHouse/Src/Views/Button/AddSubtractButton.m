//
//  AddSubtractButton.m
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/15.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "AddSubtractButton.h"

@interface AddSubtractButton()

@property (nonatomic, retain) NSArray *titles;

@end

@implementation AddSubtractButton

-(instancetype)initWithFrame:(CGRect)frame Itemtitles:(NSArray *)titles{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = XWColorFromHex(0xfcfcfc);
        self.layer.borderColor = XWColorFromRGB(235, 235, 235).CGColor;
        self.layer.borderWidth = 0.5f;
        self.layer.cornerRadius = 6.f;
        self.layer.masksToBounds = YES;
        self.titles = titles;
        [self addSubviews];
    }
    return self;
}

-(void)addSubviews{
    
    CGFloat ItemW = self.width/_titles.count;
    
        for (int i = 0; i<_titles.count; i++) {
            //值
            UILabel *Value = [[UILabel alloc]init];
            Value.textColor = XWColorFromHex(0x333333);
            Value.text = @"1";
            Value.tag = i*3+10;
            Value.textAlignment = NSTextAlignmentCenter;
            Value.frame = CGRectMake(15 + i*ItemW, 0, 20, self.height);
            [self addSubview:Value];
            [self.Values addObject:Value.text];
            //标题
            UILabel *Title = [[UILabel alloc]init];
            Title.textColor = kTitleAddHouseTitleCOLOR;
            Title.text = _titles[i];
            Title.frame = CGRectMake(Value.right, 0, 40, self.height);
            [self addSubview:Title];
            
            //加号
            UIButton *addBtn = [[UIButton alloc]init];
            [addBtn setBackgroundImage:[UIImage imageNamed:@"Add_Icon"] forState:UIControlStateNormal];
            addBtn.frame = CGRectMake(0, 0, 25, 25);
            addBtn.centerY = self.height/2;
            addBtn.right = ItemW-10 + i*ItemW;
            addBtn.tag = i*3+12;
            [addBtn addTarget:self action:@selector(ClickAdd:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:addBtn];
            
            //减号
            UIButton *subtractBtn = [[UIButton alloc]init];
            [subtractBtn setBackgroundImage:[UIImage imageNamed:@"Suvtract"] forState:UIControlStateNormal];
            [subtractBtn setBackgroundImage:[UIImage imageNamed:@"Suvtract_end"] forState:UIControlStateDisabled];
            subtractBtn.frame = CGRectMake(0, 0, 25, 25);
            subtractBtn.centerY = self.height/2;
            subtractBtn.right = addBtn.x-5;
            subtractBtn.tag = i*3+11;
//            subtractBtn.enabled = NO;
            [subtractBtn addTarget:self action:@selector(ClickSubtract:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:subtractBtn];
            
            
            if (_titles.count>1) {
                //分割线
                UIView *Line = [[UIView alloc] initWithFrame:CGRectMake(ItemW*i, 0, 0.5f, self.height)];
                [Line setBackgroundColor:XWColorFromRGB(235, 235, 235)];
                [Line setAlpha:1];
                [self addSubview:Line];
            }
        }

    
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
}

-(void)ClickSubtract:(UIButton *)btn
{
    UIButton *addBtn = [self viewWithTag:btn.tag + 1];
    addBtn.enabled = YES;
    
    UILabel *Value = [self viewWithTag:(btn.tag - 10)/3+((btn.tag - 10)/3*2) + 10];
    if (![Value.text integerValue]) {
        return;
    }
    Value.text = [NSString stringWithFormat:@"%ld",[Value.text integerValue]-1];
    if (![Value.text integerValue]) {
        btn.enabled = NO;
    }
    [_Values setObject:Value.text atIndexedSubscript:(btn.tag - 10)/3];
    [self ValueAnimation:Value];
    if (self.AddSubtractBlock) {
        self.AddSubtractBlock(_Values,btn);
    }
}

-(void)ClickAdd:(UIButton *)btn{
    
    //将减号变成可点击
    UIButton *Subtract = [self viewWithTag:btn.tag - 1];
    Subtract.enabled = YES;
    
    UILabel *Value = [self viewWithTag:(btn.tag - 10)/3 + ((btn.tag - 10)/3)*2 + 10];
    Value.text = [NSString stringWithFormat:@"%ld",[Value.text integerValue]+1];
    [_Values setObject:Value.text atIndexedSubscript:(btn.tag - 10)/3];
    [self ValueAnimation:Value];
    if (self.AddSubtractBlock) {
        self.AddSubtractBlock(_Values,btn);
    }
    if ([Value.text intValue] == 10) {
        btn.enabled = NO;
    }
}

-(void)ValueAnimation:(UIView *)Value{
    CAKeyframeAnimation *animarion = [CAKeyframeAnimation animation];
    animarion.keyPath = @"transform.scale";
    animarion.values = @[@1.0,@0.8,@0.6,@0.4,@0.2,@0,@0.2,@0.4,@0.6,@0.8,@1];
    animarion.duration = 0.15;
    animarion.calculationMode = kCAAnimationCubic;
    [Value.layer addAnimation:animarion forKey:nil];
}

-(NSMutableArray *)Values{
    
    if (!_Values) {
        _Values = [NSMutableArray new];
    }
    return _Values;
}


-(void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
}


@end
