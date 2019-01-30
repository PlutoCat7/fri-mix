//
//  YHKVOController.h
//  Test123
//
//  Created by yahua on 16/3/2.
//  Copyright © 2016年 wangsw. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^YAHKVONotificationBlock)(id observer, id object, NSDictionary *change);

@interface YAHKVOController : NSObject

/// The observer notified on key-value change. Specified on initialization.
@property (atomic, weak, readonly) id observer;

/**
 @abstract Registers observer for key-value change notification.
 @param object The object to observe.
 @param keyPath The key path to observe.
 @param options The NSKeyValueObservingOptions to use for observation.
 @param block The block to execute on notification.
 @discussion On key-value change, the specified block is called. Inorder to avoid retain loops, the block must avoid referencing the KVO controller or an owner thereof. Observing an already observed object key path or nil results in no operation.
 */
- (void)observe:(id)object keyPath:(NSString *)keyPath block:(YAHKVONotificationBlock)block;

/**
 @abstract Registers observer for key-value change notification.
 @param object The object to observe.
 @param keyPaths The key paths to observe.
 @param options The NSKeyValueObservingOptions to use for observation.
 @param block The block to execute on notification.
 @discussion On key-value change, the specified block is called. Inorder to avoid retain loops, the block must avoid referencing the KVO controller or an owner thereof. Observing an already observed object key path or nil results in no operation.
 */
- (void)observe:(id)object keyPaths:(NSArray *)keyPaths block:(YAHKVONotificationBlock)block;

/**
 @abstract Unobserve object key path.
 @param object The object to unobserve.
 @param keyPath The key path to observe.
 @discussion If not observing object key path, or unobserving nil, this method results in no operation.
 */
- (void)unobserve:(id)object keyPath:(NSString *)keyPath;

/**
 @abstract Unobserve all object key paths.
 @param object The object to unobserve.
 @discussion If not observing object, or unobserving nil, this method results in no operation.
 */
- (void)unobserve:(id)object;

/**
 @abstract Unobserve all objects.
 @discussion If not observing any objects, this method results in no operation.
 */
- (void)unobserveAll;


@end



@interface NSObject (YAHKVOController)

/**
 @abstract Lazy-loaded YHKVOController for use with any object
 @return YHKVOController associated with this object, creating one if necessary
 @discussion This makes it convenient to simply create and forget a YHKVOController, and when this object gets dealloc'd, so will the associated controller and the observation info.
 */
@property (nonatomic, strong) YAHKVOController *yah_KVOController;

@end
