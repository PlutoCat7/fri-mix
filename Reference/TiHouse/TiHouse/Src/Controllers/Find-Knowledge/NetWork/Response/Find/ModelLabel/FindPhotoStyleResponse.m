//
//  FindPhotoStyleResponse.m
//  TiHouse
//
//  Created by yahua on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindPhotoStyleResponse.h"

@implementation FindPhotoStyleInfo

@end

@implementation FindPhotoStyleResponse

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"data":[FindPhotoStyleInfo class]};
}

@end
