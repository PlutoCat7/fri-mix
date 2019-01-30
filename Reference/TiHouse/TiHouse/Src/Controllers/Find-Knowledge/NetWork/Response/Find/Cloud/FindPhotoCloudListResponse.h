//
//  FindPhotoCloudListResponse.h
//  TiHouse
//
//  Created by yahua on 2018/2/5.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "GBResponsePageInfo.h"
#import "FindPhotoCloudInfo.h"

@interface FindPhotoCloudListResponse : GBResponsePageInfo

@property (nonatomic, strong) NSArray<FindPhotoCloudInfo *> *data;

@end
