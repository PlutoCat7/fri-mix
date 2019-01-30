//
//  TacticsListCell.h
//  GB_Football
//
//  Created by yahua on 2018/1/12.
//  Copyright © 2018年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TacticsListCellModel;

@interface TacticsListCell : UITableViewCell

- (void)refreshWithModel:(TacticsListCellModel *)cellModel;

@end
