//
//  FindModelLabelResponse.h
//  TiHouse
//
//  Created by yahua on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
// 标签

#import "GBResponseInfo.h"

@interface FindPhotoLabelInfo :YAHActiveObject

@property (nonatomic, assign) long labelId;
@property (nonatomic, copy) NSString *labelName;

@end

@interface FindPhotoLabelResponse : GBResponseInfo

@property (nonatomic, strong) NSArray<FindPhotoLabelInfo *> *data;

@end
