//
//  PalyerDetailCommentCell.h
//  GB_Video
//
//  Created by yahua on 2018/1/24.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlayerDetailCommentCellModel;


@interface PalyerDetailCommentCell : UITableViewCell

- (void)refreshWithModel:(PlayerDetailCommentCellModel *)model;

@end
