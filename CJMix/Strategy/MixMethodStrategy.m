//
//  MixMethodStrategy.m
//  CJMix
//
//  Created by ChenJie on 2019/1/24.
//  Copyright © 2019 Chan. All rights reserved.
//

#import "MixMethodStrategy.h"
#import "MixStringStrategy.h"
#import "MixFileStrategy.h"
#import "../Config/MixConfig.h"

@implementation MixMethodStrategy

+ (NSString *)methodFromData:(NSString *)data {
    
    //判断无参数方法
    NSRange bracketRange = [data rangeOfString:@")"];
    NSString * methodStr = nil;
    if (bracketRange.location != NSNotFound) {
        methodStr = [data substringFromIndex:bracketRange.location + bracketRange.length];
        if ([methodStr containsString:@"{"] || [methodStr containsString:@";"]) {
            NSRange range1 = [methodStr rangeOfString:@"{"];
            NSRange range2 = [methodStr rangeOfString:@";"];
            NSInteger location = NSNotFound;
            if (range1.location != NSNotFound) {
                location = range1.location;
            }
            if (range2.location != NSNotFound) {
                if (range2.location < location) {
                    location = range2.location;
                }
            }
            
            if (location != NSNotFound) {
                methodStr = [methodStr substringToIndex:location];
            } else {
                methodStr = nil;
            }
            
        }
        
    }
    
    
    if (!methodStr) {
        return nil;
    }
    
    if ([methodStr containsString:@":"]) {
        //如果有
        
        NSArray <NSString *>* names = [data componentsSeparatedByString:@":"];
        
        if (names.count) {
            NSMutableArray <NSString *>* methodNames = [NSMutableArray arrayWithCapacity:0];
            for (NSString * name in names) {
                NSRange range = [name rangeOfString:@")"];
                if (range.location != NSNotFound) {
                    NSString * methodStr = [name substringFromIndex:range.location + range.length];
                    
                    if ([name isEqual:names.lastObject]) {
                        //最后一个
                        NSRange range1 = [methodStr rangeOfString:@" "];
                        NSRange range2 = [methodStr rangeOfString:@";"];
                        NSInteger location = NSNotFound;
                        if (range1.location != NSNotFound) {
                            location = range1.location;
                        }
                        if (range2.location != NSNotFound) {
                            if (range2.location < location) {
                                location = range2.location;
                            }
                        }
                        
                        if (location != NSNotFound) {
                            methodStr = [methodStr substringToIndex:location];
                            if ([MixStringStrategy isAlphaNum:methodStr]) {
                                [methodNames addObject:methodStr];
                            }
                        }
                        break;
                    }
                    
                    if ([MixStringStrategy isAlphaNum:methodStr]) {
                        [methodNames addObject:methodStr];
                    } else {

                        if ([methodStr containsString:@" "]) {
                            
                            NSRange blankRange = [methodStr rangeOfString:@" "];
                            methodStr = [methodStr substringFromIndex:blankRange.location + blankRange.length];
                            if ([MixStringStrategy isAlphaNum:methodStr]) {
                                [methodNames addObject:methodStr];
                            }
                        }
                    }
                } else {
                    if ([MixStringStrategy isAlphaNum:name]) {
                        [methodNames addObject:name];
                    }
                }
                
            }
            NSString *methodInfo = nil;
            
            if (methodNames.count) {
                methodInfo = [NSString stringWithFormat:@"%@:",[methodNames componentsJoinedByString:@":"]];
            }
            
            return methodInfo;
        }
        
    } else {
        methodStr = [methodStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        
        if ([MixStringStrategy isAlphaNum:methodStr]) {
            return methodStr;
        }
    }
   
    
    return nil;
}

+ (NSArray <NSString *>*)methodsWithPath:(NSString *)path {
    NSArray <MixFile *> *files = [MixFileStrategy filesWithPath:path framework:YES];
    NSArray<MixFile *> *hmFiles = [MixFileStrategy filesToHMFiles:files];
    
    NSMutableArray <NSString *> * methods = [NSMutableArray arrayWithCapacity:0];
    
    for (MixFile * obj in hmFiles) {
        [methods addObjectsFromArray:[MixMethodStrategy methodsWithData:obj.data]];
    }
    
    return methods;
}


+ (NSArray <NSString *>*)methods:(NSArray <MixObject *>*)objects {
    
    NSMutableArray <NSString *> * methods = [NSMutableArray arrayWithCapacity:0];
    
    for (MixObject * obj in objects) {
        if (obj.classFile.hFile) {
            [methods addObjectsFromArray:[MixMethodStrategy methodsWithData:obj.classFile.hFile.data]];
        }
        if (obj.classFile.mFile) {
            [methods addObjectsFromArray:[MixMethodStrategy methodsWithData:obj.classFile.mFile.data]];
        }
    }
    
    NSMutableArray * worker = [NSMutableArray arrayWithCapacity:0];
    for (NSString * obj in objects) {
        if (![worker containsObject:obj]) {
            [worker addObject:obj];
        }
    }
    
    return worker;
}


+ (NSArray <NSString *>*)methodsWithData:(NSString *)data {
    if (!data) {
        return @[];
    }
    NSMutableArray <NSString *>* methods = [NSMutableArray arrayWithCapacity:0];
    
    NSArray <NSString *>* interface = [data componentsSeparatedByString:@"@interface"];
    for (NSString * obj in interface) {
        NSRange range = [obj rangeOfString:@"@end"];
        if (range.location != NSNotFound) {
            NSString * str = [obj substringToIndex:range.location];
            [methods addObjectsFromArray:[MixMethodStrategy methodsWithClassData:str]];
        }
    }
    
    
    NSArray <NSString *>* implementations = [data componentsSeparatedByString:@"@implementation"];
    for (NSString * obj in implementations) {
        NSRange range = [obj rangeOfString:@"@end"];
        if (range.location != NSNotFound) {
            NSString * str = [obj substringToIndex:range.location];
            [methods addObjectsFromArray:[MixMethodStrategy methodsWithClassData:str]];
        }
    }
    
    return methods;
}

+ (NSArray <NSString *>*)methodsWithClassData:(NSString *)data {
    
    __block NSMutableArray <NSString *>* methods = [NSMutableArray arrayWithCapacity:0];
    
    NSArray <NSString *>* addMethodData = [data componentsSeparatedByString:@"+"];
    NSArray <NSString *>* subMethodData = [data componentsSeparatedByString:@"-"];
    
    for (NSString * obj in addMethodData) {
        NSString * group = [NSString stringWithFormat:@"+%@",obj];
        NSString * method = [MixMethodStrategy methodFromData:group];
        
        if (method && ![methods containsObject:method]) {
            [methods addObject:method];
        }
    }
    
    for (NSString * obj in subMethodData) {
        NSString * group = [NSString stringWithFormat:@"-%@",obj];
        NSString * method = [MixMethodStrategy methodFromData:group];
        
        if (method && ![methods containsObject:method]) {
            [methods addObject:method];
        }
    }
    
    NSArray <NSString *>* propertyMethodData = [data componentsSeparatedByString:@"@property"];
    
    for (NSString * obj in propertyMethodData) {
        NSRange range = [obj rangeOfString:@";"];
        if (range.location != NSNotFound) {
            
            NSString * property = [obj substringToIndex:range.location];
            
            if ([property containsString:@"atomic"] || [property containsString:@"nonatomic"]) {
                
                //                BOOL isOnlyRead = [property containsString:@"readonly"];
                
                NSString * propertyName = nil;
                
                if ([property containsString:@"*"]) {
                    //强引用
                    NSArray * strs = [property componentsSeparatedByString:@"*"];
                    if (strs.count) {
                        NSString * lastStr = strs.lastObject;
                        lastStr = [lastStr stringByReplacingOccurrencesOfString:@" " withString:@""];
                        if ([MixStringStrategy isAlphaNum:lastStr]) {
                            propertyName = lastStr;
                        }
                    }
                    
                } else {
                    //弱引用
                    NSArray * strs = [property componentsSeparatedByString:@" "];
                    for (int i = (int)strs.count-1; i > 0; i--) {
                        NSString * str = strs[i];
                        if (str.length) {
                            if ([MixStringStrategy isAlphaNum:str]) {
                                propertyName = str;
                                break;
                            }
                        }
                    }
                    
                }
                
                if (propertyName.length) {
                    
                    //                    if (![methods containsObject:propertyName]) {
                    //                        [methods addObject:propertyName];
                    //                    }
                    
                    if (![[MixConfig sharedSingleton].allProperty containsObject:propertyName]) {
                        [[MixConfig sharedSingleton].allProperty addObject:propertyName];
                    }
                    
                    
                    //                    if (!isOnlyRead) {
                    //                        NSString * setPropertyName = [propertyName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[propertyName substringToIndex:1] uppercaseString]];
                    //
                    //                        setPropertyName = [NSString stringWithFormat:@"set%@:",setPropertyName];
                    //
                    //                        if (![methods containsObject:setPropertyName]) {
                    //                            [methods addObject:setPropertyName];
                    //                        }
                    //
                    //                    }
                }
                
                
                
            }
        }

    }
    
    
    
    return methods;
}


@end
