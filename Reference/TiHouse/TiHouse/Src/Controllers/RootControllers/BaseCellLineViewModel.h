//
//  BaseCellLineViewModel.h
//  MTTemplate
//
//  Created by Teen Ma on 16/11/10.
//  Copyright © 2016年 Teen Ma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseCellLineViewModel : NSObject

@property (nonatomic, assign, getter = isShowTopLine   ) BOOL showTopLine;
@property (nonatomic, assign, getter = isShowBottomLine) BOOL showBottomLine;
@property (nonatomic, assign) UIEdgeInsets topLineEdgeInsets;
@property (nonatomic, assign) UIEdgeInsets bottomLineEdgeInsets;
@property (nonatomic, strong  ) UIColor *topLineColor;
@property (nonatomic, strong  ) UIColor *bottomLineColor;
@property (nonatomic, assign  ) CGFloat topLineHeight;
@property (nonatomic, assign  ) CGFloat bottomLineHeight;

@end
