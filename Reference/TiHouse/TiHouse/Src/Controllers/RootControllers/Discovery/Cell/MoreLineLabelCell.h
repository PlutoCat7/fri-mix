//
//  MoreLineLabelCell.h
//  YouSuHuoPinDot
//
//  Created by Teen Ma on 2017/11/8.
//  Copyright © 2017年 Teen Ma. All rights reserved.
//

#import "BaseTableViewCell.h"

@class MoreLineLabelViewModel;

@protocol MoreLineLabelCellDelegate;

@interface MoreLineLabelCell : BaseTableViewCell

@end

@protocol MoreLineLabelCellDelegate <NSObject>

- (void)moreLineLabelCell:(MoreLineLabelCell *)cell clickTopicStringWithViewModel:(MoreLineLabelViewModel *)viewModel;

@end
