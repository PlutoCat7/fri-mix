//
//  YAHActiveObject.h
//  YAHModel
//
//  Created by yahua on 16/4/5.
//  Copyright © 2016年 wangsw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YAHActiveObject : NSObject <NSCoding, NSCopying>

/**
 *  属性名和json key不一致则需要重写该方法   默认 return nil
 *  例如：json key 为@"name"   属性名为@"userName"   @{"userName":"name"}
 *
 *  @return 返回property与json key 相对应的dictionary
 */
+ (nullable NSDictionary *)bridgePropertyAndJSON;


/**
 *  属性中包含NSArray 将类名与属性名绑定  默认 return nil
 *  例如：return @{@"rows":@"EntityNoteInfo"};
 *
 *  @return 返回数组与自定义类 相对应的dictionary
 */
+ (nullable NSDictionary *)bridgeClassAndArray;

@end
