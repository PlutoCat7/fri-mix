//
//  PosterSingleViewCell.h
//  TiHouse
//
//  Created by weilai on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KnowModeInfo.h"

@interface PosterSingleViewCell : UITableViewCell

@property (nonatomic, copy) void (^clickItemBlock)(KnowModeInfo * knowModeInfo);

- (void)refreshWithKnowModeInfo:(KnowModeInfo *)knowModeInfo date:(NSString *)date;

+ (CGFloat)calculateHeight:(NSString *)content;

@end
