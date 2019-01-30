//
//  FindDraftCell.h
//  TiHouse
//
//  Created by yahua on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kFindDraftCellHeight kRKBWIDTH(255)

@class FindDraftCellModel;
@interface FindDraftCell : UITableViewCell

- (void)refreshWithModel:(FindDraftCellModel *)model;

@end
