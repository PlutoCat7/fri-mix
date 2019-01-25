//
//  MixReferenceStrategy.m
//  Mix
//
//  Created by ChenJie on 2019/1/21.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import "MixReferenceStrategy.h"
#import "../Model/MixObject.h"
#import "../Model/MixFile.h"
#import "MixFileStrategy.h"
#import "MixClassFileStrategy.h"
#import "MixObjectStrategy.h"
#import "MixFilterStrategy.h"
#import "../Config/MixConfig.h"

@implementation MixReferenceStrategy

+ (NSMutableArray <NSString *> *)classNamesWithPath:(NSString *)path {
    NSMutableArray * classNames = [NSMutableArray arrayWithCapacity:0];
    NSArray<MixFile *> *files = [MixFileStrategy filesWithPath:path];
    NSArray<MixFile *> *hmFiles = [MixFileStrategy filesToHMFiles:files];
    NSArray <MixClassFile *> * classFiles = [MixClassFileStrategy filesToClassFiles:hmFiles];
    NSArray <MixObject*>* objects = [MixObjectStrategy fileToObject:classFiles];
    
    [objects enumerateObjectsUsingBlock:^(MixObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        for (MixClass * class in obj.hClasses) {
            NSString * newClassName = [NSString stringWithFormat:@"%@%@",[MixConfig sharedSingleton].mixPrefix,class.className];
            if (![MixReferenceStrategy filter:newClassName] && ![classNames containsObject:newClassName]) {
                [classNames addObject:newClassName];
            }
        }
    }];
    
    
    return classNames;
}

+ (BOOL)filter:(NSString *)string {
    BOOL isFilter = NO;
    NSArray * filters = @[@"AppDelegate"];
    if ([filters containsObject:string] || [string containsString:@"("] || [MixFilterStrategy isSystemClass:string]) {
        isFilter = YES;
    }

    return isFilter;
}

@end
