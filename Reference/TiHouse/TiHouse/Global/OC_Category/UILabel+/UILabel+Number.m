//
//  UILabel+Number.m
//  LoginDemo
//
//  Created by Alexcai on 15/7/15.
//  Copyright (c) 2015年 zhidier. All rights reserved.
//

#import "UILabel+Number.h"

@implementation UILabel (Number)

- (NSInteger)numberOfText{
    //创建一个label
    UILabel * label = [[UILabel alloc]init];
    //font和当前label保持一致
    label.font = self.font;
    NSString * text = self.text;
    NSInteger sum = 0;
    //总行数受换行符影响，所以这里计算总行数，需要用换行符分隔这段文字，然后计算每段文字的行数，相加即是总行数。
    NSArray * splitText = [text componentsSeparatedByString:@"\n"];
    for (NSString * sText in splitText) {
        label.text = sText;
        //获取这段文字一行需要的size
        CGSize textSize = [label systemLayoutSizeFittingSize:CGSizeZero];
        //size.width/所需要的width 向上取整就是这段文字占的行数
        NSInteger lines = ceilf(textSize.width/ [UIScreen mainScreen].bounds.size.width - 53);
        //当是0的时候，说明这是换行，需要按一行算。
        lines = lines == 0 ? 1 : lines;
        sum += lines;
    }
    return sum;

//    // 获取单行时候的内容的size
//    CGSize singleSize = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}];
//    // 获取多行时候,文字的size
//    CGSize textSize = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
//    // 返回计算的行数
//    return ceil( textSize.height / singleSize.height);
}
@end
