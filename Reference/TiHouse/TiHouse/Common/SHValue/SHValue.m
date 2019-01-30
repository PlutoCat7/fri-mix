//
//  SHValue.m
//  SHValue
//
//  Created by Charles Zou on 2018/1/29.
//  Copyright © 2018年 Charles Zou. All rights reserved.
//

#import "SHValue.h"

SHValue *SHVALUE(id object) {
    return [SHValue value: object];
}


@interface SHValue()

@end

@implementation SHValue


// MARK: - init
+ (instancetype)value:(id)object {
    SHValue *shValue = [[SHValue alloc] init];
    shValue.value = object;
    return shValue;
}

// MARK: - Subscript
- (instancetype)objectAtIndexedSubscript:(NSUInteger)idx {
    if ([self.value isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)self.value;
        if ((int)idx >= 0 && idx < array.count) {
            return [SHValue value:array[idx]];
        }
    }
    return [SHValue new];
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {}

- (instancetype)objectForKeyedSubscript:(id <NSCopying>)key {
    
    if ([self.value isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = self.value;
        return [SHValue value:dict[key]];
    }
    return [SHValue new];
}

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key {}


// MARK: - Array
- (NSArray<id> *)array {
    if ([self.value isKindOfClass:[NSArray class]]) {
        
        //        NSArray *array = [self.value copy];
        //        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //            obj = [SHValue value:obj];
        //        }];
        //        return array;
        return self.value;
    }
    return nil;
}

- (NSArray<id> *)arrayValue {
    
    NSArray<id> *array = [self array];
    return array ? : @[];
}


// MARK: - Dictionary
- (NSDictionary<NSString *, id> *)dictionary {
    //    if ([self.value isKindOfClass:[NSDictionary<NSString *, SHValue *> class]]) {
    //        NSDictionary *dictionary = [self.value copy];
    //        [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
    //            obj = [SHValue value:obj];
    //        }];
    //        return dictionary;
    //    }
    if ([self.value isKindOfClass:[NSDictionary<NSString *, id> class]]) {
        return self.value;
    }
    return nil;
}

- (NSDictionary<NSString *, id> *)dictionaryValue {
    
    NSDictionary<NSString *, id> *dictionary = [self dictionary];
    return dictionary ? : @{};
}


// MARK: - String

- (NSString *)string {
    if ([self.value isKindOfClass:[NSString class]]) {
        return self.value;
    }
    return nil;
}

- (NSString *)stringValue {
    if ([self.value isKindOfClass:[NSString class]]) {
        return self.value;
    }
    return @"";
}

// MARK: - Number

- (NSNumber *)number {
    if ([self.value isKindOfClass:[NSNumber class]]) {
        return self.value;
    }
    return nil;
}

- (NSNumber *)numberValue {
    if ([self.value isKindOfClass:[NSNumber class]]) {
        return self.value;
    }
    return @(0);
}

// MARK: - int double float
- (int)intValue {
    if ([self.value isKindOfClass:[NSNumber class]]) {
        return [self.value intValue];
    } else if ([self.value isKindOfClass:[NSString class]]) {
        NSScanner* scan = [NSScanner scannerWithString:self.value];
        int val;
        if ([scan scanInt:&val] && [scan isAtEnd]) {
            return [self.value intValue];
        }
    }
    return 0;
}

- (double)doubleValue {
    if ([self.value isKindOfClass:[NSNumber class]]) {
        return [self.value doubleValue];
    } else if ([self.value isKindOfClass:[NSString class]]) {
        NSScanner* scan = [NSScanner scannerWithString:self.value];
        double val;
        if ([scan scanDouble:&val] && [scan isAtEnd]) {
            return [self.value doubleValue];
        }
    }
    return 0;
}

- (float)floatValue {
    if ([self.value isKindOfClass:[NSNumber class]]) {
        return [self.value floatValue];
    } else if ([self.value isKindOfClass:[NSString class]]) {
        NSScanner* scan = [NSScanner scannerWithString:self.value];
        float val;
        if ([scan scanFloat:&val] && [scan isAtEnd]) {
            return [self.value floatValue];
        }
    }
    return 0;
}

- (BOOL)boolValue {
    if ([self.value isKindOfClass:[NSNumber class]]) {
        return [self.value boolValue];
    } else if ([self.value isKindOfClass:[NSString class]]) {
        NSScanner* scan = [NSScanner scannerWithString:self.value];
        int val;
        if ([scan scanInt:&val] && [scan isAtEnd]) {
            return [self.value intValue] != 0;
        }
    }
    return NO;
}

@end
