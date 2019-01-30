//
//  PlayerDetailCommentCellModel.m
//  GB_Video
//
//  Created by yahua on 2018/1/24.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "PlayerDetailCommentCellModel.h"

@implementation PlayerDetailCommentCellModel

- (void)setCommentString:(NSString *)commentString {
    
    _commentString = commentString;
    //计算高度
    CGFloat topHeight = 60*kAppScale;
    CGFloat bottomHeight = 12*kAppScale;
    CGFloat contentHeight = [commentString sizeWithFont:[UIFont autoFontOfSize:15*kAppScale] constrainedToWidth:290*kAppScale].height;
    CGFloat totalHeight = contentHeight + topHeight + bottomHeight;
    if (totalHeight < (110*kAppScale)) {
        totalHeight = 110*kAppScale;
    }
    self.cellHeight = totalHeight;
}

@end
