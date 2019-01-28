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

@interface MixProtocolStrategy ()

@property (nonatomic, strong) NSMutableArray<NSString *> *resetProtocolList; //新的protocol名称
@property (nonatomic, strong) NSArray *oldProtocolList;
@property (nonatomic, strong) NSMutableArray<MixFile *> *handleFileList; //需要处理的文件列表

@end

@implementation MixProtocolStrategy

+ (BOOL)start {
    
    MixProtocolStrategy *strategy = [MixProtocolStrategy new];
    BOOL result = [strategy initResetProtocolData];
    if (!result) {
        printf("初始化ResetProtocolData数据失败\n");
        return NO;
    }
    result = [strategy findOldProtocol];
    if (!result) {
        printf("查找旧Protocol失败\n");
        return NO;
    }
    result = [strategy replaceProtocol];
    if (!result) {
        printf("替换Protocol失败\n");
        return NO;
    }
    
    
    return YES;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _handleFileList = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

#pragma mark - Private

- (BOOL)initResetProtocolData {
    
    _resetProtocolList = [[NSMutableArray alloc] initWithCapacity:1];
    
#warning test
    [_resetProtocolList addObject:@"resetDelegate"];
    [_resetProtocolList addObject:@"reset2Delegate"];
    
    return YES;
}

//查好旧的protocol
- (BOOL)findOldProtocol {
    
    NSMutableArray *oldList = [NSMutableArray arrayWithCapacity:1];
    [self recursiveFile:[MixConfig sharedSingleton].allFile list:oldList];
    self.oldProtocolList = [oldList copy];
    
    if (self.oldProtocolList.count == 0) {
        printf("未找到Protocol");
        return NO;
    }
    return YES;
}

- (void)recursiveFile:(NSArray *)files list:(NSMutableArray<NSString *> *)list {
    
    for (MixFile *file in files) {
        if (file.subFiles.count>0) {
            [self recursiveFile:file.subFiles list:list];
        }else if (file.fileType == MixFileTypeH ||
            file.fileType == MixFileTypeM ||
            file.fileType == MixFileTypeMM ||
            file.fileType == MixFileTypePch) {
            
            //加入到处理列表中，减少for循环
            [self.handleFileList addObject:file];
            
            NSString *string = file.data;
            NSArray *lineList = [string componentsSeparatedByString:@"\n"];
            for (NSInteger index =0; index<lineList.count; index++) {
                NSString *lineString = lineList[index];
                if (![lineString containsString:@"@protocol"]) {
                    continue;
                }
                //去除空格
                lineString = [lineString stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSRange curRange = [lineString rangeOfString:@"(?<=@protocol).*(?=<)" options:NSRegularExpressionSearch];
                if (curRange.location == NSNotFound)
                    continue;
                NSString *curStr = [lineString substringWithRange:curRange];
                [list addObject:curStr];
            }
        }
    }
}

- (BOOL)replaceProtocol {
    
    if (self.resetProtocolList.count < self.oldProtocolList.count) {
        printf("新的protocol个数不足\n");
        return NO;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    for (NSInteger index=0; index<self.oldProtocolList.count; index++) {
        NSString *oldProtocol = self.oldProtocolList[index];
        NSString *resetProtocol = self.resetProtocolList[index];
        [dict setObject:resetProtocol forKey:oldProtocol];
    }
    
    //遍历文件列表
    for (MixFile *file in self.handleFileList) {
        //
        NSString *string = file.data;
        if (!string || string.length == 0) {
            continue;
        }
        NSArray *lineList = [string componentsSeparatedByString:@"\n"];
        NSMutableArray *tmpList = [NSMutableArray arrayWithArray:lineList];
        for (NSInteger index =0; index<lineList.count; index++) {
            NSString *lineString = lineList[index];
            NSString *tmpString = nil;
            for (NSString *oldProtocol in dict) {
                NSString *newProtocol = dict[oldProtocol];
                //简单的判断
                if (![lineString containsString:oldProtocol]) {
                    continue;
                }
                //去空格处理
                NSString *removeSpaceString = [lineString stringByReplacingOccurrencesOfString:@" " withString:@""];
                //第一种  id<xxDelagate>   一行只有一个delegaye
                if ([removeSpaceString containsString:[NSString stringWithFormat:@"id<%@>", oldProtocol]]) {
                    tmpString = [lineString stringByReplacingOccurrencesOfString:oldProtocol withString:newProtocol];
                }
                //第二种 跟在类申明后面的   <xxDelegate1,xxDelegate2>
                NSArray *delegateList = [removeSpaceString componentsSeparatedByString:@","];
                for (NSString *sub in delegateList) {
                    NSString *delegateString = [sub stringByReplacingOccurrencesOfString:@"<" withString:@""];
                    delegateString = [delegateString stringByReplacingOccurrencesOfString:@"<" withString:@">"];
                    if ([delegateString isEqualToString:oldProtocol]) {
                        tmpString = [lineString stringByReplacingOccurrencesOfString:oldProtocol withString:newProtocol];
                    }
                }
                
            }
            if (tmpString && ![tmpString isEqualToString:lineString]) {
                [tmpList replaceObjectAtIndex:index withObject:tmpString];
            }
        }
        
        string = [tmpList componentsJoinedByString:@"\n"];
        if (![string isEqualToString:file.data]) {
            file.data = string;
            [MixFileStrategy writeFileAtPath:file.path content:file.data];
        }
    }
    
    return YES;
}

@end
