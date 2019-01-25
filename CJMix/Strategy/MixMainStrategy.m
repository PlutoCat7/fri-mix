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

@implementation MixMainStrategy

+ (NSArray <MixObject *>*)objectsWithPath:(NSString *)path {
    //获取所有文件（包括文件夹）
    NSArray<MixFile *> *files = [MixFileStrategy filesWithPath:path];
    //取出所有.h .m文件
    NSArray<MixFile *> *hmFiles = [MixFileStrategy filesToHMFiles:files];
    //合成完整类文件（需要完整的.h .m）
    NSArray <MixClassFile *> * classFiles = [MixClassFileStrategy filesToClassFiles:hmFiles];
    //拿到对象信息
    NSArray <MixObject*>* objects = [MixObjectStrategy fileToObject:classFiles];
    
    return objects;
}

+ (void)modifyTheProject:(MixFile *)projectFile names:(NSArray <NSString *>*)names {
    
}

+ (BOOL)fileLegal:(NSString *)classFileName {
    if (![classFileName containsString:@"+"]) {
        return YES;
    }
    return NO;
}

+ (BOOL)legal:(NSString *)className {
    if ([MixJudgeStrategy isSystemClass:className]) {
        return NO;
    }
    
    return YES;
}

+ (void)replaceClassName:(NSArray <MixObject *>*)objects referenceClassNames:(NSArray <NSString *>*)classNames {
    
    int count = 0;
    //获取合法替换类数量
    for (MixObject * object in objects) {
        if (![MixJudgeStrategy isSystemClass:object.classFile.classFileName]) {
            count = count + (int)object.hClasses.count;
        }
    }
    
    //剔除不符合条件的类名
    NSMutableArray <NSString *>* workers = [NSMutableArray arrayWithArray:classNames];
    
    [classNames enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([MixJudgeStrategy isSystemClass:obj]) {
            [workers removeObject:obj];
        } else {
            for (MixObject * object in objects) {
                if ([object.classFile.classFileName isEqualToString:obj]) {
                    [workers removeObject:obj];
                }
            }
        }
        
    }];
    
    NSMutableArray * referenceClassNames = [NSMutableArray arrayWithArray:workers];
    
    if (count > referenceClassNames.count) {
        printf("类名不足\n需要替换类数量:%d 类名数量:%d\n",(int)count,(int)referenceClassNames.count);
        return;
    }
    
    
    
    NSArray * mainObjects = [NSArray arrayWithArray:objects];
    
    for (MixObject * mObject in mainObjects) {
        
        if (mObject.classFile.isAppDelegate) {
            continue;
        }
        
//        if (mObject.classFile.isCategory) {
//            continue;
//        }
        
        if (![MixMainStrategy fileLegal:mObject.classFile.classFileName]) {
            continue;
        }
        
        for (MixClass * mClass in mObject.hClasses) {
            NSInteger index = arc4random() % referenceClassNames.count;
            NSString * oldClassName = mClass.className;
            if (![MixMainStrategy legal:oldClassName]) {
                continue;
            }
            NSString * newClassName = referenceClassNames[index];
            [referenceClassNames removeObjectAtIndex:index];
            [MixMainStrategy reference:mainObjects oldName:oldClassName newName:newClassName];
            mClass.className = newClassName;
            
        }
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
            
            if ([MixMainStrategy isLegalWithFrontSymbol:frontSymbol backSymbol:backSymbol]) {
                NSString * front = [substitute substringToIndex:range.location];
                NSString * back = [substitute substringFromIndex:range.location + range.length];
                substitute = [NSString stringWithFormat:@"%@%@%@",front,newName,back];
                
            } else {
                if ([MixMainStrategy isLegalWithFrontSymbol:frontSymbol backSymbol:@" "]) {
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
                NSArray * lines = [front componentsSeparatedByString:@"\n"];
                printf("替换失败 文件:%s 原类:%s 新类:%s %d行\n",[fileName UTF8String] ,[oldName UTF8String],[newName UTF8String], (int)lines.count);
                
            }
        }
    }
    
    NSString * substituteCopy = [substitute stringByReplacingOccurrencesOfString:@"######&&&&&&$$$$$******" withString:oldName];
    substitute = substituteCopy;
    
    
    return substitute;
}

+ (BOOL)isLegalWithFrontSymbol:(NSString *)frontSymbol backSymbol:(NSString *)backSymbol {
    BOOL isLegal = NO;
    if ([MixJudgeStrategy isLegalClassFrontSymbol:frontSymbol] && [MixJudgeStrategy isLegalClassFrontSymbol:backSymbol]) {
        isLegal = YES;
    }
    return isLegal;
}


+ (void)reference:(NSArray <MixObject *>*)objects oldName:(NSString*)oldName newName:(NSString *)newName {
    
    for (MixObject * object in objects) {
        NSString * hData = [MixMainStrategy referenceData:object.classFile.hFile.data oldName:oldName newName:newName fileName:object.classFile.hFile.fileName];
        if (![object.classFile.hFile.data isEqualToString:hData]) {
            object.classFile.hFile.data = hData;
            [MixFileStrategy writeFileAtPath:object.classFile.hFile.path content:hData];
        }
        
        
        if (object.classFile.mFile) {
            NSString * mData = [MixMainStrategy referenceData:object.classFile.mFile.data oldName:oldName newName:newName fileName:object.classFile.mFile.fileName];
            if (![object.classFile.mFile.data isEqualToString:mData]) {
                object.classFile.mFile.data = mData;
                [MixFileStrategy writeFileAtPath:object.classFile.mFile.path content:mData];
            }
            
        }
    }
    
    
}

@end
