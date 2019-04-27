//
//  MixProtocolStrategy.m
//  CJMix
//
//  Created by wangshiwen on 2019/1/28.
//  Copyright © 2019 Chan. All rights reserved.
//

#import "MixProtocolStrategy.h"
#import "MixConfig.h"
#import "MixFileStrategy.h"
#import "MixDefine.h"
#import "MixCacheStrategy.h"

@interface MixProtocolStrategy ()

@property (nonatomic, strong) NSArray<NSString *> *legalProtocolFrontSymbols;
@property (nonatomic, strong) NSArray<NSString *> *legalProtocolBackSymbols;
@property (nonatomic, strong) NSMutableArray<NSString *> *resetProtocolList; //新的protocol名称

@end

@implementation MixProtocolStrategy

+ (BOOL)start {
    
    MixProtocolStrategy *strategy = [[MixProtocolStrategy alloc] init];
    BOOL result = [strategy initResetProtocolData];
    if (!result) {
        MixLog(@"初始化ResetProtocolData数据失败\n");
        return NO;
    }
    result = [strategy findOldProtocol];
    if (!result) {
        MixLog(@"查找旧Protocol失败\n");
        return NO;
    }
    result = [strategy replaceProtocolQuote];
    if (!result) {
        MixLog(@"替换Protocol失败\n");
        return NO;
    }
    
    
    return YES;
}

#pragma mark - Private

#pragma mark - 初始化新的protocol名称列表
- (BOOL)initResetProtocolData {
    
    if (!_resetProtocolList) {
        _resetProtocolList = [[NSMutableArray alloc] initWithCapacity:1];
        [self recursiveFile:[MixConfig sharedSingleton].referenceAllFile resetList:_resetProtocolList];
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
            NSArray *lineList = [string componentsSeparatedByString:@"\n"];
            for (NSInteger index =0; index<lineList.count; index++) {
                NSString *lineString = lineList[index];
                NSString *tmpString = [lineString copy];
                if (![lineString containsString:@"@protocol"]) {
                    continue;
                }
                //去除空格
                tmpString = [lineString stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSRange curRange = [tmpString rangeOfString:@"(?<=@protocol).*(?=<)" options:NSRegularExpressionSearch];
                if (curRange.location == NSNotFound)
                    continue;
                NSString *curStr = [NSString stringWithFormat:@"%@%@",  [MixConfig sharedSingleton].mixPrefix, [tmpString substringWithRange:curRange]];
                if ([list containsObject:curStr]) {
                    continue;
                }
                //缓存是否已存在，是否已被缓存使用了
                BOOL isUse = NO;
                for (NSString *key in [MixCacheStrategy sharedSingleton].mixProtocolCache) {
                    if ([[[MixCacheStrategy sharedSingleton].mixProtocolCache objectForKey:key] isEqualToString:curStr]) {
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

#pragma mark - 对旧的protocol名称进行处理

//查好旧的protocol
- (BOOL)findOldProtocol {
    
    [self recursiveFile:[MixConfig sharedSingleton].allFile];
    
    return YES;
}

- (void)recursiveFile:(NSArray *)files {
    
    for (MixFile *file in files) {
        if (file.subFiles.count>0) {
            if (![self checkIsWhiteFolder:file]) {
                [self recursiveFile:file.subFiles];
            }
        }else if (file.fileType == MixFileTypeH ||
            file.fileType == MixFileTypeM ||
            file.fileType == MixFileTypeMM ||
            file.fileType == MixFileTypePch) {
            
            NSString *string = file.data;
            
            if (![string containsString:@"@protocol"]) {//可过滤大部分文件
                continue;
            }
            
            NSArray *lineList = [string componentsSeparatedByString:@"\n"];
            NSMutableArray *tmpList = [NSMutableArray arrayWithArray:lineList];
            for (NSInteger index =0; index<lineList.count; index++) {
                NSString *lineString = lineList[index];
                NSString *tmpString = [lineString copy];
                //去除空格
                tmpString = [lineString stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSRange curRange = [tmpString rangeOfString:@"(?<=@protocol).*(?=<)" options:NSRegularExpressionSearch];
                if (curRange.location == NSNotFound)
                    continue;
                NSString *curStr = [tmpString substringWithRange:curRange];
                //----替换新protocol
                //一个项目里可能有两个一样的protocol
                NSString *resetProtocol = [[MixCacheStrategy sharedSingleton].mixProtocolCache objectForKey:curStr];
                if (!resetProtocol) {
                    //取新的protocol
                    resetProtocol = self.resetProtocolList.firstObject;
                    if (!resetProtocol) {
                        MixLog(@"新的protocol个数不足,无法替换完全\n");
                        return;
                    }
                    //移除已有
                    [self.resetProtocolList removeObjectAtIndex:0];
                    
                    //保存数据
                    [[MixCacheStrategy sharedSingleton].mixProtocolCache setObject:resetProtocol forKey:curStr];
                }
                //数据替换
                tmpString = [lineString stringByReplacingOccurrencesOfString:curStr withString:resetProtocol];
                [tmpList replaceObjectAtIndex:index withObject:tmpString];
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
- (BOOL)replaceProtocolQuote {
    
    [self recursiveReplaceProtocolWithFiles:[MixConfig sharedSingleton].allFile];
    
    return YES;
}

- (void)recursiveReplaceProtocolWithFiles:(NSArray *)files {
    
    NSMutableDictionary *dict = [MixCacheStrategy sharedSingleton].mixProtocolCache;
    //遍历文件列表
    for (MixFile *file in files) {
        if (file.subFiles.count>0) {
            [self recursiveReplaceProtocolWithFiles:file.subFiles];
        }else if (file.fileType == MixFileTypeH ||
                  file.fileType == MixFileTypeM ||
                  file.fileType == MixFileTypeMM ||
                  file.fileType == MixFileTypePch) {
            //
            NSString *string = file.data;
            
            //简单的过滤
            NSMutableDictionary *findDict = [NSMutableDictionary dictionaryWithCapacity:1];
            for (NSString *oldProtocol in dict) {
                if ([string containsString:oldProtocol]) {
                    [findDict setObject:dict[oldProtocol] forKey:oldProtocol];
                }
            }
            if (findDict.count==0) {
                continue;
            }
            
            for (NSString *oldProtocol in findDict) {
                NSArray *divisions = [string componentsSeparatedByString:oldProtocol];
                NSInteger location = 0;
                for (NSInteger i=0 ; i<divisions.count; i++) {
                    if (i==divisions.count-1) {//最后一个不做处理
                        break;
                    }
                    NSString *frontString = divisions[i];
                    NSString *backString = divisions[i+1];
                    //第一个字符
                    NSString * frontSymbol = @"";
                    if (frontString.length>0) {
                        frontSymbol = [frontString substringFromIndex:frontString.length-1];
                    }
                    NSString * backSymbol = @"";
                    if (backString.length>0) {
                        backSymbol = [backString substringWithRange:NSMakeRange(0, 1)];
                    }
                    location += frontString.length;
                    if ([self isValidFront:frontSymbol] && [self isValidBack:backSymbol]) {
                        //替换
                        NSString *newProtocol = findDict[oldProtocol];
                        string = [string stringByReplacingCharactersInRange:NSMakeRange(location, oldProtocol.length) withString:newProtocol];
                        location += newProtocol.length;
                    }else {
                        location += oldProtocol.length;
                    }
                }
            }
            if (![string isEqualToString:file.data]) {
                file.data = string;
                [MixFileStrategy writeFileAtPath:file.path content:file.data];
            }
        }
    }
}

- (BOOL)checkIsWhiteFolder:(MixFile *)file {
    
    for (NSString *folder in [MixConfig sharedSingleton].shieldPaths) {
        if (file.subFiles>0 && [folder isEqualToString:file.fileName]) {
            return YES;
        }
    }

    if (file.fileType != MixFileTypeFolder) {
        return YES;
    }
    return NO;
}

#pragma mark - Private

- (BOOL)isValidFront:(NSString *)front {
    
    return [self.legalProtocolFrontSymbols containsObject:front];
}

- (BOOL)isValidBack:(NSString *)back {
    
    return [self.legalProtocolBackSymbols containsObject:back];
}

- (NSArray <NSString *>*)legalProtocolFrontSymbols {
    
    if (!_legalProtocolFrontSymbols) {
        _legalProtocolFrontSymbols = @[@"",@" ",@"\n",@"(",@"<",@","];
    }
    return _legalProtocolFrontSymbols;
}

- (NSArray <NSString *>*)legalProtocolBackSymbols {
    if (!_legalProtocolBackSymbols) {
        _legalProtocolBackSymbols = @[@"",@" ",@"\n",@")",@">",@",",@";"];
    }
    return _legalProtocolBackSymbols;
}

@end
