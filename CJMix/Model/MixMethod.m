//
//  MixMethod.m
//  Mix
//
//  Created by ChenJie on 2019/1/20.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import "MixMethod.h"

@implementation MixMethod

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

@end
