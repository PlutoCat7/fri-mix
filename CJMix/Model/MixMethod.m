//
//  MixMethod.m
//  Mix
//
//  Created by ChenJie on 2019/1/20.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import "MixMethod.h"

@implementation MixMethod

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _methodName = [aDecoder decodeObjectForKey:@"methodName"];
        _methodType = [aDecoder decodeIntegerForKey:@"methodType"];
        _isReadonly = [aDecoder decodeBoolForKey:@"isReadonly"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_methodName forKey:@"methodName"];
    [aCoder encodeInteger:_methodType forKey:@"methodType"];
    [aCoder encodeBool:_isReadonly forKey:@"isReadonly"];
}





@end
