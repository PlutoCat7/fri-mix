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
#import "MixJudgeStrategy.h"
#import "../Config/MixConfig.h"

@implementation MixReferenceStrategy

+ (NSMutableArray <NSString *> *)classNamesWithObjects:(NSArray <MixObject*>*)objects {
    NSMutableArray * classNames = [NSMutableArray arrayWithCapacity:0];
    [objects enumerateObjectsUsingBlock:^(MixObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        for (MixClass * class in obj.hClasses) {
            NSString * newClassName = [NSString stringWithFormat:@"%@%@",[MixConfig sharedSingleton].mixPrefix,class.className];
            if ([MixJudgeStrategy isLegalNewClassName:newClassName] && ![classNames containsObject:newClassName]) {
                [classNames addObject:newClassName];
            }
        }
    }];
    
    return classNames;
}

@end
