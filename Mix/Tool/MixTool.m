//
//  MixTool.m
//  CJMix
//
//  Created by wangsw on 2019/3/19.
//  Copyright © 2019 Chan. All rights reserved.
//

#import "MixTool.h"
#import "MixFileStrategy.h"


@implementation MixTool

+ (void)removeReferenceFileWithPath:(NSString *)referenceFileWithPath usedCachePath:(NSString *)usedCachePath {
    
    NSArray<MixFile *> *files = [self all_HM_File:[MixFileStrategy filesWithPath:referenceFileWithPath framework:NO]];
    NSDictionary * objects = [NSKeyedUnarchiver unarchiveObjectWithFile:usedCachePath];
    for (MixFile *file in files) {
        for (NSString *key in objects) {
            NSString *className = [objects objectForKey:key];
            if (className.length>2) {
                className = [className substringFromIndex:2];
            }
            if ([file.data containsString:className]) { //移除文件
                [[NSFileManager defaultManager] removeItemAtPath:file.path error:nil];
                break;
            }
        }
    }
}

+ (void)moveReferenceFileWithPath:(NSString *)referenceFileWithPath fromFilePath:(NSString *)fromFilePath {
    
    NSString *h_Path = [referenceFileWithPath stringByAppendingPathComponent:@"h"];
    NSString *m_Path = [referenceFileWithPath stringByAppendingPathComponent:@"m"];
    NSString *mm_Path = [referenceFileWithPath stringByAppendingPathComponent:@"mm"];
    NSArray<MixFile *> *files = [self all_HM_File:[MixFileStrategy filesWithPath:fromFilePath framework:NO]];
    for (MixFile *file in files) {
        NSString *toPath = nil;
        if (file.fileType == MixFileTypeH) {
            toPath = h_Path;
        }else if (file.fileType == MixFileTypeM) {
            toPath = m_Path;
        }else if (file.fileType == MixFileTypeMM) {
            toPath = mm_Path;
        }
        if (toPath) {
            toPath = [toPath stringByAppendingPathComponent:file.fileName];
            [MixFileStrategy copyItemAtPath:file.path toPath:toPath overwrite:YES error:nil];
        }
    }
}

+ (void)insertMixLocalizable:(NSString *)referenceFilePath toFilePath:(NSString *)toFilePath {
    
    NSArray *oldLines = [[NSString stringWithContentsOfFile:referenceFilePath encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByString:@"\n"];  //新增混淆的文件
    NSMutableArray *newLines = [NSMutableArray arrayWithArray:[[NSString stringWithContentsOfFile:toFilePath encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByString:@"\n"]];
    for (NSString *strint in oldLines) {
        
        NSString *insertString = [strint stringByReplacingOccurrencesOfString:@"؛" withString:@""]; //谷歌防御 阿语;反了
        insertString = [NSString stringWithFormat:@"%@;//**", insertString];
        //随机
        NSInteger insertIndex = arc4random()%newLines.count;
        [newLines insertObject:insertString atIndex:insertIndex];
    }
    NSString *string = [newLines componentsJoinedByString:@"\n"];
    BOOL isSuccess = [string writeToFile:toFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if (isSuccess) {
        NSLog(@"写入成功");
    }else {
        NSLog(@"写入失败");
    }
}

#pragma mark - Private

+ (NSArray<MixFile *> *)all_HM_File:(NSArray *)files {
    
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:1];
    [self recursiveFile:files resetList:list];
    return [list copy];
}

+ (void)recursiveFile:(NSArray *)files resetList:(NSMutableArray *)list {
    
    for (MixFile *file in files) {
        if (file.subFiles.count>0) {
            [self recursiveFile:file.subFiles resetList:list];
        }else if (file.fileType == MixFileTypeH ||
                  file.fileType == MixFileTypeM ||
                  file.fileType == MixFileTypeMM) {
            [list addObject:file];
        }
    }
}

@end
