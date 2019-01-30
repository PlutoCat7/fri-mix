//
//  RemarksView.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "RemarksView.h"
#import "BudgetThreeClass.h"

@interface RemarksView()

@property (nonatomic, retain) UILabel *titleView;

@end

@implementation RemarksView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self titleView];
        [self TextView];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-0.5, self.width, 0.5)];
        line.backgroundColor = kLineColer;
        [self addSubview:line];
    }
    return self;
}

-(void)setThreeClass:(BudgetThreeClass *)threeClass{
    _threeClass = threeClass;
    if (threeClass.proremark.length) {
        _TextView.text = threeClass.proremark;
    }
    
}


//-(UITextField *)TextView{
//    if (!_TextView) {
//        _TextView = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_titleView.frame)+10, 0, self.width-CGRectGetMaxX(_titleView.frame)-20, self.height)];
//        _TextView.placeholder = @"您可以在此记录品牌型号等信息";
//        _TextView.font = [UIFont systemFontOfSize:15];
//        [self addSubview:_TextView];
//    }
//    return _TextView;
//}


-(UILabel *)titleView{
    if (!_titleView) {
        _titleView = [[UILabel alloc]init];
        _titleView.text = @"备注";
        _titleView.textAlignment = NSTextAlignmentCenter;
        _titleView.font = [UIFont systemFontOfSize:16];
        [_titleView sizeToFit];
        _titleView.frame = CGRectMake(0, 15, 55, _titleView.size.height);
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(_titleView.width, 0, 0.5, self.height)];
        line.backgroundColor = kLineColer;
        [self addSubview:line];
        [self addSubview:_titleView];
    }
    return _titleView;
}


//-(UITextView *)TextView{
//    if (!_TextView) {
////        _TextView = [[UITextView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_titleView.frame)+10, 7, self.width-CGRectGetMaxX(_titleView.frame)-20, self.height-30)];
//        _TextView = [[UITextView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_titleView.frame)+10, 7, self.width-CGRectGetMaxX(_titleView.frame)-20, self.height - 14)];
//        _TextView.delegate = self;
//        _TextView.text = @"您可以在此记录品牌型号等信息";
//        _TextView.font = [UIFont systemFontOfSize:15];
////        _TextView.textColor = kRKBNOTELABELCOLOR;
//        [self addSubview:_TextView];
//    }
//    return _TextView;
//}

-(IQTextView *)TextView{
    if (!_TextView) {
//        _TextView = [[UITextView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_titleView.frame)+10, 7, self.width-CGRectGetMaxX(_titleView.frame)-20, self.height-30)];
        _TextView = [[IQTextView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_titleView.frame)+10, 7, self.width-CGRectGetMaxX(_titleView.frame)-20, self.height - 14)];
//        _TextView.delegate = self;
//        _TextView.text = @"您可以在此记录品牌型号等信息";
        _TextView.placeholder = @"您可以在此记录品牌型号等信息";
        _TextView.font = [UIFont systemFontOfSize:15];
//        _TextView.textColor = kRKBNOTELABELCOLOR;
        [self addSubview:_TextView];
    }
    return _TextView;
}


//#pragma mark - UITextFieldDelegate
//-(void)textViewDidBeginEditing:(UITextView *)textView
//{
//    if ([textView.text isEqualToString:@"您可以在此记录品牌型号等信息"]) {
//        textView.text = @"";
//        textView.textColor = kRKBHomeBlackColor;
//    }
//}
//
//-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
//
//    return YES;
//}
//
//-(void)textViewDidChange:(UITextView *)textView{
//    textView.textColor = [UIColor blackColor];
//}
//
//#pragma mark - UITextFieldDelegate
//-(void)textViewDidEndEditing:(UITextView *)textView
//{
//
//    if ([textView.text isEqualToString:@""]) {
//        textView.text = @"您可以在此记录品牌型号信息等信息";
//        textView.textColor = kRKBNOTELABELCOLOR;
//    }
//}
//
//-(void)setContent:(NSString *)content{
//    _TextView.text = content;
//    if (![content isEqualToString:@"您可以在此记录品牌型号信息等信息"]) {
//        _TextView.textColor = [UIColor blackColor];
//    }
//}



@end
