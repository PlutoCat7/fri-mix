//
//  SHValue.h
//  SHValue
//
//  Created by Charles Zou on 2018/1/29.
//  Copyright © 2018年 Charles Zou. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SHValue;

FOUNDATION_EXPORT SHValue *SHVALUE(id object);


@interface SHValue<__covariant T> : NSObject

+ (nonnull instancetype)value:(nullable id)object;

@property (strong, nonatomic, nullable) T value;

// Optional
@property (strong, nonatomic, nullable) NSArray<id> *array;

// Non-optional
@property (strong, nonatomic, nonnull) NSArray<id> *arrayValue;


@property (strong, nonatomic, nullable) NSDictionary<NSString *, id> *dictionary;

@property (strong, nonatomic, nonnull) NSDictionary<NSString *, id> *dictionaryValue;


// Optional string
@property (strong, nonatomic, nullable) NSString *string;

// Non-optional string
@property (strong, nonatomic, nonnull) NSString *stringValue;

@property (strong, nonatomic, nullable) NSNumber *number;

@property (strong, nonatomic, nonnull) NSNumber *numberValue;

@property (assign, nonatomic) int intValue;

@property (assign, nonatomic) double doubleValue;

@property (assign, nonatomic) float floatValue;

@property (assign, nonatomic) BOOL boolValue;


- (nonnull instancetype)objectAtIndexedSubscript:(NSUInteger)idx;
- (void)setObject:(nonnull id)obj atIndexedSubscript:(NSUInteger)idx;
- (nonnull instancetype)objectForKeyedSubscript:(nonnull id <NSCopying>)key;
- (void)setObject:(nonnull id)obj forKeyedSubscript:(nonnull id <NSCopying>)key;


@end
