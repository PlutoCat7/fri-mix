//
//  HomeTableViewCell.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/5.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeResponseInfo.h"

@class HomeTableViewCell;

@protocol HomeTableViewCellDelegate <NSObject>

- (void)didClickCell:(HomeTableViewCell *)cell index:(NSInteger)index;

@end

@interface HomeTableViewCell : UITableViewCell

@property (nonatomic, weak) id<HomeTableViewCellDelegate> delegate;

- (void)refreshWithData:(NSArray<HomeGoodsInfo *> *)goods;

@end
