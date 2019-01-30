//
//  PosterMSubTableViewCell.h
//  TiHouse
//
//  Created by weilai on 2018/2/4.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KnowModeInfo.h"

@interface PosterMSubTableViewCell : UITableViewCell

@property (nonatomic, copy) void (^clickItemBlock)(KnowModeInfo * knowModeInfo);

- (void)refreshWithKnowModeInfo:(KnowModeInfo *)knowModeInfo isFontBold:(BOOL)isFontBold;

@end
