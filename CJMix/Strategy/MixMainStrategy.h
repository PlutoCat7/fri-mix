//
//  MixMainStrategy.h
//  Mix
//
//  Created by ChenJie on 2019/1/21.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Model/MixObject.h"

@interface MixMainStrategy : NSObject

+ (void)replaceClassName:(NSArray <MixObject *>*)objects referenceClassNames:(NSArray <NSString *>*)classNames;

+ (void)modifyTheProject:(MixFile *)projectFile names:(NSArray <NSString *>*)names;


@end
