//
//  VideoCommentListResponse.h
//  GB_Video
//
//  Created by yahua on 2018/2/2.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "GBResponsePageInfo.h"

@interface VideoCommentInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger commentId;
@property (nonatomic, assign) NSInteger parent_id;
@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) long create_time;
@property (nonatomic, assign) long update_time;
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *image_url;

@end

@interface VideoCommentListResponse : GBResponsePageInfo

@property (nonatomic, strong) NSArray<VideoCommentInfo *> *data;


@end
