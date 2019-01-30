//
//  NSObject+Block.m
//  GB_Football
//
//  Created by wsw on 16/8/2.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "NSObject+Block.h"

@implementation NSObject (Block)

- (void)performBlock:(void(^)(void))block delay:(NSTimeInterval)delay; {
    
     block = [block copy];
     [self performSelector:@selector(fireBlockAfterDelay:)
                withObject:block
                afterDelay:delay];
}

- (void)fireBlockAfterDelay:(void(^)(void))block {
    
    if (block) {
        block();
    }
}

@end
