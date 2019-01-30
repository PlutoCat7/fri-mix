//
//  YHJSONAdapter.h
//  Test
//
//  Created by wangsw on 15/11/23.
//  Copyright © 2015年 wangsw. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol YAHJSONSerializing

@required

/**
 *  @return NSDictionary with property and json key
 */
+ (NSDictionary *)JSONKeyPathsByPropertyKey;

/**
 *  @return NSDictionary with property 与自定义类的
 */
+ (nullable NSDictionary *)convertClassStringDictionary;

@end

@interface YAHJSONAdapter : NSObject

/**
 *  @author wangsw, 16-05-16 16:05:04
 *
 *  将网络请求json转化为所需要的model
 *
 *  @param jsonData 支持nsdata nsstring nsarray nsdictionary
 *  @param clazz    model的Class
 *
 *  @return 返回所需要的model
 */
+ (id)objectFromJsonData:(id)jsonData objectClass:(Class)clazz;

/**
 *  @author wangsw, 16-05-16 17:05:29
 *
 *  将类转化为jsonstring
 *
 *  @param object 需要转化的类 暂时支持基本类型和nsarray和nsdictionary  nsset等暂不支持
 *
 *  @return jsonString
 */
+ (NSString *)jsonStringFromObject:(id)object;

+ (NSDictionary *)jsonDictionaryFromObject:(id)object;

@end
NS_ASSUME_NONNULL_END
