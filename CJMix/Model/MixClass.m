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

- (void)methodFromData:(NSString *)data {
    if (!self.className) {
        return;
    }
    
    NSString * newData = [MixStringStrategy filterOutImpurities:data];
    
    if (![newData hasPrefix:self.className] || ![newData hasSuffix:@"@end"]) {
        return;
    }
    
    NSArray <NSString *>* addMethodData = [newData componentsSeparatedByString:@"+"];
    NSArray <NSString *>* subMethodData = [newData componentsSeparatedByString:@"-"];
    
    [addMethodData enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != 0) {
            NSString * group = [NSString stringWithFormat:@"+%@",obj];
            NSString * method = [MixMethodStrategy methodFromData:group];
            if (method && ![self.method.classMethods containsObject:method]) {
                [self.method.classMethods addObject:method];
            }
        }
    }];
    
    [subMethodData enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != 0) {
            NSString * group = [NSString stringWithFormat:@"-%@",obj];
            NSString * method = [MixMethodStrategy methodFromData:group];
            if (method && ![self.method.exampleMethods containsObject:method]) {
                [self.method.exampleMethods addObject:method];
            }
        }
    }];
    
    
    NSArray <NSString *>* propertyMethodData = [data componentsSeparatedByString:@"@property"];
    
    [propertyMethodData enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSRange range = [obj rangeOfString:@";"];
        if (range.location != NSNotFound) {
            
            NSString * property = [obj substringToIndex:range.location];
            
            if ([property containsString:@"atomic"] || [property containsString:@"nonatomic"]) {
                
                BOOL isOnlyRead = [property containsString:@"readonly"];
                
                NSString * propertyName = nil;
                
                if ([property containsString:@"*"]) {
                    //强引用
                    NSArray * strs = [property componentsSeparatedByString:@"*"];
                    if (strs.count) {
                        NSString * lastStr = strs.lastObject;
                        lastStr = [lastStr stringByReplacingOccurrencesOfString:@" " withString:@" "];
                        if ([MixStringStrategy isAlphaNumUnderline:lastStr]) {
                            propertyName = lastStr;
                        }
                    }
                    
                } else {
                    //弱引用
                    NSArray * strs = [property componentsSeparatedByString:@" "];
                    for (int i = (int)strs.count-1; i > 0; i--) {
                        NSString * str = strs[i];
                        if (str.length) {
                            if ([MixStringStrategy isAlphaNumUnderline:str]) {
                                propertyName = str;
                            }
                        }
                    }
                    
                }
                
                if (propertyName.length) {
                    
                    if (![self.method.propertyMethods containsObject:propertyName]) {
                        [self.method.propertyMethods addObject:propertyName];
                    }

                    if (!isOnlyRead) {
                        NSString * setPropertyName = [propertyName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[propertyName substringToIndex:1] uppercaseString]];
                        
                        setPropertyName = [NSString stringWithFormat:@"set%@:",setPropertyName];
                        
                        if (![self.method.propertyMethods containsObject:setPropertyName]) {
                            [self.method.propertyMethods addObject:setPropertyName];
                        }
                        
                    }
                }
                
                
                
            }
        }
        
        
        
    }];
    
    

}

- (MixMethod *)method {
    if (!_method) {
        _method = [[MixMethod alloc] init];
    }
    return _method;
}


@end
