//
//  MixObject.h
//  Mix
//
//  Created by ChenJie on 2019/1/20.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MixObject.h"
#import "MixClassFile.h"
#import "MixClass.h"

@interface MixObject : NSObject


@property (nonatomic , strong , readonly) MixClassFile* classFile;

/**
 一般来说.h可以全局替换
 */
@property (nonatomic , strong , readonly) NSArray <MixClass *> *hClasses;

/**
 一般来说.m只可以局部替换
 */
@property (nonatomic , strong , readonly) NSArray <MixClass *> *mClasses;


- (instancetype)initWithClassFile:(MixClassFile *)file;

@end
