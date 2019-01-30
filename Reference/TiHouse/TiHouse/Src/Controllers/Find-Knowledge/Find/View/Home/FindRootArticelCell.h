//
//  FindRootArticelCell.h
//  TiHouse
//
//  Created by yahua on 2018/2/5.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindRootCellProtocol.h"

@class FindAssemarcInfo;
@interface FindRootArticelCell : UITableViewCell

@property (nonatomic, weak) id<FindRootCellDelegate> delegate;

- (void)refreshWithInfo:(FindAssemarcInfo *)info;

- (CGFloat)getHeightWithSubTitle:(NSString *)subTitle;

@end
