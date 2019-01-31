//
//  MixCategoryStrategy.m
//  CJMix
//
//  Created by wangshiwen on 2019/1/29.
//  Copyright © 2019 Chan. All rights reserved.
//

#import "MixYAHCategoryStrategy.h"
#import "MixConfig.h"
#import "MixFileStrategy.h"

#import "MixDefine.h"

@interface MixYAHCategoryStrategy ()

@property (nonatomic, strong) NSMutableArray<NSString *> *resetCategoryList;

@end

@implementation MixYAHCategoryStrategy

+ (instancetype)shareInstance {
    static MixYAHCategoryStrategy *strategy;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        strategy = [[MixYAHCategoryStrategy alloc] init];
    });
    return strategy;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _resetDict = [NSMutableDictionary dictionaryWithCapacity:1];
        [self initResetCategoryData];
    }
    return self;
}

#pragma mark - Public

- (BOOL)start {
    
    BOOL result = [self findOldCategory];
    
    result = [self replaceCategoryQuote];
    
    return result;
}

- (NSString *)getNewCategoryNameWithOld:(NSString *)old {
    
    NSString *newCategoryName = self.resetDict[old];
    if (!newCategoryName) {
        newCategoryName = @"AudioRoom";
    }
    return newCategoryName;
}

#pragma mark - Private

- (BOOL)initResetCategoryData {
    
//    NSString *path = @"/Users/wangsw/CJMix/Reference/cache/category.json";
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    if (data) {
//        NSError *error = nil;
//        id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//        if ([result isKindOfClass:NSArray.class]) {
//            _resetCategoryList = [NSMutableArray arrayWithArray:result];
//        }
//    }
    if (!_resetCategoryList) {
        _resetCategoryList = [[NSMutableArray alloc] initWithCapacity:1];
        [self recursiveFile:[MixConfig sharedSingleton].referenceAllFile resetList:_resetCategoryList];
    }
    
    //保存到json文件中
//    NSData *data=[NSJSONSerialization dataWithJSONObject:_resetCategoryList options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    [jsonStr writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
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
                if (![list containsObject:curStr]) {
                    [list addObject:curStr];
                }
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
                //替换新protocol
                NSString *resetCategory = self.resetDict[curStr]; //分类可重复
                if (!resetCategory) {
                    resetCategory = self.resetCategoryList.firstObject;;
                }
                if (!resetCategory) {
                    MixLog(@"新的Category个数不足,无法替换完全\n");
                    return;
                }
                tmpString = [lineString stringByReplacingOccurrencesOfString:curStr withString:resetCategory];
                [tmpList replaceObjectAtIndex:index withObject:tmpString];
                
                //保存数据
                [self.resetCategoryList removeObjectAtIndex:0];
                [self.resetDict setObject:resetCategory forKey:curStr];
            }
            string = [tmpList componentsJoinedByString:@"\n"];
            if (![string isEqualToString:file.data]) { //保存
                file.data = string;
                [MixFileStrategy writeFileAtPath:file.path content:file.data];
            }
        }
    }
}

//替换protocol的使用
- (BOOL)replaceCategoryQuote {
    
    [self recursiveReplaceCategoryWithFiles:[MixConfig sharedSingleton].allFile];
    
    return YES;
}

- (void)recursiveReplaceCategoryWithFiles:(NSArray *)files {
    
    NSMutableDictionary *dict = self.resetDict;
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
                    NSString *removeSpaceString = [lineString stringByReplacingOccurrencesOfString:@" " withString:@""];
                    if (![removeSpaceString hasPrefix:@"@implementation"]) {
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
                    NSString *newCategory = dict[oldCategory];
                    NSString *resetCategory = newCategory; //分类可重复
                    if (resetCategory) {
                        tmpString = [lineString stringByReplacingOccurrencesOfString:curStr withString:resetCategory];
                        [tmpList replaceObjectAtIndex:index withObject:tmpString];
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

#warning 可以优化下名称
    if (file.fileType != MixFileTypeFolder) {
        return YES;
    }
    return NO;
}

@end
