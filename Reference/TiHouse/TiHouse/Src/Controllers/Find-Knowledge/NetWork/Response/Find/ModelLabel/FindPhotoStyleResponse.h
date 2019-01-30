//
//  FindPhotoStyleResponse.h
//  TiHouse
//
//  Created by yahua on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//  风格

#import "GBResponseInfo.h"

@interface FindPhotoStyleInfo :YAHActiveObject

@property (nonatomic, assign) long styleid;
@property (nonatomic, copy) NSString *stylename;

@end

@interface FindPhotoStyleResponse : GBResponseInfo

@property (nonatomic, strong) NSArray<FindPhotoStyleInfo *> *data;

@end
