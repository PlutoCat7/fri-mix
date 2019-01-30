//
//  MoreLineLabelViewModel.h
//  YouSuHuoPinDot
//
//  Created by Teen Ma on 2017/11/8.
//  Copyright © 2017年 Teen Ma. All rights reserved.
//

#import "BaseViewModel.h"

@interface MoreLineLabelViewModel : BaseViewModel

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) float font;
@property (nonatomic, assign) float leftSpace;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) float rightSpace;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, assign) BOOL   canCopy;
@property (nonatomic, assign) float  lineNumber;

@property (nonatomic, copy  ) NSString *topicString;//话题

@end
