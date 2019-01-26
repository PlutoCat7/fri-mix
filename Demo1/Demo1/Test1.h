//
//  Test1.h
//  Demo1
//
//  Created by ChenJie on 2019/1/26.
//  Copyright © 2019 Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Test1Delegate <NSObject>

- (void)demo1_test1_delegate1_method1;

@end


@interface Test1 : NSObject <Test1Delegate>

- (void)demo1_test1_method1;

- (void)demo1_test1_method1_parameter1:(NSString*)parameter;

@end
