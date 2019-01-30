//
//  FindModelThingResponse.m
//  TiHouse
//
//  Created by yahua on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindPhotoThingResponse.h"

@implementation FindPhotoThingInfo

@end

@implementation FindPhotoThingResponse

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"data":[FindPhotoThingInfo class]};
}

@end
