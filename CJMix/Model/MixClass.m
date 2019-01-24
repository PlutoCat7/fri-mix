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
        return;
    }
    
    NSArray <NSString *>* interfaces = [data componentsSeparatedByString:@"@interface"];
    
    for (NSString * obj in interfaces) {
        if ([obj containsString:@"@end"]) {
            NSString * class = [obj stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            class = [class stringByReplacingOccurrencesOfString:@" " withString:@""];
            if ([class hasPrefix:self.className]) {
                NSArray <NSString *>* addMethodData = [obj componentsSeparatedByString:@"+"];
                NSArray <NSString *>* subMethodData = [obj componentsSeparatedByString:@"-"];
                
                __block NSMutableArray * addMethods = [NSMutableArray arrayWithCapacity:0];
                __block NSMutableArray * subMethods = [NSMutableArray arrayWithCapacity:0];
                
                [addMethodData enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (idx != 0) {
                        NSString * method = [MixMethodStrategy methodFromData:obj];
                        if (method) {
                            [addMethods addObject:method];
                        }
                    }
                }];
                
                [subMethodData enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (idx != 0) {
                        NSString * method = [MixMethodStrategy methodFromData:obj];
                        if (method) {
                            [subMethods addObject:method];
                        }
                    }
                }];
                
                
                self.method.addMethod = [NSArray arrayWithArray:addMethods];
                self.method.subMethod = [NSArray arrayWithArray:subMethods];
                
            }
        }
    }
}

- (MixMethod *)method {
    if (!_method) {
        _method = [[MixMethod alloc] init];
    }
    return _method;
}

@end
