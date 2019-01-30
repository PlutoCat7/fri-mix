//
//  ProgressPacketProfile.m
//  GB_BlueSDK
//
//  Created by gxd on 16/12/22.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "ProgressPacketProfile.h"


@implementation ProgressPacketProfile

- (void)executeProgressProfile:(ResultServiceBlock)serviceBlock progressBlock:(ResultProgressBlock)progressBlock {
    self.progressBlock = progressBlock;
    
    [self executeProfile:serviceBlock];
}

- (BOOL)isEqualProfile:(id)object {
    if (![object isMemberOfClass:[self class]]) {
        return NO;
    }
    return YES;
}

@end
