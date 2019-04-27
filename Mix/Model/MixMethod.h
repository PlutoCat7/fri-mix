//
//  MixMethod.h
//  Mix
//
//  Created by ChenJie on 2019/1/20.
//  Copyright © 2019 ChenJie. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MixMethodType) {
    MixMethodTypeClass,
    MixMethodTypeExample,
    MixMethodTypeProperty
};

@interface MixMethod : NSObject <NSCoding>

@property (nonatomic , strong) NSString * methodName;

@property (nonatomic , assign) MixMethodType methodType;

@property (nonatomic , assign) BOOL isReadonly;

@end

