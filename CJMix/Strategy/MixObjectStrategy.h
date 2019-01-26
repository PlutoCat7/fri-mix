//
//  MixObjectStrategy.h
//  Mix
//
//  Created by ChenJie on 2019/1/21.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Model/MixClassFile.h"
#import "../Model/MixObject.h"

@interface MixObjectStrategy : NSObject

+ (NSArray <MixObject *>*)objectsWithPath:(NSString *)path;

+ (NSArray <MixObject*>*)fileToObject:(NSArray <MixClassFile *>*)classFiles;

@end

