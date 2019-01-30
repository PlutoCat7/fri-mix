//
//  PointsCell.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/18.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PointsCellModel;

#define kPointsCellHeight (75*kAppScale)

@interface PointsCell : UITableViewCell

- (void)refreshWithModel:(PointsCellModel *)model;

@end
