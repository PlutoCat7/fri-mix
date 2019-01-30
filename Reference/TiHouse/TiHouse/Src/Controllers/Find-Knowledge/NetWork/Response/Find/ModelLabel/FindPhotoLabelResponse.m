//
//  FindModelLabelResponse.m
//  TiHouse
//
//  Created by yahua on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindPhotoLabelResponse.h"

@implementation FindPhotoLabelInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"labelId":@"lableid",
             @"labelName":@"lablename"
             };
}

@end

@implementation FindPhotoLabelResponse

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"data":[FindPhotoLabelInfo class]};
}

@end
