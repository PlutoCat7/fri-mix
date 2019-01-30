//
//  ColorBigCardViewController.h
//  TiHouse
//
//  Created by weilai on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindKnowledgeBaseViewController.h"
#import "ColorCardListResponse.h"

@interface ColorBigCardViewController : FindKnowledgeBaseViewController

- (instancetype)initWithColorModeInfo:(ColorModeInfo *)colorModeInfo;
- (instancetype)initWithColorModeInfoList:(NSArray<ColorModeInfo *> *)colorList index:(NSInteger)index;

@end
