//
//  MixClass.m
//  Mix
//
//  Created by ChenJie on 2019/1/21.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import "MixClass.h"
#import "MixStringStrategy.h"

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
                NSArray * addMethod = [obj componentsSeparatedByString:@"+"];
                NSArray * subMethod = [obj componentsSeparatedByString:@"-"];
                
                
                
                
                printf("");
                
                
            }
        }
    }
}

@end
