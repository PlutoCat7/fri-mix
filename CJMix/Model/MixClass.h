//
//  MixClass.h
//  Mix
//
//  Created by ChenJie on 2019/1/21.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MixMethod.h"
#import "MixProperty.h"

@interface MixClass : NSObject


/**
 类名
 */
@property (nonatomic , copy ) NSString * className;

/**
 方法
 */
@property (nonatomic , strong) MixMethod * method;

/**
 属性
 */
@property (nonatomic , strong) MixProperty* property;

/**
 使用类名初始化
 */
- (instancetype)initWithClassName:(NSString *)className;

/**
 从数据里获取方法
 */
- (void)methodFromData:(NSString *)data;


@end

