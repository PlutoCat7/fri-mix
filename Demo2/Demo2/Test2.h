//
//  Test2.h
//  Demo2
//
//  Created by ChenJie on 2019/1/26.
//  Copyright © 2019 Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Test2Delegate <NSObject>

- (void)demo2_delegate_method;

- (void)demo2_delegate_method_parameter:(NSString*)parameter;

@end


@interface Test2 : NSObject

- (void)demo2_method;

- (void)demo2_method_parameter:(NSString*)parameter;

+ (void)demo2_class_method;

+ (void)demo2_class_method_parameter:(NSString*)parameter;

@end

