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
#import "MixCacheStrategy.h"

#define kMixMinMethodLength 5
#define kMixTag @"######&&&&&&$$$$$***&#$***"

@implementation MixMainStrategy

#pragma mark 替换方法名

+ (void)replaceMethod:(NSArray <MixObject *>*)objects methods:(NSArray <NSString *>*)methods systemMethods:(NSArray <NSString*>*)systemMethods {
    
    //提取的替换方法
    NSMutableArray <NSString *>* newMethods = [NSMutableArray arrayWithArray:methods];
    NSMutableArray <NSString *>* worker = [NSMutableArray arrayWithCapacity:0];
    for (NSString * obj in newMethods) {
        NSString * str = [MixMainStrategy trueMethod:obj];
        if (![worker containsObject:str]) {
            [worker addObject:str];
        }
    }
    newMethods = worker;
    
    //系统的方法，  需要做过滤处理
    [MixConfig sharedSingleton].shieldSystemMethodNames = [MixMainStrategy shieldSystemMethodName:systemMethods];
    
    //现有工程的需要替换的方法
    NSArray <NSString *> *validMethods = [MixMethodStrategy methods:objects];
    //剔除set方法  防止后面的set方法不统一
    NSMutableArray *tmpList = [NSMutableArray arrayWithArray:validMethods];
    for (NSString *oldMethod in validMethods) {
        
        NSString * oldTrueMethod = [MixMainStrategy trueMethod:oldMethod];
        if (![oldMethod containsString:@":"]) {
            NSString *oldSetTrueMethod = [oldTrueMethod stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[oldTrueMethod substringToIndex:1] uppercaseString]];
            oldSetTrueMethod = [NSString stringWithFormat:@"set%@:",oldSetTrueMethod];
            [tmpList removeObject:oldSetTrueMethod];
        }
    }
    validMethods = [tmpList copy];
    NSMutableArray <NSString *> *oldMethodsList = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray <NSString *> *newMethodsList = [NSMutableArray arrayWithCapacity:1];
    BOOL (^checkValidBlock)(NSString *oldMethod) = ^(NSString *oldMethod){
        
        if ([[MixConfig sharedSingleton].shieldSystemMethodNames containsObject:oldMethod]) {
            return NO;
        }
        BOOL find = NO;
        for (NSString * property in [MixConfig sharedSingleton].shieldProperty) {
            if (([property containsString:oldMethod]&&[property containsString:@"_"])||[property isEqualToString:oldMethod]) {
                find = YES;
                break;
            }
        }
        if (find) {
            return NO;
        }
        if ([oldMethod containsString:@"setAliasUserId"]) {
            return NO;
        }
        if ([MixJudgeStrategy isShieldWithMethod:oldMethod]) {
            return NO;
        }
        if ([oldMethodsList containsObject:oldMethod]) {
            return NO;
        }
        return YES;
    };
    for (NSString *oldMethod in validMethods) {
        
        NSString * oldTrueMethod = [MixMainStrategy trueMethod:oldMethod];
        if (!checkValidBlock(oldTrueMethod)) {
            continue;
        }
        [oldMethodsList addObject:oldTrueMethod];
        NSString * newMethod = [MixCacheStrategy sharedSingleton].mixMethodCache[oldTrueMethod];
        if (![newMethod isKindOfClass:[NSString class]]) {
            newMethod = [self getNewMethodName:newMethods];
            if (!newMethod) {
                return;
            }
            [MixCacheStrategy sharedSingleton].mixMethodCache[oldTrueMethod] = newMethod;
        }
        NSString * newTrueMethod = [MixMainStrategy trueMethod:newMethod];
        [newMethodsList addObject:newTrueMethod];
        //添加set方法
        NSString * oldSetTrueMethod = nil;
        if (![oldMethod containsString:@":"]) {
            oldSetTrueMethod = [oldTrueMethod stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[oldTrueMethod substringToIndex:1] uppercaseString]];
            oldSetTrueMethod = [NSString stringWithFormat:@"set%@",oldSetTrueMethod];
            if (!checkValidBlock(oldSetTrueMethod)) {
                continue;
            }
            [oldMethodsList addObject:oldSetTrueMethod];
            
            NSString * newSetTrueMethod = [newTrueMethod stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[newTrueMethod substringToIndex:1] uppercaseString]];
            newSetTrueMethod = [NSString stringWithFormat:@"set%@",newSetTrueMethod];
            [newMethodsList addObject:newSetTrueMethod];
        }
    }
    
    NSInteger count = 0;
    NSInteger allCount = [MixConfig sharedSingleton].all_HM_File.count;
    CGFloat ratio = 1;
    NSArray *tmpMethods = [oldMethodsList subarrayWithRange:NSMakeRange(0, (NSInteger)(oldMethodsList.count*ratio))];
    for (MixFile *file in [MixConfig sharedSingleton].all_HM_File) {
        count ++;
        @autoreleasepool {
            for (NSInteger i=0; i<tmpMethods.count; i++) {
                [MixMainStrategy replaceMethodOldMethod:tmpMethods[i] newMethod:newMethodsList[i] file:file];
            }
        }
        printf("完成进度%.2f %%  当前文件：%s\n",(float)count/allCount*100, [file.fileName UTF8String]);
    }
    printf("保存数据\n");
    for (MixFile *file in [MixConfig sharedSingleton].all_HM_File) {
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
            //添加set方法
            if (![systemMethod containsString:@":"]) {
                NSString *setMethod = [systemMethod stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[systemMethod substringToIndex:1] uppercaseString]];
                setMethod = [NSString stringWithFormat:@"set%@",setMethod];
                [strs addObject:setMethod];
            }
        }
        return strs;
    }
}

+ (NSString *)getNewMethodName:(NSMutableArray *)newNmaes {
    NSString * newMethodName = newNmaes.firstObject;
    if (!newMethodName) {
        printf("参考的方法不够请添加\n");
        return nil;
    }
    [newNmaes removeObjectAtIndex:0];
    if ([[MixCacheStrategy sharedSingleton].mixMethodCache.allValues containsObject:newMethodName]) {
        return [MixMainStrategy getNewMethodName:newNmaes];
    }
    return newMethodName;
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

    if (![file.data containsString:oldMethod]) {
        return;
    }
    MixEncryption * encryption = [MixEncryption encryptionWithFile:file];
    NSArray * divisions = [encryption.encryptionData componentsSeparatedByString:oldMethod];
    if (divisions.count <= 1) {
        return;
    }
    
    //NSString * dataCopy = [NSString stringWithFormat:@"%@",encryption.encryptionData];
    NSString * dataCopy = encryption.encryptionData;
    NSInteger location = 0;
    for (NSInteger i=0 ; i<divisions.count-1; i++) {  //最后一个不做处理

        NSString *frontString = divisions[i];
        NSString *backString = divisions[i+1];
        //第一个字符
        NSString * frontSymbol = @"";
        NSString * backSymbol = @"";
        @try {
            frontSymbol = [frontString substringFromIndex:frontString.length-1];
            backSymbol = [backString substringWithRange:NSMakeRange(0, 1)];
        }@catch (NSException *exception) {
            NSLog(@"出错了");
        }
        location += frontString.length;
        if ([MixJudgeStrategy isLegalMethodFrontSymbol:frontSymbol] && [MixJudgeStrategy isLegalMethodBackSymbol:backSymbol]) {
            dataCopy = [dataCopy stringByReplacingCharactersInRange:NSMakeRange(location, oldMethod.length) withString:newMethod];
            location += newMethod.length;
        } else {
            location += oldMethod.length;
        }
    }
    
    encryption.encryptionData = dataCopy;
    file.isEdit = YES;
    
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

+ (void)replace:(NSArray <MixClass *>*)classes newNames:(NSMutableArray<NSString *>*)newNames allObject:(NSArray <MixObject *>*)allObject {
    
    for (MixClass * class in classes) {
        NSString * oldClassName = class.className;
        
        if ([MixJudgeStrategy isSystemClass:oldClassName] || [MixJudgeStrategy isShieldWithClass:oldClassName]) {
            continue;
        }
        
        if (!newNames.count) {
            break;
        }
        
        NSString * newClassName;
        if (![[MixCacheStrategy sharedSingleton].mixClassCache.allKeys containsObject:oldClassName]) {
            newClassName = [MixMainStrategy getNewClassName:newNames];
            [MixCacheStrategy sharedSingleton].mixClassCache[oldClassName] = newClassName;
        } else {
            newClassName = [MixCacheStrategy sharedSingleton].mixClassCache[oldClassName];
        }
        
        [MixMainStrategy reference:allObject oldName:oldClassName newName:newClassName];
        class.className = newClassName;
        
    }
}

+ (NSString *)getNewClassName:(NSMutableArray *)newNmaes {
    NSString * newClassName = newNmaes.firstObject;
    [newNmaes removeObjectAtIndex:0];
    if ([[MixCacheStrategy sharedSingleton].mixClassCache.allValues containsObject:newClassName]) {
        return [MixMainStrategy getNewClassName:newNmaes];
    }
    return newClassName;
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
