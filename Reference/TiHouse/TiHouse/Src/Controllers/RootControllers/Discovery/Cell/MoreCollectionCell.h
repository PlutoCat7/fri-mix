//
//  MoreCollectionCell.h
//  TiHouse
//
//  Created by Teen Ma on 2018/4/11.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseTableViewCell.h"

@protocol MoreCollectionCellDelegate;

@class CollectionDetailViewModel;

@interface MoreCollectionCell : BaseTableViewCell


@end

@protocol MoreCollectionCellDelegate <NSObject>

- (void)moreCollectionCell:(MoreCollectionCell *)cell clickCollectionViewWithViewModel:(CollectionDetailViewModel *)viewModel;

@end
