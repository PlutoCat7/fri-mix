//
//  MineOptionCell.h
//  TiHouse
//
//  Created by Teen Ma on 2018/4/23.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseTableViewCell.h"

@protocol MineOptionCellDelegate;

@class MineOptionDetailViewModel;
@class MineOptionViewModel;

@interface MineOptionCell : BaseTableViewCell

@end

@protocol MineOptionCellDelegate <NSObject>

- (void)mineOptionCell:(MineOptionCell *)cell clickDetailViewWithViewModel:(MineOptionDetailViewModel *)viewModel;

@end
