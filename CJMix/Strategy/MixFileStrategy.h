//
//  MixFileStrategy.h
//  Mix
//
//  Created by ChenJie on 2019/1/21.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Model/MixFile.h"

@interface MixFileStrategy : NSObject

+ (NSArray <MixFile *>*)filesWithPath:(NSString *)path;

+ (NSArray <MixFile *>*)filesToHMFiles:(NSArray <MixFile *>*)files;

+ (NSArray <MixFile *>*)filesToPCHFiles:(NSArray <MixFile *>*)files;

+ (MixFile *)projectWithFilesWithPath:(NSString *)path;





+ (BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite error:(NSError *__autoreleasing *)error;

+ (BOOL)writeFileAtPath:(NSString *)path content:(NSString *)content;

@end

