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

@implementation MixMainStrategy

+ (void)replaceMethod:(NSArray <MixObject *>*)objects methods:(NSArray <NSString *>*)methods {
    
    
    
}

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
        
        if ([MixJudgeStrategy isLikeCategory:object.classFile.classFileName]) {
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
        NSInteger index = arc4random() % newNmaes.count;
        NSString * oldClassName = class.className;
        if ([MixJudgeStrategy isSystemClass:oldClassName]) {
            continue;
        }
        NSString * newClassName = newNmaes[index];
        [newNmaes removeObjectAtIndex:index];
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
                NSArray * lines = [front componentsSeparatedByString:@"\n"];
                printf("替换失败 文件:%s 原类:%s 新类:%s %d行\n",[fileName UTF8String] ,[oldName UTF8String],[newName UTF8String], (int)lines.count);
                
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
        
        [MixMainStrategy referenceDataAndWrite:object.classFile.hFile oldName:oldName newName:newName];
        [MixMainStrategy referenceDataAndWrite:object.classFile.mFile oldName:oldName newName:newName];
        
    }
}






@end
