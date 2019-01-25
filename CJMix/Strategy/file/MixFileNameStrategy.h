//
//  FileNameStrategy.h
//  najiabao-file
//
//  Created by wangshiwen on 2019/1/24.
//  Copyright © 2019 yahua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MixObject.h"

@interface MixFileNameStrategy : NSObject

+ (BOOL)start:(NSArray<MixObject *> *)objects rootPath:(NSString *)rootPath;

@end
