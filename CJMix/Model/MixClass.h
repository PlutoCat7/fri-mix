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

@property (nonatomic , copy ) NSString * lastClassName;

/**
 方法
 */
@property (nonatomic , strong) NSArray <MixMethod *>* methods;

/**
 属性
 */
@property (nonatomic , strong) NSArray <MixProperty *>* propertys;



- (instancetype)initWithClassName:(NSString *)className;

- (void)methodFromData:(NSString *)data;


@end

