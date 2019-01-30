//
//  SoulFolderResponse.m
//  TiHouse
//
//  Created by weilai on 2018/2/5.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "SoulFolderResponse.h"

@implementation SoulFolderInfo

@end

@implementation SoulFolderAllInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"soulfolderList":[SoulFolderInfo class]};
}

@end

@implementation SoulFolderResponse

@end
