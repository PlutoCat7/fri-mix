//
//  FileNameModifyJsonInfo.m
//  najiabao-file
//
//  Created by wangshiwen on 2019/1/24.
//  Copyright © 2019 yahua. All rights reserved.
//

#import "MixFileNameModifyJsonInfo.h"
#import <objc/runtime.h>

@implementation MixSingleModifyJsonInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        _insert = [NSMutableDictionary dictionaryWithCapacity:1];
        _remove = [NSMutableDictionary dictionaryWithCapacity:1];
        _modify = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    return self;
}

@end

@implementation MixFileNameModifyJsonInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        _version = 1;
        _forward  = [[MixSingleModifyJsonInfo alloc] init];
        _backward  = [[MixSingleModifyJsonInfo alloc] init];
    }
    return self;
}

- (NSString *)jsonString {
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[MixFileNameModifyJsonInfo getObjectData:self] options:kNilOptions error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}

+ (NSDictionary*)getObjectData:(id)obj {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    for(int i = 0;i < propsCount; i++) {
        objc_property_t prop = props[i];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [obj valueForKey:propName];
        if(value == nil) {
            value = [NSNull null];
        }
        else {
            value = [self getObjectInternal:value];
        }
        [dic setObject:value forKey:propName];
    }
    return dic;
}

+ (id)getObjectInternal:(id)obj {
    if([obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]]) {
        return obj;
    }
    
    if([obj isKindOfClass:[NSArray class]]) {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++) {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    
    if([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys) {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self getObjectData:obj];
}

@end
