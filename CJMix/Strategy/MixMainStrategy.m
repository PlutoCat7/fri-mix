//
//  MixMainStrategy.m
//  Mix
//
//  Created by ChenJie on 2019/1/21.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import "MixMainStrategy.h"
#import "MixFileStrategy.h"
#import "MixClassFileStrategy.h"
#import "MixObjectStrategy.h"
#import "MixJudgeStrategy.h"
#import "MixMethodStrategy.h"
#import "MixStringStrategy.h"
#import "file/MixFileNameStrategy.h"
#import "../Model/MixObject.h"
#import "../Model/MixFile.h"
#import "../Model/MixEncryption.h"
#import "../Config/MixConfig.h"

#define kMixMinMethodLength 5
#define kMixTag @"######&&&&&&$$$$$***&#$***"

@implementation MixMainStrategy

#pragma mark 替换方法名

+ (void)replaceMethod:(NSArray <MixObject *>*)objects methods:(NSArray <NSString *>*)methods systemMethods:(NSArray <NSString*>*)systemMethods {
    
    NSMutableArray <NSString *>* validMethods = [NSMutableArray arrayWithArray:[MixMethodStrategy methods:objects]];
    
    NSMutableArray <NSString *>* newMethods = [NSMutableArray arrayWithArray:methods];
    NSMutableArray <NSString *>* worker = [NSMutableArray arrayWithCapacity:0];
    for (NSString * obj in newMethods) {
        NSString * str = [MixMainStrategy trueMethod:obj];
        if (![worker containsObject:str]) {
            [worker addObject:str];
        }
    }
    newMethods = worker;
    [MixConfig sharedSingleton].shieldSystemMethodNames = [MixMainStrategy shieldSystemMethodName:systemMethods];
    
    NSInteger count = 0;
    for (NSString * method in validMethods) {
        count ++;
        @autoreleasepool {
            [MixMainStrategy replaceMethod:objects oldMethod:method newMethods:newMethods];
        }
        printf("完成进度%.2f %%  \n",(float)count/(float)validMethods.count*100);
    }
    printf("保存数据\n");
    for (MixObject * object in objects) {
        [object.classFile.hFile save];
        [object.classFile.mFile save];
    }
    
    for (MixFile * file in [MixConfig sharedSingleton].pchFile) {
        [file save];
    }
    
}


+ (NSArray <NSString *>*)shieldSystemMethodName:(NSArray <NSString*>*)systemMethods {
    @autoreleasepool {
        NSMutableArray * strs = [NSMutableArray arrayWithCapacity:0];
        for (NSString * systemMethod in systemMethods) {
            NSArray * sysMethods = [systemMethod componentsSeparatedByString:@":"];
            for (NSString * str in sysMethods) {
                if (str.length >= kMixMinMethodLength) {
                    [strs addObject:str];
                }
            }
        }
        return strs;
    }
}




+ (void)replaceMethod:(NSArray <MixObject *>*)objects oldMethod:(NSString *)oldMethod newMethods:(NSMutableArray <NSString *>*)newMethods {
    
    if ([MixJudgeStrategy isIllegalMethod:oldMethod]) {
//        printf("深坑:%s\n",[oldMethod UTF8String]);
        return;
    }
    
    NSString * oldTrueMethod = [MixMainStrategy trueMethod:oldMethod];
    NSString * oldSetTrueMethod = nil;
    if (![oldMethod containsString:@":"]) {
        oldSetTrueMethod = [oldTrueMethod stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[oldTrueMethod substringToIndex:1] uppercaseString]];
        oldSetTrueMethod = [NSString stringWithFormat:@"set%@",oldSetTrueMethod];
    }
    
    
    if ([[MixConfig sharedSingleton].shieldSystemMethodNames containsObject:oldTrueMethod]) {
        return;
    }
    
    for (NSString * property in [MixConfig sharedSingleton].shieldProperty) {
        if (([property containsString:oldTrueMethod]&&[property containsString:@"_"])||[property isEqualToString:oldTrueMethod]) {
            return;
        }
    }
    
    if ([MixJudgeStrategy isShieldWithMethod:oldTrueMethod]) {
        return;
    }
    
    if (!newMethods.count) {
        return;
    }
    
    
    NSString * newMethod = [MixConfig sharedSingleton].mixMethodCache[oldMethod];
    
    if (![newMethod isKindOfClass:[NSString class]]) {
        newMethod = newMethods.firstObject;
        [newMethods removeObjectAtIndex:0];
        [MixConfig sharedSingleton].mixMethodCache[oldMethod] = newMethod;
    }

    NSString * newTrueMethod = [MixMainStrategy trueMethod:newMethod];

    for (MixObject * object in objects) {
        @autoreleasepool {
            [MixMainStrategy replaceMethodOldMethod:oldTrueMethod newMethod:newTrueMethod file:object.classFile.hFile];
            [MixMainStrategy replaceMethodOldMethod:oldTrueMethod newMethod:newTrueMethod file:object.classFile.mFile];
        };
    }

    for (MixFile * file in [MixConfig sharedSingleton].pchFile) {
        @autoreleasepool {
            [MixMainStrategy replaceMethodOldMethod:oldTrueMethod newMethod:newTrueMethod file:file];
        }
    }


    if (oldSetTrueMethod) {
        NSString * newSetTrueMethod = [newTrueMethod stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[newTrueMethod substringToIndex:1] uppercaseString]];
        newSetTrueMethod = [NSString stringWithFormat:@"set%@",newSetTrueMethod];

        //有可能存在set方法
        for (MixObject * object in objects) {
            [MixMainStrategy replaceMethodOldMethod:oldSetTrueMethod newMethod:newSetTrueMethod file:object.classFile.hFile];
            [MixMainStrategy replaceMethodOldMethod:oldSetTrueMethod newMethod:newSetTrueMethod file:object.classFile.mFile];
        }

        for (MixFile * file in [MixConfig sharedSingleton].pchFile) {
            [MixMainStrategy replaceMethodOldMethod:oldSetTrueMethod newMethod:newSetTrueMethod file:file];
        }


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

+ (void)replaceMethodOldMethod:(NSString *)oldMethod newMethod:(NSString *)newMethod file:(MixFile *)file {
    if (!file || !file.data || !file.path || !oldMethod || !newMethod) {
        return;
    }
    
    MixEncryption * encryption = [MixEncryption encryptionWithFile:file];
    
    if (![encryption.encryptionData containsString:oldMethod]) {
        return;
    }
    
    NSArray * division = [encryption.encryptionData componentsSeparatedByString:oldMethod];
    
    if (division.count <= 1) {
        return;
    }
    
    NSString * dataCopy = [NSString stringWithFormat:@"%@",encryption.encryptionData];
    NSString * substitute = [dataCopy stringByReplacingOccurrencesOfString:@"\t" withString:@" "];
    
    for (int ii = 0; ii <= division.count; ii++) {
        NSRange range = [substitute rangeOfString:oldMethod];
        if (range.location != NSNotFound) {

            NSRange frontRange = NSMakeRange(range.location - 1, 1);
            NSRange backRange = NSMakeRange(range.location + range.length, 1);
            NSString * frontSymbol = [substitute substringWithRange:frontRange];
            NSString * backSymbol = [substitute substringWithRange:backRange];

            NSString * front = [substitute substringToIndex:range.location];
            NSString * back = [substitute substringFromIndex:range.location + range.length];
            if ([MixJudgeStrategy isLegalMethodFrontSymbol:frontSymbol] && [MixJudgeStrategy isLegalMethodBackSymbol:backSymbol]) {
                substitute = [NSString stringWithFormat:@"%@%@%@",front,newMethod,back];
            } else {
                NSString * encrypt = [NSString stringWithFormat:kMixTag];
                substitute = [NSString stringWithFormat:@"%@%@%@",front,encrypt,back];
            }
            
        }
    }
    
    NSString * substituteCopy = [substitute stringByReplacingOccurrencesOfString:kMixTag withString:oldMethod];
    
    if (![encryption.encryptionData isEqualToString:substituteCopy]) {
        encryption.encryptionData = substituteCopy;
        file.isEdit = YES;
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
    

    if (count > referenceClassNames.count) {
        printf("类名不足\n需要替换类数量:%d 类名数量:%d\n",(int)count,(int)referenceClassNames.count);
        return;
    }
    
    
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
        
        if ([MixJudgeStrategy isSystemClass:oldClassName] || [MixJudgeStrategy isShieldWithClass:oldClassName]) {
            continue;
        }
        
        if (!newNmaes.count) {
            break;
        }
        
        NSString * newClassName;
        if (![[MixConfig sharedSingleton].mixClassCache.allKeys containsObject:oldClassName]) {
            newClassName = newNmaes.firstObject;
            [newNmaes removeObjectAtIndex:0];
            [MixConfig sharedSingleton].mixClassCache[oldClassName] = newClassName;
        } else {
            newClassName = [MixConfig sharedSingleton].mixClassCache[oldClassName];
        }
        
        [MixMainStrategy reference:allObject oldName:oldClassName newName:newClassName];
        class.className = newClassName;
        
    }
}

+ (NSString *)referenceData:(MixFile *)file oldName:(NSString*)oldName newName:(NSString *)newName {
    
    if (!file.data) {
        return nil;
    }
    
    NSArray * division = [file.data componentsSeparatedByString:oldName];
    if (division.count <= 1) {
        return file.data;
    }
    
    NSString * dataCopy = [NSString stringWithFormat:@"%@",file.data];
    NSString * substitute = [dataCopy stringByReplacingOccurrencesOfString:@"\t" withString:@" "];
    
    for (int ii = 0; ii <= division.count ; ii++) {
        
        NSRange range = [substitute rangeOfString:oldName];
        if (range.location == NSNotFound) {
            continue;
        }
        if (range.location > 0) {
            NSRange frontRange = NSMakeRange(range.location - 1, 1);
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
                NSString * encrypt = [NSString stringWithFormat:kMixTag];
                substitute = [NSString stringWithFormat:@"%@%@%@",front,encrypt,back];
                
                if ([MixConfig sharedSingleton].openLog) {
                    NSArray * lines = [front componentsSeparatedByString:@"\n"];
                    printf("打断替换 文件:%s 原类:%s 新类:%s %d行\n",[file.fileName UTF8String] ,[oldName UTF8String],[newName UTF8String], (int)lines.count);
                }
                
            }
        }
    }
    
    NSString * substituteCopy = [substitute stringByReplacingOccurrencesOfString:kMixTag withString:oldName];
    substitute = substituteCopy;
    
    
    return substitute;
}

+ (void)referenceDataAndWrite:(MixFile *)file oldName:(NSString*)oldName newName:(NSString *)newName {
    if (![file isKindOfClass:[MixFile class]]) {
        return;
    }
    
    NSString * data = [MixMainStrategy referenceData:file oldName:oldName newName:newName];
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
