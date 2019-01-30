//
//  MineFindMainContentCell.h
//  TiHouse
//
//  Created by admin on 2018/2/3.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "MineFindMainContentCell.h"
#import "CommonTableViewCell.h"
@class FindAssemarcInfo;
@class MineFindMainContentCell;
@protocol MineFindMainContentCellDelegate<NSObject>
@optional
- (void)mineFindCellShare:(MineFindMainContentCell *)cell;
- (void)mineFineCellSingleImage:(MineFindMainContentCell *)cell imageIndex:(NSInteger)index;
- (void)mineFindCellComment:(MineFindMainContentCell *)cell;
- (void)mineFindCellStar:(MineFindMainContentCell *)cell;
@end
@interface MineFindMainContentCell : CommonTableViewCell
@property (nonatomic, strong) FindAssemarcInfo *model;
@property (nonatomic, assign) id<MineFindMainContentCellDelegate> delegate;
@end

