//
//  TagView.m
//  CustomTag
//
//  Created by za4tech on 2017/12/15.
//  Copyright © 2017年 Junior. All rights reserved.
//

#import "TagView.h"
#define kScreenWidth      [UIScreen mainScreen].bounds.size.width
@implementation TagView

-(void)setArr:(NSArray *)arr{
    _arr = arr;
    CGFloat marginX = 15;
    CGFloat marginY = 10;
    CGFloat height = 28;
    UIButton * markBtn;
    for (int i = 0; i < _arr.count; i++) {
        CGFloat width =  [TagView calculateString:_arr[i] Width:12] +20;
        UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (!markBtn) {
            tagBtn.frame = CGRectMake(marginX, marginY, width, height);
        }else{
            if (markBtn.frame.origin.x + markBtn.frame.size.width + marginX + width + marginX > kScreenWidth) {
                tagBtn.frame = CGRectMake(marginX, markBtn.frame.origin.y + markBtn.frame.size.height + marginY, width, height);
            }else{
                tagBtn.frame = CGRectMake(markBtn.frame.origin.x + markBtn.frame.size.width + marginX, markBtn.frame.origin.y, width, height);
            }
        }
        [tagBtn setTitle:_arr[i] forState:UIControlStateNormal];
        tagBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [tagBtn setTitleColor:[UIColor colorWithRGBHex:0x333333] forState:UIControlStateNormal];
        tagBtn.backgroundColor = [UIColor colorWithRGBHex:0xF5F5F5];
        [self makeCornerRadius:5 borderColor:[UIColor clearColor] layer:tagBtn.layer borderWidth:0];
        markBtn = tagBtn;
        
        tagBtn.enabled = YES;
        [tagBtn addTarget:self action:@selector(clickTo:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:markBtn];
    }
    CGRect rect = self.frame;
    rect.size.height = markBtn.frame.origin.y + markBtn.frame.size.height + marginY;
    self.frame = rect;
}


-(void)clickTo:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(handleSelectTag:)]) {
        [self.delegate handleSelectTag:sender.titleLabel.text];
    }
}



-(void)makeCornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor layer:(CALayer *)layer borderWidth:(CGFloat)borderWidth
{
    layer.cornerRadius = radius;
    layer.masksToBounds = YES;
    layer.borderColor = borderColor.CGColor;
    layer.borderWidth = borderWidth;
}

+(CGFloat)calculateString:(NSString *)str Width:(NSInteger)font
{
    CGSize size = [str boundingRectWithSize:CGSizeMake(kScreenWidth, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil].size;
    return size.width;
}

+ (CGFloat)calculateHeight:(NSArray *)arr {
    CGFloat marginX = 15;
    CGFloat marginY = 10;
    CGFloat height = 28;
    CGFloat allHeight = marginY;
    CGFloat allWidth = marginX;
    for (int i = 0; i < arr.count; i++) {
        CGFloat width =  [self calculateString:arr[i] Width:12] + 20;
        if (i == 0) {
            allHeight += height;
            allWidth += width;
            
        } else {
            if (allWidth + marginX + width + marginX > kScreenWidth) {
                allWidth = marginX + width;
                allHeight += marginY + height;
                
            } else {
                allWidth += marginX + width;
            }
        }
    }
    allHeight += marginY;
    
    return allHeight;
}

@end
