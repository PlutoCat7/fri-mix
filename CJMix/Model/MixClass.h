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

@property (nonatomic , copy) NSString * className;

@property (nonatomic , strong) MixMethod * method;

@property (nonatomic , strong) MixProperty* property;

- (instancetype)initWithClassName:(NSString *)className;

- (void)methodFromData:(NSString *)data;


@end

