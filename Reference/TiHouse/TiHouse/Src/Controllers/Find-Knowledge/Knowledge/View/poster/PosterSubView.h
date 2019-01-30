//
//  PosterSubView.h
//  TiHouse
//
//  Created by weilai on 2018/2/3.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KnowModeInfo.h"

@interface PosterSubView : UIView

@property (nonatomic, copy) void (^clickItemBlock)(KnowModeInfo * knowModeInfo);

- (void)refreshWithKnowModeInfo:(KnowModeInfo *)knowModeInfo;

@end
