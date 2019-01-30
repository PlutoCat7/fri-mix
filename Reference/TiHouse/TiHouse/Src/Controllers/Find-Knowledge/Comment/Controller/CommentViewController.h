//
//  CommentViewController.h
//  TiHouse
//
//  Created by weilai on 2018/2/3.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindKnowledgeBaseViewController.h"
#import "CommentViewCell.h"

@interface CommentViewController : FindKnowledgeBaseViewController

- (instancetype)initWithCommentId:(NSInteger)knowledgeId commId:(NSInteger)commId commuid:(NSInteger)commuid comuname:(NSString *)comuname type:(CommentType)type;

@end
