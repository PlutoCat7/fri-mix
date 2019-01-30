//
//  CollectedArticleBottomCell.h
//  TiHouse
//
//  Created by Teen Ma on 2018/4/24.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseTableViewCell.h"

@protocol CollectedArticleBottomCellDelegate;

@class CollectedArticleBottomViewModel;

@interface CollectedArticleBottomCell : BaseTableViewCell

@end

@protocol CollectedArticleBottomCellDelegate <NSObject>

- (void)collectedArticleBottomCell:(CollectedArticleBottomCell *)cell clickRightButtonWithViewModel:(CollectedArticleBottomViewModel *)viewModel;

@end
