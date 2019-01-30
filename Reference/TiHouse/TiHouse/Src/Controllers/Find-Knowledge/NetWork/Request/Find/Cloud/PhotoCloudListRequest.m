//
//  PhotoCloudListRequest.m
//  TiHouse
//
//  Created by yahua on 2018/2/5.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "PhotoCloudListRequest.h"

@implementation PhotoCloudListRequest

- (Class)responseClass {
    
    return [FindPhotoCloudListResponse class];
}

- (NSString *)requestAction {
    
    return @"api/inter/file/pageByUid";
}

@end
