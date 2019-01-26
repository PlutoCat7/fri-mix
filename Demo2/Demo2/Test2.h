//
//  Test2.h
//  Demo2
//
//  Created by ChenJie on 2019/1/26.
//  Copyright © 2019 Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Test2Delegate <NSObject>

- (void)demo2_test2_delegate2_method2;

@end


@interface Test2 : NSObject

- (void)demo2_test2_method2;

- (void)demo1_test1_method2_parameter2:(NSString*)parameter;

@end

