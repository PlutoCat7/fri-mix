//
//  CommentListResponse.h
//  TiHouse
//
//  Created by weilai on 2018/2/3.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "GBResponsePageInfo.h"

@interface CommentInfo : YAHActiveObject

@property (assign, nonatomic) NSInteger knowcommid;
@property (assign, nonatomic) NSInteger knowid;
@property (assign, nonatomic) NSInteger knowcommuid;
@property (assign, nonatomic) NSInteger knowcommuidon;//被评论
@property (strong, nonatomic) NSString *knowcommcontent;
@property (strong, nonatomic) NSString *knowcommname;
@property (strong, nonatomic) NSString *knowcommnameon;
@property (strong, nonatomic) NSString *knowcommurlhead;
@property (strong, nonatomic) NSString *knowcommurlheadon;
@property (strong, nonatomic) NSString *knowcommcontentsub;//被评论内容
@property (strong, nonatomic) NSString *knowcontent;
@property (strong, nonatomic) NSString *knowurlindex;
@property (strong, nonatomic) NSString *knowcontentdown;
@property (assign, nonatomic) long knowcommctime;
@property (assign, nonatomic) NSInteger knowcommzan;
@property (assign, nonatomic) BOOL knowcommiszan;

@end

@interface CommentListResponse : GBResponsePageInfo

@property (nonatomic, strong) NSArray<CommentInfo *> *data;

@end
