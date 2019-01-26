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

- (instancetype)initWithClassName:(NSString *)className {
    self = [super init];
    if (self) {
        _className = className;
    }
    return self;
}

- (void)methodFromData:(NSString *)data {
    if (!self.className) {
        printf("连类名都没有负分滚粗\n");
        return;
    }
    
    NSString * newData = [MixStringStrategy filterOutImpurities:data];
    
    if (![newData hasPrefix:self.className] || ![newData hasSuffix:@"@end"]) {
        //不是我想要的滑板鞋
        return;
    }
    
    NSArray <NSString *>* addMethodData = [newData componentsSeparatedByString:@"+"];
    NSArray <NSString *>* subMethodData = [newData componentsSeparatedByString:@"-"];
    __block NSMutableArray * addMethods = [NSMutableArray arrayWithCapacity:0];
    __block NSMutableArray * subMethods = [NSMutableArray arrayWithCapacity:0];
    
    [addMethodData enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != 0) {
            NSString * group = [NSString stringWithFormat:@"+%@",obj];
            NSString * method = [MixMethodStrategy methodFromData:group];
            if (method) {
                [addMethods addObject:method];
            }
        }
    }];
    
    [subMethodData enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != 0) {
            NSString * group = [NSString stringWithFormat:@"-%@",obj];
            NSString * method = [MixMethodStrategy methodFromData:group];
            if (method) {
                [subMethods addObject:method];
            }
        }
    }];
    
    self.method.classMethods = [NSArray arrayWithArray:addMethods];
    self.method.exampleMethods = [NSArray arrayWithArray:subMethods];


}

- (MixMethod *)method {
    if (!_method) {
        _method = [[MixMethod alloc] init];
    }
    return _method;
}

- (MixProperty *)property {
    if (!_property) {
        _property = [[MixProperty alloc] init];
    }
    return _property;
}

@end
