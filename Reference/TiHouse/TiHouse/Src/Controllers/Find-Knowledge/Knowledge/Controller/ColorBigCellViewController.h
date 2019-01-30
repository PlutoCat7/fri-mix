//
//  ColorBigCellViewController.h
//  TiHouse
//
//  Created by weilai on 2018/5/6.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindKnowledgeBaseViewController.h"
#import "ColorCardListResponse.h"

@interface ColorBigCellViewController : FindKnowledgeBaseViewController


@property (nonatomic, copy) void (^clickBlock)(ColorModeInfo * colorModelInfo);

- (void)refreshWithColorModeInfo:(ColorModeInfo *)colorModeInfo;
- (void)refreshWithColorModeInfo:(ColorModeInfo *)colorModeInfo big:(BOOL)big;

@end
