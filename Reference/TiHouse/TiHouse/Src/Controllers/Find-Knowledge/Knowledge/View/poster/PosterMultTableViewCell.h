//
//  PosterMultTableViewCell.h
//  TiHouse
//
//  Created by weilai on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KnowModeInfo.h"

@interface PosterMultTableViewCell : UITableViewCell

@property (nonatomic, copy) void (^clickItemBlock)(KnowModeInfo * knowModeInfo);

- (void)refreshWithArray:(NSArray <KnowModeInfo *> *)array date:(NSString *)date;

+ (CGFloat)calculateHeight:(NSInteger)count;

@end
