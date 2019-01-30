//
//  FindPhotoCloudListResponse.m
//  TiHouse
//
//  Created by yahua on 2018/2/5.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindPhotoCloudListResponse.h"

@implementation FindPhotoCloudListResponse

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"data":[FindPhotoCloudInfo class]};
}

- (NSArray *)onePageData {
    
    return self.data;
}

@end
