//
//  MixObjectStrategy.m
//  Mix
//
//  Created by ChenJie on 2019/1/21.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import "MixObjectStrategy.h"

@implementation MixObjectStrategy

+ (NSArray <MixObject*>*)fileToObject:(NSArray <MixClassFile *>*)classFiles {
    NSMutableArray <MixObject*>* objects = [NSMutableArray arrayWithCapacity:0];
    
    [classFiles enumerateObjectsUsingBlock:^(MixClassFile * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MixObject * object = [[MixObject alloc] initWithClassFile:obj];
        [objects addObject:object];
    }];
    
    return objects;
}

@end
