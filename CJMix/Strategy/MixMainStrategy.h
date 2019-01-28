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

+ (void)replaceMethod:(NSArray <MixObject *>*)objects methods:(NSArray <NSString *>*)methods systemObjects:(NSArray <MixObject*>*)systemObjects;


@end
