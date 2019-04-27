//
//  MixClass.m
//  Mix
//
//  Created by ChenJie on 2019/1/21.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import "MixClass.h"
#import "../Strategy/MixStringStrategy.h"
#import "../Strategy/MixMethodStrategy.h"

@implementation MixClass

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _className = [aDecoder decodeObjectForKey:@"className"];
        _methods = [aDecoder decodeObjectForKey:@"methods"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_className forKey:@"className"];
    [aCoder encodeObject:_methods forKey:@"methods"];
}


- (instancetype)initWithClassName:(NSString *)className {
    self = [super init];
    if (self) {
        _className = className;
    }
    return self;
}

- (NSMutableArray <MixMethod *>*)methods {
    if (!_methods) {
        _methods = [NSMutableArray arrayWithCapacity:0];
    }
    return _methods;
}


@end
