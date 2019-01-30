//
//  NSObject+ObjectMap.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/3.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ObjectMap)


// id -> Object
+(id)objectOfClass:(NSString *)object fromJSON:(NSDictionary *)dict;

@end
