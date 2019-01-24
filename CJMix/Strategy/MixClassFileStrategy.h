//
//  MixClassFileStrategy.h
//  Mix
//
//  Created by ChenJie on 2019/1/21.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Model/MixFile.h"
#import "../Model/MixClassFile.h"

@interface MixClassFileStrategy : NSObject

+ (NSArray <MixClassFile *> *)filesToClassFiles:(NSArray <MixFile *>*)hmFiles;

@end

