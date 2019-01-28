//
//  MixMainStrategy.m
//  Mix
//
//  Created by ChenJie on 2019/1/21.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import "MixMainStrategy.h"
#import "../Model/MixObject.h"
#import "../Model/MixFile.h"
#import "MixFileStrategy.h"
#import "MixClassFileStrategy.h"
#import "MixObjectStrategy.h"
#import "MixJudgeStrategy.h"
#import "file/MixFileNameStrategy.h"
#import "../Config/MixConfig.h"

@implementation MixMainStrategy

#pragma mark 替换方法名

+ (void)replaceMethod:(NSArray <MixObject *>*)objects methods:(NSArray <NSString *>*)methods systemObjects:(NSArray <MixObject*>*)systemObjects {
    
    NSMutableArray <NSString *>* validClassMethods = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray <NSString *>* validExampleMethods = [NSMutableArray arrayWithCapacity:0];
    for (MixObject * object in objects) {
        for (MixClass * class in object.hClasses) {
            
            for (NSString * method in class.method.classMethods) {
                if (![validClassMethods containsObject:method] && ![MixMainStrategy repetition:method systemObjects:systemObjects]) {
                    [validClassMethods addObject:method];
                }
            }
            
            for (NSString * method in class.method.exampleMethods) {
                if (![validExampleMethods containsObject:method] && ![MixMainStrategy repetition:method systemObjects:systemObjects]) {
                    [validExampleMethods addObject:method];
                }
            }
        }
    }
    
    NSInteger validCount = validClassMethods.count + validExampleMethods.count;
    
    NSAssert(methods.count >= validCount, @"方法数量不足");
    
    NSMutableArray <NSString *>* newMethods = [NSMutableArray arrayWithArray:methods];
    NSMutableArray <NSString *>* worker = [NSMutableArray arrayWithArray:methods];
    
    [newMethods enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([MixMainStrategy repetition:obj systemObjects:systemObjects]) {
            [worker removeObject:obj];
        }
    }];
    
    newMethods = worker;
    
    for (NSString * method in validClassMethods) {
        if (![MixMainStrategy repetition:method systemObjects:systemObjects]) {
            [MixMainStrategy replaceMethod:objects oldMethod:method newMethods:newMethods];
        }
    }
    
    for (NSString * method in validExampleMethods) {
        if (![MixMainStrategy repetition:method systemObjects:systemObjects]) {
            [MixMainStrategy replaceMethod:objects oldMethod:method newMethods:newMethods];
        }
    }
    
}

+ (BOOL)repetition:(NSString *)method systemObjects:(NSArray <MixObject*>*)systemObjects  {
    
    for (MixObject * object in systemObjects) {
        for (MixClass * class in object.hClasses) {
            for (NSString * classMethod in class.method.classMethods) {
                if ([classMethod containsString:method] || [method containsString:classMethod]) {
                    return YES;
                }
            }
            
            for (NSString * exampleMethod in class.method.exampleMethods) {
                if ([exampleMethod containsString:method] || [method containsString:exampleMethod]) {
                    return YES;
                }
            }
        }
    }
    return NO;

}

+ (void)replaceMethod:(NSArray <MixObject *>*)objects oldMethod:(NSString *)oldMethod newMethods:(NSMutableArray <NSString *>*)newMethods {
    
    NSString * oldTrueMethod = [MixMainStrategy trueMethod:oldMethod];
    if (oldTrueMethod.length < 9 || [oldTrueMethod containsString:@"sharedInstance"]) {
        return;
    }
    
    if ([MixJudgeStrategy isShieldWithMethod:oldTrueMethod]) {
        return;
    }
    
    
    NSString * newMethod = newMethods.firstObject;
    [newMethods removeObjectAtIndex:0];
    
    NSString * newTrueMethod = [MixMainStrategy trueMethod:newMethod];
    
    for (MixObject * object in objects) {
        [MixMainStrategy replaceMethod:object oldMethod:oldTrueMethod newMethod:newTrueMethod file:object.classFile.hFile];
        [MixMainStrategy replaceMethod:object oldMethod:oldTrueMethod newMethod:newTrueMethod file:object.classFile.mFile];
    }
    
    
}

+ (NSString *)trueMethod:(NSString *)method {
    
    NSString * trueMethod = nil;
    if ([method containsString:@":"]) {
        NSArray <NSString *>* names = [method componentsSeparatedByString:@":"];
        trueMethod = names[0];
    } else {
        trueMethod = method;
    }
    return trueMethod;
}

+ (void)replaceMethod:(MixObject *)object oldMethod:(NSString *)oldMethod newMethod:(NSString *)newMethod file:(MixFile *)file {
    if (!file || !file.data || !oldMethod || !newMethod) {
        return;
    }
    
    NSString * substitute = [file.data stringByReplacingOccurrencesOfString:oldMethod withString:newMethod];
    
    if (![substitute isEqualToString:file.data]) {
        file.data = substitute;
        [MixFileStrategy writeFileAtPath:file.path content:substitute];
    }

    
}


#pragma mark 替换类名

+ (void)replaceClassName:(NSArray <MixObject *>*)objects referenceClassNames:(NSArray <NSString *>*)classNames {
    
    int count = 0;
    //获取合法替换类数量
    for (MixObject * object in objects) {
        if (![MixJudgeStrategy isSystemClass:object.classFile.classFileName]) {
            count = count + (int)object.hClasses.count + (int)object.mClasses.count;
        }
    }
    
    //剔除不符合条件的类名
    NSMutableArray <NSString *>* workers = [NSMutableArray arrayWithArray:classNames];
    
    [classNames enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([MixJudgeStrategy isSystemClass:obj]) {
            [workers removeObject:obj];
        } else {
            for (MixObject * object in objects) {
                
                for (MixClass * class in object.hClasses) {
                    if ([class.className isEqualToString:obj]) {
                        [workers removeObject:obj];
                    }
                }
                
                for (MixClass * class in object.mClasses) {
                    if ([class.className isEqualToString:obj]) {
                        [workers removeObject:obj];
                    }
                }
                
                if ([object.classFile.classFileName isEqualToString:obj]) {
                    [workers removeObject:obj];
                }
            }
        }
        
    }];
    
    NSMutableArray<NSString *> * referenceClassNames = [NSMutableArray arrayWithArray:workers];
    
    NSAssert(count <= referenceClassNames.count, @"类名不足\n需要替换类数量:%d 类名数量:%d\n",(int)count,(int)referenceClassNames.count);
    
    for (MixObject * object in objects) {
        
        if (object.classFile.isAppDelegate) {
            continue;
        }
        
        [MixMainStrategy replace:object.hClasses newNames:referenceClassNames allObject:objects];
        
        if (object.hClasses.count) {
            MixClass * class = object.hClasses[0];
            if (class.className) {
                object.classFile.resetFileName = class.className;
            }
        }
        
        [MixMainStrategy replace:object.mClasses newNames:referenceClassNames allObject:objects];
        
    }
    
}

+ (void)replace:(NSArray <MixClass *>*)classes newNames:(NSMutableArray<NSString *>*)newNmaes allObject:(NSArray <MixObject *>*)allObject {
    for (MixClass * class in classes) {
        NSString * oldClassName = class.className;
        if ([MixJudgeStrategy isSystemClass:oldClassName]) {
            continue;
        }
        NSString * newClassName = newNmaes.firstObject;
        [newNmaes removeObjectAtIndex:0];
        [MixMainStrategy reference:allObject oldName:oldClassName newName:newClassName];
        class.className = newClassName;
        
    }
}

+ (NSString *)referenceData:(NSString *)data oldName:(NSString*)oldName newName:(NSString *)newName fileName:(NSString *)fileName {
    
    NSArray * division = [data componentsSeparatedByString:oldName];
    if (division.count <= 1) {
        return data;
    }
    
    NSString * dataCopy = [NSString stringWithFormat:@"%@",data];
    NSString * substitute = [dataCopy stringByReplacingOccurrencesOfString:@"\t" withString:@" "];
    
    for (int ii = 0; ii < division.count; ii++) {
        
        NSRange range = [substitute rangeOfString:oldName];
        if (range.location == NSNotFound) {
            continue;
        }
        if (range.location > 0) {
            NSRange frontRange = NSMakeRange(range.location-1, 1);
            NSRange backRange = NSMakeRange(range.location + range.length, 1);
            NSString * frontSymbol = [substitute substringWithRange:frontRange];
            NSString * backSymbol = [substitute substringWithRange:backRange];
            
            if ([MixJudgeStrategy isLegalClassFrontSymbol:frontSymbol] && [MixJudgeStrategy isLegalClassBackSymbol:backSymbol]) {
                NSString * front = [substitute substringToIndex:range.location];
                NSString * back = [substitute substringFromIndex:range.location + range.length];
                substitute = [NSString stringWithFormat:@"%@%@%@",front,newName,back];
                
            } else {
                if ([MixJudgeStrategy isLegalClassFrontSymbol:frontSymbol]) {
                    if ([backSymbol isEqualToString:@"."]) {
                        
                        NSRange newBackRange = NSMakeRange(range.location + range.length, 3);
                        NSString * newBackSymbol = [substitute substringWithRange:newBackRange];
                        if (![newBackSymbol isEqualToString:@".h\n"]&&![newBackSymbol isEqualToString:@".h\t"]&&![newBackSymbol isEqualToString:@".h\""]&&![newBackSymbol isEqualToString:@".h "]) {
                            
                            NSString * front = [substitute substringToIndex:range.location];
                            NSString * back = [substitute substringFromIndex:range.location + range.length];
                            substitute = [NSString stringWithFormat:@"%@%@%@",front,newName,back];
                            
                            continue;
                        }
                        
                    }
                }
                
                NSString * front = [substitute substringToIndex:range.location];
                NSString * back = [substitute substringFromIndex:range.location + range.length];
                NSString * encrypt = [NSString stringWithFormat:@"######&&&&&&$$$$$******"];
                substitute = [NSString stringWithFormat:@"%@%@%@",front,encrypt,back];
                
                if ([MixConfig sharedSingleton].openLog) {
                    NSArray * lines = [front componentsSeparatedByString:@"\n"];
                    printf("打断替换 文件:%s 原类:%s 新类:%s %d行\n",[fileName UTF8String] ,[oldName UTF8String],[newName UTF8String], (int)lines.count);
                }
                
            }
        }
    }
    
    NSString * substituteCopy = [substitute stringByReplacingOccurrencesOfString:@"######&&&&&&$$$$$******" withString:oldName];
    substitute = substituteCopy;
    
    
    return substitute;
}

+ (void)referenceDataAndWrite:(MixFile *)file oldName:(NSString*)oldName newName:(NSString *)newName {
    if (![file isKindOfClass:[MixFile class]]) {
        return;
    }
    
    NSString * data = [MixMainStrategy referenceData:file.data oldName:oldName newName:newName fileName:file.fileName];
    if (![file.data isEqualToString:data]) {
        file.data = data;
        [MixFileStrategy writeFileAtPath:file.path content:data];
    }
    
    
}


+ (void)reference:(NSArray <MixObject *>*)objects oldName:(NSString*)oldName newName:(NSString *)newName {
    
    for (MixObject * object in objects) {
        
        @autoreleasepool {
            [MixMainStrategy referenceDataAndWrite:object.classFile.hFile oldName:oldName newName:newName];
            [MixMainStrategy referenceDataAndWrite:object.classFile.mFile oldName:oldName newName:newName];
        }
    }
    
    for (MixFile * file in [MixConfig sharedSingleton].pchFile) {
        [MixMainStrategy referenceDataAndWrite:file oldName:oldName newName:newName];
    }
    
    
    
}






@end
