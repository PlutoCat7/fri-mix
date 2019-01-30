//
//  ColorCardCollectionViewCell.h
//  TiHouse
//
//  Created by weilai on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorCardListResponse.h"

#define kColorCardCollectionViewCellWidth kRKBWIDTH(160)
#define kColorCardCollectionViewCellHeight kRKBWIDTH(210)

@interface ColorCardCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) void (^clickBlock)(ColorModeInfo * colorModelInfo);

- (void)refreshWithColorModeInfo:(ColorModeInfo *)colorModeInfo;
- (void)refreshWithColorModeInfo:(ColorModeInfo *)colorModeInfo big:(BOOL)big;

@end
