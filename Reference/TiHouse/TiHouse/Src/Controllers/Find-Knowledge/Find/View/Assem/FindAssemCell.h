//
//  FindAssemCell.h
//  TiHouse
//
//  Created by yahua on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssemCellModel.h"

#define kFindAssemCellHeight kRKBWIDTH(315)

@class FindAssemCell;
@protocol FindAssemCellDelegate <NSObject>

@optional
- (void)findAssemCellDidSelected:(FindAssemCell *)cell;

@end

@interface FindAssemCell : UITableViewCell

@property (nonatomic, weak) id<FindAssemCellDelegate> delegate;

- (void)refreshWithInfo:(AssemCellModel *)info;

@end
