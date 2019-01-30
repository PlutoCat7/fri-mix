//
//  FindModelThingResponse.h
//  TiHouse
//
//  Created by yahua on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
// 物品

#import "GBResponseInfo.h"

@interface FindPhotoThingInfo :YAHActiveObject

@property (nonatomic, assign) long thingid;
@property (nonatomic, copy) NSString *thingname;
@property (nonatomic, assign) long brandid;
@property (nonatomic, copy) NSString *allname;

//本地属性
@property (nonatomic, copy) NSString *thingbrand;  //
@property (nonatomic, copy) NSString *thingprice;

@end

@interface FindPhotoThingResponse : GBResponseInfo

@property (nonatomic, strong) NSArray<FindPhotoThingInfo *> *data;

@end
