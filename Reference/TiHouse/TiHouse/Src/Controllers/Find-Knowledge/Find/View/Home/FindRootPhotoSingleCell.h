//
//  FindRootPhotoSingleCell.h
//  TiHouse
//
//  Created by yahua on 2018/2/5.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindRootCellProtocol.h"

@class FindAssemarcInfo;
@interface FindRootPhotoSingleCell : UITableViewCell

@property (nonatomic, weak) id<FindRootCellDelegate> delegate;
@property (nonatomic, copy) void(^needRefreshView)(void);

- (CGFloat)getHeightWithArcInfo:(FindAssemarcInfo *)info;

- (void)refreshWithInfo:(FindAssemarcInfo *)info;

@end
