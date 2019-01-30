//
//  GBPopAnimateTool.h
//  该类用于TGOAL pop常用动画封装 减少冗余度
//
//  Created by Pizza on 2016/12/21.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <pop/POP.h>

@interface GBPopAnimateTool : NSObject

+(void)popFade:(UIView*)view fade:(BOOL)fade repeat:(BOOL)repeat
              duration:(CGFloat)duration beginTime:(CGFloat)beginTime
       completionBlock:(void(^)())completionBlock;

+(void)popScale:(UIView*)view x:(CGFloat)x y:(CGFloat)y repeat:(BOOL)repeat
               duration:(CGFloat)duration beginTime:(CGFloat)beginTime
        completionBlock:(void(^)())completionBlock;

+(void)popCenter:(UIView*)view x:(CGFloat)x y:(CGFloat)y repeat:(BOOL)repeat
               duration:(CGFloat)duration beginTime:(CGFloat)beginTime
        completionBlock:(void(^)())completionBlock;

+(void)popColored:(UIView*)view color:(UIColor*)color repeat:(BOOL)repeat
      duration:(CGFloat)duration beginTime:(CGFloat)beginTime
  completionBlock:(void(^)())completionBlock;

+(void)popAppear:(UIView*)appear disappear:(UIView*)disappear
        duration:(CGFloat)duration beginTime:(CGFloat)beginTime
 completionBlock:(void(^)())completionBlock;

+(void)popAppearFromMini:(UIView*)view
               beginTime:(CGFloat)beginTime
         completionBlock:(void(^)())completionBlock;

@end
