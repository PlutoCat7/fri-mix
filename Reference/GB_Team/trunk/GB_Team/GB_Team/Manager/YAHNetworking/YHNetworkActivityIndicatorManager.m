//
//  YHNetworkActivityIndecatorManager.m
//  YCZZ
//
//  Created by 王时温 on 15/11/10.
//  Copyright © 2015年 com.nd.hy. All rights reserved.
//

#import "YHNetworkActivityIndicatorManager.h"
#import "YHURLSessionManager.h"


static NSTimeInterval const kAFNetworkActivityIndicatorInvisibilityRepeat = 0.5;

static NSURLRequest * YHNetworkRequestFromNotification(NSNotification *notification) {
    
    if ([[notification object] respondsToSelector:@selector(originalRequest)]) {
        return [(NSURLSessionTask *)[notification object] originalRequest];
    }
    
    return nil;
}

@interface YHNetworkActivityIndicatorManager ()
@property (readwrite, nonatomic, assign) NSInteger activityCount;
@property (readwrite, nonatomic, strong) NSTimer *activityIndicatorVisibilityTimer;
@property (readonly, nonatomic, getter = isNetworkActivityIndicatorVisible) BOOL networkActivityIndicatorVisible;

- (void)updateNetworkActivityIndicatorVisibility;

@end

@implementation YHNetworkActivityIndicatorManager
@dynamic networkActivityIndicatorVisible;

+ (instancetype)sharedManager {
    static YHNetworkActivityIndicatorManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

+ (NSSet *)keyPathsForValuesAffectingIsNetworkActivityIndicatorVisible {
    return [NSSet setWithObject:@"activityCount"];
}

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkRequestDidStart:) name:YHNetworkingTaskDidResumeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkRequestDidFinish:) name:YHNetworkingTaskDidSuspendNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkRequestDidFinish:) name:YHNetworkingTaskDidCompleteNotification object:nil];
    
    self.activityIndicatorVisibilityTimer = [NSTimer timerWithTimeInterval:kAFNetworkActivityIndicatorInvisibilityRepeat target:self selector:@selector(updateNetworkActivityIndicatorVisibility) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.activityIndicatorVisibilityTimer forMode:NSRunLoopCommonModes];
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_activityIndicatorVisibilityTimer invalidate];
}


- (BOOL)isNetworkActivityIndicatorVisible {
    return self.activityCount > 0;
}

- (void)updateNetworkActivityIndicatorVisibility {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:[self isNetworkActivityIndicatorVisible]];
}

- (void)setActivityCount:(NSInteger)activityCount {
    @synchronized(self) {
        _activityCount = activityCount;
    }
}

- (void)incrementActivityCount {
    
    [self willChangeValueForKey:@"activityCount"];
    @synchronized(self) {
        _activityCount++;
    }
    [self didChangeValueForKey:@"activityCount"];
    
}

- (void)decrementActivityCount {
    
    [self willChangeValueForKey:@"activityCount"];
    @synchronized(self) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
        _activityCount = MAX(_activityCount - 1, 0);
#pragma clang diagnostic pop
    }
    [self didChangeValueForKey:@"activityCount"];
}

- (void)networkRequestDidStart:(NSNotification *)notification {
    
    if ([YHNetworkRequestFromNotification(notification) URL]) {
        [self incrementActivityCount];
    }
}

- (void)networkRequestDidFinish:(NSNotification *)notification {
    
    if ([YHNetworkRequestFromNotification(notification) URL]) {
        [self decrementActivityCount];
    }
}

@end
