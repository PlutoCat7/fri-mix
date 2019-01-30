//
//  YAHActiveObject.m
//  YAHModel
//
//  Created by yahua on 16/4/5.
//  Copyright © 2016年 wangsw. All rights reserved.
//

#import "YAHActiveObject.h"
#import <objc/runtime.h>
#import "YAHJSONAdapter.h"

static void *YHModelCachedPropertyKeysKey = &YHModelCachedPropertyKeysKey;

@interface YAHActiveObject () <
YAHJSONSerializing>

@end

@implementation YAHActiveObject

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        NSArray *propertyNames = [[self class] p_propertyKeys].allObjects;
        for (NSString *propertyName in propertyNames) {
            [self setValue:[coder decodeObjectForKey:propertyName] forKey:propertyName];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    NSArray *propertyNames = [[self class] p_propertyKeys].allObjects;
    for (NSString *propertyName in propertyNames) {
        id propertyValue = [self valueForKey:propertyName];
        [aCoder encodeObject:propertyValue forKey:propertyName];
    }
}

#pragma mark - NSCoping

- (id)copyWithZone:(NSZone *)zone {
    
    YAHActiveObject *result = [[[self class] allocWithZone:zone] init];
    
    NSArray *propertyNames = [[self class] p_propertyKeys].allObjects;
    for (NSString *propertyName in propertyNames) {
        id propertyValue = [self valueForKey:propertyName];
        if ([propertyValue respondsToSelector:@selector(copyWithZone:)]) {
            propertyValue = [propertyValue copyWithZone:zone];
        }
        [result setValue:propertyValue forKey:propertyName];
    }
    return result;
}

#pragma mark - Public

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return nil;
}

+ (NSDictionary *)bridgeClassAndArray {
    
    return nil;
}

#pragma mark - YHJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    NSArray *propertyKeys = [[self class] p_propertyKeys].allObjects;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjects:propertyKeys forKeys:propertyKeys];
    NSDictionary *changeJSONKey = [self bridgePropertyAndJSON];
    if (changeJSONKey) {
        [dic setValuesForKeysWithDictionary:changeJSONKey];
    }
    return dic;
}

+ (NSDictionary *)convertClassStringDictionary {
    
    return [self bridgeClassAndArray];
}

#pragma mark - Private

+ (NSSet *)p_propertyKeys {
    
    NSSet *cachedKeys = objc_getAssociatedObject(self, YHModelCachedPropertyKeysKey);
    if (cachedKeys != nil) return cachedKeys;
    
    NSMutableSet *keys = [NSMutableSet set];
    unsigned int propertyCount = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &propertyCount);
    for (int i=0; i<propertyCount; i++) {
        objc_property_t *property = propertyList + i;
        NSString *propertyName = [NSString stringWithCString:property_getName(*property) encoding:NSUTF8StringEncoding];
        [keys addObject:propertyName];
    }
    free(propertyList);
    objc_setAssociatedObject(self, YHModelCachedPropertyKeysKey, keys, OBJC_ASSOCIATION_COPY);
    
    return keys;
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"<%@: %p> %@", self.class, self, [YAHJSONAdapter jsonStringFromObject:self]];
}

@end
