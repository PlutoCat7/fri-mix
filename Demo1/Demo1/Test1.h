//
//  Test1.h
//  Demo1
//
//  Created by ChenJie on 2019/1/26.
//  Copyright © 2019 Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Test1Delegate <NSObject>

- (void)demo1_delegate_method;

- (void)demo1_delegate_method_parameter:(NSString*)parameter;

@end


@interface Test1 : NSObject <Test1Delegate>

- (void)demo1_method;

- (void)demo1_method_parameter:(NSString*)parameter;

+ (void)demo1_class_method;

+ (void)demo1_class_method_parameter:(NSString*)parameter;

@end
