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
#import "MixCategoryStrategy.h"

@implementation MixObjectStrategy

+ (NSArray <MixObject *>*)objectsWithPath:(NSString *)path saveConfig:(BOOL)saveConfig {
    //获取所有文件（包括文件夹）
    NSArray<MixFile *> *files = [MixFileStrategy filesWithPath:path];
#warning 先这么处理， 后期可在配置初始化
    if (saveConfig) { //
        [MixConfig sharedSingleton].allFile = files;
    }else {
        [MixConfig sharedSingleton].referenceAllFile = files;
    }
    
    
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
    return [MixCategoryStrategy integrateCategoryMethod:[MixObjectStrategy objectsWithPath:path saveConfig:NO]];
}

+ (NSArray <MixObject*>*)fileToObject:(NSArray <MixClassFile *>*)classFiles {
    NSMutableArray <MixObject*>* objects = [NSMutableArray arrayWithCapacity:0];
    
    [classFiles enumerateObjectsUsingBlock:^(MixClassFile * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MixObject * object = [[MixObject alloc] initWithClassFile:obj];
        [objects addObject:object];
    }];
    
    return objects;
}

+ (void)saveObjects:(NSArray <MixObject *>*)objects key:(NSString *)key {
    
    NSString *homeDictionary = NSHomeDirectory();
    NSString *homePath  = [homeDictionary stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",key]];
    [NSKeyedArchiver archiveRootObject:objects toFile:homePath];
    
}

+ (NSArray <MixObject *>*)objectsForKey:(NSString *)key {
    NSString *homeDictionary = NSHomeDirectory();
    NSString *homePath  = [homeDictionary stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",key]];
    NSArray <MixObject *>* objects = [NSKeyedUnarchiver unarchiveObjectWithFile:homePath];
    
    return objects;
    
}


@end
