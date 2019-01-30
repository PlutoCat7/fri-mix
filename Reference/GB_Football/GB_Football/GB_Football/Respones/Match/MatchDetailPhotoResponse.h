//
//  MatchDetailPhotoResponse.h
//  GB_Football
//
//  Created by yahua on 2017/12/15.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"

@interface MatchDetailPhotoInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, strong) NSArray<NSString *> *img;
@property (nonatomic, strong) NSArray<NSString *> *video;

@end

@interface MatchDetailPhotoResponse : GBResponseInfo

@property (nonatomic, strong) NSArray<MatchDetailPhotoInfo *> *data;

@end
