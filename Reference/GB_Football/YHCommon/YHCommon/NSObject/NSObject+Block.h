//
//  NSObject+Block.h
//  GB_Football
//
//  Created by wsw on 16/8/2.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Block)

- (void)performBlock:(void(^)(void))block delay:(NSTimeInterval)delay;
@end
