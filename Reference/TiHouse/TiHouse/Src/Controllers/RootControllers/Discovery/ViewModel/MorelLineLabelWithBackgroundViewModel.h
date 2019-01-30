//
//  MorelLineLabelWithBackgroundViewModel.h
//  TiHouse
//
//  Created by Teen Ma on 2018/4/11.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewModel.h"

@interface MorelLineLabelWithBackgroundViewModel : BaseViewModel

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) float font;
@property (nonatomic, assign) float leftSpace;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) float rightSpace;
@property (nonatomic, assign) NSTextAlignment textAlignment; 
@property (nonatomic, assign) float  lineNumber;
@property (nonatomic, assign) float  moreLineLabelHeight;

@property (nonatomic, strong) UIColor *backgroundViewColor;
@property (nonatomic, assign) float   backgoundViewLeftRightSpace;

@end
