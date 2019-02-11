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
        _method = [aDecoder decodeObjectForKey:@"method"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_className forKey:@"className"];
    [aCoder encodeObject:_method forKey:@"method"];
}


- (instancetype)initWithClassName:(NSString *)className {
    self = [super init];
    if (self) {
        _className = className;
    }
    return self;
}

- (MixMethod *)method {
    if (!_method) {
        _method = [[MixMethod alloc] init];
    }
    return _method;
}


@end
