//
//  MixClassStrategy.m
//  CJMix
//
//  Created by ChenJie on 2019/1/24.
//  Copyright © 2019 Chan. All rights reserved.
//

#import "MixClassStrategy.h"
#import "MixStringStrategy.h"
#import "MixJudgeStrategy.h"

@implementation MixClassStrategy

+ (NSArray <MixClass *>*)dataToClassName:(NSString *)data {
    __block NSMutableArray <MixClass *>* classNames = [NSMutableArray arrayWithCapacity:0];
    
    NSArray <NSString *>* classes = [data componentsSeparatedByString:@"@interface"];
    if (classes.count > 1) {
        [classes enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx != 0 && [obj containsString:@":"]) {
                
                NSArray <NSString *>* blanks = [obj componentsSeparatedByString:@" "];
                NSString * classStr = nil;
                for (int ii = 0; ii < blanks.count; ii++) {
                    NSString * str = blanks[ii];
                    if (!str.length) {
                        continue;
                    }
                    
                    if ([str containsString:@":"]) {
                        NSArray <NSString *>* strs = [obj componentsSeparatedByString:@":"];
                        
                        if (strs.count) {
                            
                            NSString * temp = strs[0];
                            NSString * replacing = [temp stringByReplacingOccurrencesOfString:@" " withString:@""];
                            if ([MixStringStrategy isAlphaNum:replacing]) {
                                classStr = replacing;
                            }
                        }
                        
                    }
                    else {
                        if ([MixStringStrategy isAlphaNum:str]) {
                            for (int ff = ii + 1 ; ff < blanks.count; ff++) {
                                NSString * pp = blanks[ff];
                                if (!pp.length) {
                                    continue;
                                }
                                
                                if ([pp hasPrefix:@":"]) {
                                    classStr = str;
                                }
                                
                                break;
                                
                            }
                            
                            
                        }
                    }
                    break;
                }
                
                
                if (classStr && ![MixJudgeStrategy isSystemClass:classStr]) {
                    
                    MixClass * class = [[MixClass alloc] initWithClassName:classStr];
                    [class methodFromData:obj];
                    [classNames addObject:class];
                }
            }
        }];
    }
    
    return classNames;
}

@end
