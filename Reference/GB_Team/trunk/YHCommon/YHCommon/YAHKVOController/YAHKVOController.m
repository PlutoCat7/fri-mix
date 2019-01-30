//
//  YHKVOController.m
//  Test123
//
//  Created by yahua on 16/3/2.
//  Copyright © 2016年 wangsw. All rights reserved.
//

#import "YAHKVOController.h"

#import <objc/message.h>
#import <pthread.h>


#pragma mark _YHKVOInfo -

/**
 @abstract The key-value observation info.
 @discussion Object equality is only used within the scope of a controller instance. Safely omit controller from equality definition.
 */
@interface _YHKVOInfo : NSObject
@end

@implementation _YHKVOInfo
{
@public
    __weak YAHKVOController *_controller;
    NSString *_keyPath;
    NSKeyValueObservingOptions _options;
    YAHKVONotificationBlock _block;
}

- (instancetype)initWithController:(YAHKVOController *)controller keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(YAHKVONotificationBlock)block
{
    self = [super init];
    if (nil != self) {
        _controller = controller;
        _block = [block copy];
        _keyPath = [keyPath copy];
        _options = options;
    }
    return self;
}

- (instancetype)initWithController:(YAHKVOController *)controller keyPath:(NSString *)keyPath
{
    return [self initWithController:controller keyPath:keyPath options:0 block:NULL];
}

- (NSUInteger)hash
{
    return [_keyPath hash];
}

- (BOOL)isEqual:(id)object
{
    if (nil == object) {
        return NO;
    }
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    return [_keyPath isEqualToString:((_YHKVOInfo *)object)->_keyPath];
}

- (NSString *)debugDescription
{
    NSMutableString *s = [NSMutableString stringWithFormat:@"<%@:%p keyPath:%@", NSStringFromClass([self class]), self, _keyPath];
    [s appendString:@">"];
    return s;
}

@end

#pragma mark _YHKVOSharedController -

/**
 @abstract The shared KVO controller instance.
 @discussion Acts as a receptionist, receiving and forwarding KVO notifications.
 */
@interface _YHKVOSharedController : NSObject

@property (nonatomic, strong) NSHashTable *infos;
@property (nonatomic, assign) pthread_mutex_t mutexLock;

/** A shared instance that never deallocates. */
+ (instancetype)sharedController;

/** observe an object, info pair */
- (void)observe:(id)object info:(_YHKVOInfo *)info;

/** unobserve an object, info pair */
- (void)unobserve:(id)object info:(_YHKVOInfo *)info;

/** unobserve an object with a set of infos */
- (void)unobserve:(id)object infos:(NSSet *)infos;

@end

@implementation _YHKVOSharedController

+ (instancetype)sharedController
{
    static _YHKVOSharedController *_controller = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _controller = [[_YHKVOSharedController alloc] init];
    });
    return _controller;
}

- (instancetype)init
{
    self = [super init];
    if (nil != self) {
        NSHashTable *infos = [NSHashTable alloc];

        _infos = [infos initWithOptions:NSPointerFunctionsWeakMemory|NSPointerFunctionsObjectPointerPersonality capacity:0];
        pthread_mutex_init(&_mutexLock, NULL);
    }
    return self;
}

- (NSString *)debugDescription
{
    NSMutableString *s = [NSMutableString stringWithFormat:@"<%@:%p", NSStringFromClass([self class]), self];
    
    // lock
    [self lock];
    
    NSMutableArray *infoDescriptions = [NSMutableArray arrayWithCapacity:_infos.count];
    for (_YHKVOInfo *info in _infos) {
        [infoDescriptions addObject:info.debugDescription];
    }
    
    [s appendFormat:@" contexts:%@", infoDescriptions];
    
    // unlock
    [self unlock];
    
    [s appendString:@">"];
    return s;
}

- (void)observe:(id)object info:(_YHKVOInfo *)info
{
    if (nil == info) {
        return;
    }
    
    // register info
    [self lock];
    [_infos addObject:info];
    [self unlock];
    
    // add observer
    [object addObserver:self forKeyPath:info->_keyPath options:info->_options context:(void *)info];
}

- (void)unobserve:(id)object info:(_YHKVOInfo *)info
{
    if (nil == info) {
        return;
    }
    
    // unregister info
    [self lock];
    [_infos removeObject:info];
    [self unlock];
    
    // remove observer
    [object removeObserver:self forKeyPath:info->_keyPath context:(void *)info];
}

- (void)unobserve:(id)object infos:(NSSet *)infos
{
    if (0 == infos.count) {
        return;
    }
    
    // unregister info
    [self lock];
    for (_YHKVOInfo *info in infos) {
        [_infos removeObject:info];
    }
    [self unlock];
    
    // remove observer
    for (_YHKVOInfo *info in infos) {
        [object removeObserver:self forKeyPath:info->_keyPath context:(void *)info];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSAssert(context, @"missing context keyPath:%@ object:%@ change:%@", keyPath, object, change);
    
    _YHKVOInfo *info;
    
    {
        // lookup context in registered infos, taking out a strong reference only if it exists
        [self lock];
        info = [_infos member:(__bridge id)context];
        [self unlock];
    }
    
    if (nil != info) {
        
        // take strong reference to controller
        YAHKVOController *controller = info->_controller;
        if (nil != controller) {
            
            // take strong reference to observer
            id observer = controller.observer;
            if (nil != observer) {
                
                // dispatch custom block
                if (info->_block) {
                    info->_block(observer, object, change);
                }
            }
        }
    }
}

#pragma mark  Private

- (void)lock {
    
    pthread_mutex_lock(&_mutexLock);
}

- (void)unlock {
    
    pthread_mutex_unlock(&_mutexLock);
}

@end

#pragma mark YHKVOController -

@interface YAHKVOController ()

@property (nonatomic, strong) NSMapTable *objectInfosMap;
@property (nonatomic, assign) pthread_mutex_t mutexLock;

@end

@implementation YAHKVOController

#pragma mark Lifecycle

+ (instancetype)controllerWithObserver:(id)observer
{
    return [[self alloc] initWithObserver:observer];
}

- (instancetype)initWithObserver:(id)observer retainObserved:(BOOL)retainObserved
{
    self = [super init];
    if (nil != self) {
        _observer = observer;
        NSPointerFunctionsOptions keyOptions = retainObserved ? NSPointerFunctionsStrongMemory|NSPointerFunctionsObjectPointerPersonality : NSPointerFunctionsWeakMemory|NSPointerFunctionsObjectPointerPersonality;
        _objectInfosMap = [[NSMapTable alloc] initWithKeyOptions:keyOptions valueOptions:NSPointerFunctionsStrongMemory|NSPointerFunctionsObjectPersonality capacity:0];
        
        pthread_mutex_init(&_mutexLock, NULL);
    }
    return self;
}

- (instancetype)initWithObserver:(id)observer
{
    return [self initWithObserver:observer retainObserved:YES];
}

- (void)dealloc
{
    [self unobserveAll];
}

#pragma mark Properties -

- (NSString *)debugDescription
{
    NSMutableString *s = [NSMutableString stringWithFormat:@"<%@:%p", NSStringFromClass([self class]), self];
    [s appendFormat:@" observer:<%@:%p>", NSStringFromClass([_observer class]), _observer];
    
    // lock
    [self lock];
    
    if (0 != _objectInfosMap.count) {
        [s appendString:@"\n  "];
    }
    
    for (id object in _objectInfosMap) {
        NSMutableSet *infos = [_objectInfosMap objectForKey:object];
        NSMutableArray *infoDescriptions = [NSMutableArray arrayWithCapacity:infos.count];
        [infos enumerateObjectsUsingBlock:^(_YHKVOInfo *info, BOOL *stop) {
            [infoDescriptions addObject:info.debugDescription];
        }];
        [s appendFormat:@"%@ -> %@", object, infoDescriptions];
    }
    
    // unlock
    [self unlock];
    
    [s appendString:@">"];
    return s;
}

#pragma mark Utilities -

- (void)_observe:(id)object info:(_YHKVOInfo *)info
{
    // lock
    [self lock];
    
    NSMutableSet *infos = [_objectInfosMap objectForKey:object];
    
    // check for info existence
    _YHKVOInfo *existingInfo = [infos member:info];
    if (nil != existingInfo) {
        NSLog(@"observation info already exists %@", existingInfo);
        
        // unlock and return
        [self unlock];
        return;
    }
    
    // lazilly create set of infos
    if (nil == infos) {
        infos = [NSMutableSet set];
        [_objectInfosMap setObject:infos forKey:object];
    }
    
    // add info and oberve
    [infos addObject:info];
    
    // unlock prior to callout
    [self unlock];
    
    [[_YHKVOSharedController sharedController] observe:object info:info];
}

- (void)_unobserve:(id)object info:(_YHKVOInfo *)info
{
    // lock
    [self lock];
    
    // get observation infos
    NSMutableSet *infos = [_objectInfosMap objectForKey:object];
    
    // lookup registered info instance
    _YHKVOInfo *registeredInfo = [infos member:info];
    
    if (nil != registeredInfo) {
        [infos removeObject:registeredInfo];
        
        // remove no longer used infos
        if (0 == infos.count) {
            [_objectInfosMap removeObjectForKey:object];
        }
    }
    
    // unlock
    [self unlock];
    
    // unobserve
    [[_YHKVOSharedController sharedController] unobserve:object info:registeredInfo];
}

- (void)_unobserve:(id)object
{
    // lock
    [self lock];
    
    NSMutableSet *infos = [_objectInfosMap objectForKey:object];
    
    // remove infos
    [_objectInfosMap removeObjectForKey:object];
    
    // unlock
    [self unlock];
    
    // unobserve
    [[_YHKVOSharedController sharedController] unobserve:object infos:infos];
}

- (void)_unobserveAll
{
    // lock
    [self lock];
    
    NSMapTable *objectInfoMaps = [_objectInfosMap copy];
    
    // clear table and map
    [_objectInfosMap removeAllObjects];
    
    // unlock
    [self unlock];
    
    _YHKVOSharedController *shareController = [_YHKVOSharedController sharedController];
    
    for (id object in objectInfoMaps) {
        // unobserve each registered object and infos
        NSSet *infos = [objectInfoMaps objectForKey:object];
        [shareController unobserve:object infos:infos];
    }
}

#pragma mark API -

- (void)observe:(id)object keyPath:(NSString *)keyPath block:(YAHKVONotificationBlock)block
{
    NSAssert(0 != keyPath.length && NULL != block, @"missing required parameters observe:%@ keyPath:%@ block:%p", object, keyPath, block);
    if (nil == object || 0 == keyPath.length || NULL == block) {
        return;
    }
    
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    
    // create info
    _YHKVOInfo *info = [[_YHKVOInfo alloc] initWithController:self keyPath:keyPath options:options block:block];
    
    // observe object with info
    [self _observe:object info:info];
}


- (void)observe:(id)object keyPaths:(NSArray *)keyPaths block:(YAHKVONotificationBlock)block
{
    NSAssert(0 != keyPaths.count && NULL != block, @"missing required parameters observe:%@ keyPath:%@ block:%p", object, keyPaths, block);
    if (nil == object || 0 == keyPaths.count || NULL == block) {
        return;
    }
    
    for (NSString *keyPath in keyPaths)
    {
        [self observe:object keyPath:keyPath  block:block];
    }
}

- (void)unobserve:(id)object keyPath:(NSString *)keyPath
{
    // create representative info
    _YHKVOInfo *info = [[_YHKVOInfo alloc] initWithController:self keyPath:keyPath];
    
    // unobserve object property
    [self _unobserve:object info:info];
}

- (void)unobserve:(id)object
{
    if (nil == object) {
        return;
    }
    
    [self _unobserve:object];
}

- (void)unobserveAll
{
    [self _unobserveAll];
}

#pragma mark  Private

- (void)lock {
    
    pthread_mutex_lock(&_mutexLock);
}

- (void)unlock {
    
    pthread_mutex_unlock(&_mutexLock);
}

@end


#pragma mark -
#pragma mark NSObject Category

static void *NSObjectKVOControllerKey = &NSObjectKVOControllerKey;

@implementation NSObject (YAHKVOController)

- (YAHKVOController *)yah_KVOController
{
    id controller = objc_getAssociatedObject(self, NSObjectKVOControllerKey);
    
    // lazily create the KVOController
    if (nil == controller) {
        controller = [YAHKVOController controllerWithObserver:self];
        self.yah_KVOController = controller;
    }
    
    return controller;
}

- (void)setYah_KVOController:(YAHKVOController *)yah_KVOController
{
    objc_setAssociatedObject(self, NSObjectKVOControllerKey, yah_KVOController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
