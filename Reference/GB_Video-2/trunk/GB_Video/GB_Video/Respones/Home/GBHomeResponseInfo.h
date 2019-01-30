//
//  GBHomeResponseInfo.h
//  GB_Video
//
//  Created by gxd on 2018/2/5.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "GBResponseInfo.h"

@interface BannerInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger bannerId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *image_url;
@property (nonatomic, copy) NSString *content_url;

@end

@interface TopicInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger topicId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *image_url;

@end

@interface HomeHeaderInfo : YAHActiveObject

@property (nonatomic, strong) NSArray<BannerInfo *> *banner_list;
@property (nonatomic, strong) NSArray<TopicInfo *> *topic_list;

@end

@interface GBHomeResponseInfo : GBResponseInfo

@property (nonatomic, strong) HomeHeaderInfo *data;

@end
