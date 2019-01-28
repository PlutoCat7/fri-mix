//
//  MixObjectStrategy.m
//  Mix
//
//  Created by ChenJie on 2019/1/21.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import "MixObjectStrategy.h"
#import "MixFileStrategy.h"
#import "MixClassFileStrategy.h"
#import "../Config/MixConfig.h"

@implementation MixObjectStrategy

+ (NSArray <MixObject *>*)objectsWithPath:(NSString *)path saveConfig:(BOOL)saveConfig {
    //获取所有文件（包括文件夹）
    NSArray<MixFile *> *files = [MixFileStrategy filesWithPath:path];
    [MixConfig sharedSingleton].allFile = files;
    
    //取出所有.h .m文件
    NSArray<MixFile *> *hmFiles = [MixFileStrategy filesToHMFiles:files];
    
    if (saveConfig) {
        
        NSArray<MixFile *> *pchFiles = [MixFileStrategy filesToPCHFiles:files];
        [MixConfig sharedSingleton].pchFile = [NSArray arrayWithArray:pchFiles];
        
    }
    
    //合成完整类文件（需要完整的.h .m）
    NSArray <MixClassFile *> * classFiles = [MixClassFileStrategy filesToClassFiles:hmFiles];
    //拿到对象信息
    NSArray <MixObject*>* objects = [MixObjectStrategy fileToObject:classFiles];
    
    return objects;
}

+ (NSArray <MixObject *>*)objectsWithPath:(NSString *)path {
    return [MixObjectStrategy objectsWithPath:path saveConfig:NO];
}

+ (NSArray <MixObject*>*)fileToObject:(NSArray <MixClassFile *>*)classFiles {
    NSMutableArray <MixObject*>* objects = [NSMutableArray arrayWithCapacity:0];
    
    [classFiles enumerateObjectsUsingBlock:^(MixClassFile * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MixObject * object = [[MixObject alloc] initWithClassFile:obj];
        [objects addObject:object];
    }];
    
    return objects;
}

#pragma mark -

@end
