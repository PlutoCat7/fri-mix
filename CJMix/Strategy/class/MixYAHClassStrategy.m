//
//  MixYAHClassStrategy.m
//  CJMix
//
//  Created by wangshiwen on 2019/3/17.
//  Copyright © 2019 Chan. All rights reserved.
//

#import "MixYAHClassStrategy.h"
#import "MixJudgeStrategy.h"
#import "MixStringStrategy.h"
#import "MixConfig.h"
#import "MixCacheStrategy.h"
#import "MixFileStrategy.h"
#import "MixDefine.h"

@interface MixYAHClassStrategy ()

@property (nonatomic, strong) NSArray<NSString *> *legalClassFrontSymbols;
@property (nonatomic, strong) NSArray<NSString *> *legalClassBackSymbols;
@property (nonatomic, strong) NSMutableArray<NSString *> *resetClassList; //新的protocol名称

@end

@implementation MixYAHClassStrategy

+ (BOOL)start {
    
    MixYAHClassStrategy *strategy = [[MixYAHClassStrategy alloc] init];
    BOOL result = [strategy initResetClassData];
    if (!result) {
        MixLog(@"初始化initResetClassData数据失败\n");
        return NO;
    }
    result = [strategy findOldClass];
    if (!result) {
        MixLog(@"查找旧Class失败\n");
        return NO;
    }
    result = [strategy replaceClassQuote];
    if (!result) {
        MixLog(@"替换Class失败\n");
        return NO;
    }
    
    
    return YES;
}

#pragma mark - Private

#pragma mark - 初始化新的Class名称列表
- (BOOL)initResetClassData {
    
    if (!_resetClassList) {
        _resetClassList = [[NSMutableArray alloc] initWithCapacity:1];
        [self recursiveFile:[MixConfig sharedSingleton].referenceAllFile resetList:_resetClassList];
    }
    
    return YES;
}

- (void)recursiveFile:(NSArray *)files resetList:(NSMutableArray *)list {
    
    for (MixFile *file in files) {
        if (file.subFiles.count>0) {
            [self recursiveFile:file.subFiles resetList:list];
        }else if (file.fileType == MixFileTypeH ||
                  file.fileType == MixFileTypeM ||
                  file.fileType == MixFileTypeMM ||
                  file.fileType == MixFileTypePch) {
            
            NSArray *classNameList = [self dataToClassName:file.data];
            for (NSString *className in classNameList) {
                NSString *mixClassName = [NSString stringWithFormat:@"%@%@",[MixConfig sharedSingleton].mixPrefix, className];
                if (![list containsObject:mixClassName]) {
                    [list addObject:mixClassName];
                }
            }
        }
    }
}

#pragma mark - 对旧的Class名称进行处理

//查好旧的protocol
- (BOOL)findOldClass {
    
    [self recursiveFile:[MixConfig sharedSingleton].allFile];
    
    return YES;
}

- (void)recursiveFile:(NSArray *)files {
    
    for (MixFile *file in files) {
        if (![self checkIsWhiteFile:file]) {
            if (file.subFiles.count>0) {
                [self recursiveFile:file.subFiles];
            }else if (file.fileType == MixFileTypeH ||
                      file.fileType == MixFileTypeM ||
                      file.fileType == MixFileTypeMM ||
                      file.fileType == MixFileTypePch) {
                NSArray<NSString *> *classNames = [self dataToClassName:file.data];
                for (NSString *oldClassName in classNames) {
                    if ([[MixConfig sharedSingleton].shieldClass containsObject:oldClassName]) {
                        continue;
                    }
                    NSString *newClassName = [[MixCacheStrategy sharedSingleton].mixClassCache objectForKey:oldClassName];
                    if (!newClassName) {
                        newClassName = [self getNewClassName];
                        if (!newClassName) {
                            MixLog(@"新的ClassName个数不足,无法替换完全\n");
                            return;
                        }
                    }
                    //保存数据
                    [[MixCacheStrategy sharedSingleton].mixClassCache setObject:newClassName forKey:oldClassName];
                }
            }
        }
    }
}

- (NSString *)getNewClassName {
    NSString * newClassName = self.resetClassList.firstObject;
    if (!newClassName) {
        return nil;
    }
    [self.resetClassList removeObjectAtIndex:0];
    if ([[MixCacheStrategy sharedSingleton].mixClassCache.allValues containsObject:newClassName]) {  //防止重复
        return [self getNewClassName];
    }
    return newClassName;
}

- (BOOL)replaceClassQuote {
    
    [self recursiveReplaceClassWithFiles:[MixConfig sharedSingleton].allFile];
    
    return YES;
}

- (void)recursiveReplaceClassWithFiles:(NSArray *)files {
    
    NSMutableDictionary *dict = [MixCacheStrategy sharedSingleton].mixClassCache;
    //遍历文件列表
    for (MixFile *file in files) {
        @autoreleasepool {
            if (file.subFiles.count>0) {
                [self recursiveReplaceClassWithFiles:file.subFiles];
            }else if (file.fileType == MixFileTypeH ||
                      file.fileType == MixFileTypeM ||
                      file.fileType == MixFileTypeMM ||
                      file.fileType == MixFileTypePch) {
                NSString *string = file.data;
                //import的不替换
                NSArray *tmpList = [string componentsSeparatedByString:@"#import"];
                string = tmpList.lastObject;
                tmpList = [string componentsSeparatedByString:@"\n"];
                NSString *headerString = @"";
                if (tmpList.count>0) {
                    NSString *text =  tmpList.firstObject;
                    NSRange range = [file.data rangeOfString:text];
                    headerString = [file.data substringWithRange:NSMakeRange(0, range.location+range.length)];
                    headerString = [NSString stringWithFormat:@"%@\n", headerString];
                    
                    NSMutableArray *mut = [NSMutableArray arrayWithArray:tmpList];
                    [mut removeObjectAtIndex:0];
                    string = [mut componentsJoinedByString:@"\n"];
                }
                //简单的过滤
                NSMutableDictionary *findDict = [NSMutableDictionary dictionaryWithCapacity:1];
                for (NSString *old in dict) {
                    if ([string containsString:old]) {
                        [findDict setObject:dict[old] forKey:old];
                    }
                }
                if (findDict.count==0) {
                    continue;
                }
                for (NSString *oldClassName in findDict) {
                    NSArray *divisions = [string componentsSeparatedByString:oldClassName];
                    NSInteger location = 0;
                    for (NSInteger i=0 ; i<divisions.count; i++) {
                        if (i==divisions.count-1) {//最后一个不做处理
                            break;
                        }
                        NSString *frontString = divisions[i];
                        NSString *backString = divisions[i+1];
                        //第一个字符
                        NSString *frontSymbol = @"";
                        if (frontString.length>0) {
                            frontSymbol = [frontString substringFromIndex:frontString.length-1];
                        }
                        NSString *backSymbol = @"";
                        if (backString.length>0) {
                            backSymbol = [backString substringWithRange:NSMakeRange(0, 1)];
                        }
                        location += frontString.length;
                        if ([self isValidFront:frontSymbol] && [self isValidBack:backSymbol]) {
                            //替换
                            NSString *newClassName = findDict[oldClassName];
                            string = [string stringByReplacingCharactersInRange:NSMakeRange(location, oldClassName.length) withString:newClassName];
                            location += newClassName.length;
                        }else {
                            location += oldClassName.length;
                        }
                    }
                }
                string = [NSString stringWithFormat:@"%@%@", headerString, string];
                if (![string isEqualToString:file.data]) {
                    file.data = string;
                    [MixFileStrategy writeFileAtPath:file.path content:file.data];
                }
            }
        }
    }
}

- (BOOL)checkIsWhiteFile:(MixFile *)file {
    
    if (file.fileType == MixFileTypeShield) {//白名单
        return YES;
    }
    if (file.fileType == MixFileTypeH ||
        file.fileType == MixFileTypeM ||
        file.fileType == MixFileTypeMM ||
        file.fileType == MixFileTypePch) {
        for (NSString *folder in [MixConfig sharedSingleton].shieldClass) {
            if ([folder isEqualToString:[file.fileName componentsSeparatedByString:@"."].firstObject]) {
                return YES;
            }
        }
    }
    return NO;
}

#pragma mark - Prvate
//查找类
- (NSArray <NSString *>*)dataToClassName:(NSString *)data {
    
    __block NSMutableArray <NSString *>* classNames = [NSMutableArray arrayWithCapacity:0];
    NSArray <NSString *>* classes = [data componentsSeparatedByString:@"@interface"];
    if (classes.count > 1) {
        [classes enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //第一个不要
            if (idx != 0 && [obj containsString:@":"]) {
                NSArray <NSString *>* strs = [obj componentsSeparatedByString:@":"];
                NSString *classStr = nil;
                if (strs.count) {
                    NSString * temp = strs[0];
                    NSString * replacing = [temp stringByReplacingOccurrencesOfString:@" " withString:@""];
                    if ([MixStringStrategy isAlphaNumUnderline:replacing]) {
                        classStr = replacing;
                    }
                }
                if (classStr && ![MixJudgeStrategy isSystemClass:classStr]) {
                    [classNames addObject:classStr];
                }
            }
        }];
    }
    return classNames;
}

- (BOOL)isValidFront:(NSString *)front {
    
    return [self.legalClassFrontSymbols containsObject:front];
}

- (BOOL)isValidBack:(NSString *)back {
    
    return [self.legalClassBackSymbols containsObject:back];
}

- (NSArray <NSString *>*)legalClassFrontSymbols {
    
    if (!_legalClassFrontSymbols) {
        _legalClassFrontSymbols = @[@"\t",@"",@" ",@",",@"(",@")",@"\n",@"[",@"<",@":",@"+",@"-",@"*",@"/",@"!",@"%",@"&",@"|",@":",@"?",@"=",@">"];
    }
    return _legalClassFrontSymbols;
}

- (NSArray <NSString *>*)legalClassBackSymbols {
    if (!_legalClassBackSymbols) {
        _legalClassBackSymbols = @[@" ",@"\n",@"(",@")",@"<",@"*",@";",@",",@":",@"{",@".",@""];
    }
    return _legalClassBackSymbols;
}


@end
