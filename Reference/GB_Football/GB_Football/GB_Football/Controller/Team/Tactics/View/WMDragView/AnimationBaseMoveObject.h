//
//  AnimationBaseMoveObject.h
//  GB_Football
//
//  Created by yahua on 2018/1/10.
//  Copyright © 2018年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimationBaseMoveObject : NSObject

@property (nonatomic, copy) NSString *identifier;

//移除上一次移动
- (void)removeLastMove;

@end
