//
//  SearchHistoryCell.h
//  TiHouse
//
//  Created by weilai on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KnowLabelResponse.h"

@interface SearchHistoryCell : UITableViewCell

@property (nonatomic, copy) void (^clickItemDel)(KnowLabelInfo * knowLabelInfo);

- (void)refreshWithKnowLabelInfo:(KnowLabelInfo *)knowLabelInfo;

@end
