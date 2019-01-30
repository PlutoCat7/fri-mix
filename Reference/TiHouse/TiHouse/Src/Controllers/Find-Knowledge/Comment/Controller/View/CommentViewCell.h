//
//  CommentViewCell.h
//  TiHouse
//
//  Created by weilai on 2018/2/3.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentListResponse.h"
#import "FindAssemarcCommentInfo.h"
#import "Enums.h"

@interface CommentViewCell : UITableViewCell

@property (nonatomic, copy) void (^clickZanBlock)(id commentInfo);
@property (nonatomic, copy) void (^clickCommentBlock)(id commentInfo);

- (void)refreshWithCommentInfo:(id)commentInfo type:(CommentType)type;

+ (CGFloat)defaultHeight:(NSString *)content comment:(NSString *)comment;

@end
