//
//  MixCategoryStrategy.m
//  CJMix
//
//  Created by wangshiwen on 2019/1/29.
//  Copyright © 2019 Chan. All rights reserved.
//

#import "MixCategoryStrategy.h"
#import "MixConfig.h"
#import "MixFileStrategy.h"

#import "MixDefine.h"
#import "MixCacheStrategy.h"

@interface MixCategoryStrategy ()

@property (nonatomic, strong) NSMutableArray<NSString *> *resetCategoryList;

@end

@implementation MixCategoryStrategy

+ (instancetype)shareInstance {
    static MixCategoryStrategy *strategy;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        strategy = [[MixCategoryStrategy alloc] init];
    });
    return strategy;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initResetCategoryData];
    }
    return self;
}

#pragma mark - Public

+ (BOOL)start {
    
    MixCategoryStrategy *strategy = [[MixCategoryStrategy alloc] init];
    BOOL result = [strategy findOldCategory];
    
    result = [strategy replaceCategoryQuote];
    
    return result;
}


#pragma mark - Private

- (BOOL)initResetCategoryData {

    if (!_resetCategoryList) {
        _resetCategoryList = [[NSMutableArray alloc] initWithCapacity:1];
        [self recursiveFile:[MixConfig sharedSingleton].referenceAllFile resetList:_resetCategoryList];
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
            
            NSString *string = file.data;
            
            if (![string containsString:@"@interface"]) {//
                continue;
            }
            
            NSArray *lineList = [string componentsSeparatedByString:@"\n"];
            for (NSInteger index =0; index<lineList.count; index++) {
                NSString *lineString = lineList[index];
                NSString *tmpString = [lineString copy];
                //去除空格
                tmpString = [lineString stringByReplacingOccurrencesOfString:@" " withString:@""];
                if (![tmpString hasPrefix:@"@interface"]) {
                    continue;
                }
                NSRange curRange = [tmpString rangeOfString:@"(?<=\\().*(?=\\))" options:NSRegularExpressionSearch];
                if (curRange.location == NSNotFound)
                    continue;
                NSString *curStr = [tmpString substringWithRange:curRange];
                if (curStr.length==0) {
                    continue;
                }
                curStr = [NSString stringWithFormat:@"%@%@", [MixConfig sharedSingleton].mixPrefix, curStr];
                
                if ([list containsObject:curStr]) {
                    continue;
                }
                //缓存是否已存在，是否已被缓存使用了
                BOOL isUse = NO;
                for (NSString *key in [MixCacheStrategy sharedSingleton].mixProtocolCache) {
                    if ([[[MixCacheStrategy sharedSingleton].mixCategoryCache objectForKey:key] isEqualToString:curStr]) {
                        isUse = YES;
                        break;
                    }
                }
                if (isUse) {
                    continue;
                }
                [list addObject:curStr];
            }
        }
    }
}

- (BOOL)findOldCategory {
    
    [self recursiveFindOldCategoryFile:[MixConfig sharedSingleton].allFile];
    
    return YES;
}

- (void)recursiveFindOldCategoryFile:(NSArray *)files {
    
    for (MixFile *file in files) {
        if (file.subFiles.count>0) {
            if (![self checkIsWhiteFolder:file]) {
                [self recursiveFindOldCategoryFile:file.subFiles];
            }
        }else if (file.fileType == MixFileTypeH ||
                  file.fileType == MixFileTypeM ||
                  file.fileType == MixFileTypeMM ||
                  file.fileType == MixFileTypePch) {
            
            NSString *string = file.data;
            
            if (![string containsString:@"@interface"]) {//
                continue;
            }
            
            NSArray *lineList = [string componentsSeparatedByString:@"\n"];
            NSMutableArray *tmpList = [NSMutableArray arrayWithArray:lineList];
            for (NSInteger index =0; index<lineList.count; index++) {
                NSString *lineString = lineList[index];
                NSString *tmpString = [lineString copy];
                //去除空格
                if (![[lineString stringByReplacingOccurrencesOfString:@" " withString:@""] hasPrefix:@"@interface"]) {
                    continue;
                }
                NSRange curRange = [tmpString rangeOfString:@"(?<=\\().*(?=\\))" options:NSRegularExpressionSearch];
                if (curRange.location == NSNotFound)
                    continue;
                NSString *curStr = [tmpString substringWithRange:curRange];
                if (curStr.length==0) {
                    continue;
                }
                //替换新protocol
                NSString *resetCategory = [MixCacheStrategy sharedSingleton].mixCategoryCache[curStr]; //分类可重复
                if (!resetCategory) {
                    if (self.resetCategoryList.count>0) {
                        resetCategory = self.resetCategoryList[0];
                        [self.resetCategoryList removeObjectAtIndex:0];
                    }
                }
                if (!resetCategory) {
                    MixLog(@"新的Category个数不足,无法替换完全\n");
                    continue;
                }
                tmpString = [lineString stringByReplacingCharactersInRange:curRange withString:resetCategory];
                [tmpList replaceObjectAtIndex:index withObject:tmpString];
                
                //保存数据
                [[MixCacheStrategy sharedSingleton].mixCategoryCache setObject:resetCategory forKey:curStr];
            }
            string = [tmpList componentsJoinedByString:@"\n"];
            if (![string isEqualToString:file.data]) { //保存
                file.data = string;
                [MixFileStrategy writeFileAtPath:file.path content:file.data];
            }
        }
    }
}

//替换Category的使用
- (BOOL)replaceCategoryQuote {
    
    [self recursiveReplaceCategoryWithFiles:[MixConfig sharedSingleton].allFile];
    
    return YES;
}

- (void)recursiveReplaceCategoryWithFiles:(NSArray *)files {
    
    NSMutableDictionary *dict = [MixCacheStrategy sharedSingleton].mixCategoryCache;
    //遍历文件列表
    for (MixFile *file in files) {
        if (file.subFiles.count>0) {
            [self recursiveReplaceCategoryWithFiles:file.subFiles];
        }else if (file.fileType == MixFileTypeH ||
                  file.fileType == MixFileTypeM ||
                  file.fileType == MixFileTypeMM ||
                  file.fileType == MixFileTypePch) {
            //
            NSString *string = file.data;
            
            //简单的过滤
            NSMutableDictionary *findDict = [NSMutableDictionary dictionaryWithCapacity:1];
            for (NSString *oldCategory in dict) {
                if ([string containsString:oldCategory]) {
                    [findDict setObject:dict[oldCategory] forKey:oldCategory];
                }
            }
            if (findDict.count==0) {
                continue;
            }
            
            NSArray *lineList = [string componentsSeparatedByString:@"\n"];
            NSMutableArray *tmpList = [NSMutableArray arrayWithArray:lineList];
            for (NSInteger index =0; index<lineList.count; index++) {
                NSString *lineString = lineList[index];
                NSString *tmpString = [lineString copy];
                for (NSString *oldCategory in findDict) {
                    //简单的判断
                    if (![lineString containsString:oldCategory]) {
                        continue;
                    }
                    //去空格处理
                    if (![[lineString stringByReplacingOccurrencesOfString:@" " withString:@""] hasPrefix:@"@implementation"]) {
                        continue;
                    }
                    
                    NSRange curRange = [tmpString rangeOfString:@"(?<=\\().*(?=\\))" options:NSRegularExpressionSearch];
                    if (curRange.location == NSNotFound)
                        continue;
                    NSString *curStr = [tmpString substringWithRange:curRange];
                    if (curStr.length==0) {
                        continue;
                    }
                    //替换新protocol
                    NSString *newCategory = findDict[curStr];
                    if (newCategory) {
                        tmpString = [lineString stringByReplacingCharactersInRange:curRange withString:newCategory];
                        [tmpList replaceObjectAtIndex:index withObject:tmpString];
                        break;
                    }
                }
            }
            string = [tmpList componentsJoinedByString:@"\n"];
            if (![string isEqualToString:file.data]) {
                file.data = string;
                [MixFileStrategy writeFileAtPath:file.path content:file.data];
            }
        }
    }
}

- (BOOL)checkIsWhiteFolder:(MixFile *)file {

    if (file.fileType != MixFileTypeFolder) {
        return YES;
    }
    return NO;
}

@end
