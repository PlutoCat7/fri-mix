//
//  AuthorCell.h
//  TiHouse
//
//  Created by Teen Ma on 2018/4/11.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseTableViewCell.h"

@class AuthorViewModel;

@protocol AuthorCellDelegate;

@interface AuthorCell : BaseTableViewCell

@end

@protocol AuthorCellDelegate <NSObject>

- (void)authorCell:(AuthorCell *)cell clickLeftIconAndTopTitleBottomTitleWithViewModel:(AuthorViewModel *)viewModel;

- (void)authorCell:(AuthorCell *)cell clickRightButtonWithViewModel :(AuthorViewModel *)viewModel;

@end
