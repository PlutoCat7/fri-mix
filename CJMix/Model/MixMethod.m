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
        _classMethods = [aDecoder decodeObjectForKey:@"classMethods"];
        _exampleMethods = [aDecoder decodeObjectForKey:@"exampleMethods"];
        _propertyMethods = [aDecoder decodeObjectForKey:@"propertyMethods"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_classMethods forKey:@"classMethods"];
    [aCoder encodeObject:_exampleMethods forKey:@"exampleMethods"];
    [aCoder encodeObject:_propertyMethods forKey:@"propertyMethods"];
}


- (NSMutableArray <NSString *>*)classMethods {
    if (!_classMethods) {
        _classMethods = [NSMutableArray arrayWithCapacity:0];
    }
    return _classMethods;
}

- (NSMutableArray <NSString *>*)exampleMethods {
    if (!_exampleMethods) {
        _exampleMethods = [NSMutableArray arrayWithCapacity:0];
    }
    return _exampleMethods;
}

- (NSMutableArray <NSString *>*)propertyMethods {
    if (!_propertyMethods) {
        _propertyMethods = [NSMutableArray arrayWithCapacity:0];
    }
    return _propertyMethods;
}

@end
