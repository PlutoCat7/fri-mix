//
//  KnowLabelResponse.m
//  TiHouse
//
//  Created by weilai on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "KnowLabelResponse.h"

@implementation KnowLabelInfo

@end

@implementation KnowLabelResponse

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"data":[KnowLabelInfo class]};
}

@end
