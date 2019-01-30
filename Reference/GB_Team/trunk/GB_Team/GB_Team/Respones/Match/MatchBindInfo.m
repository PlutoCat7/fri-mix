//
//  MatchBindInfo.m
//  GB_Team
//
//  Created by weilai on 16/9/27.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "MatchBindInfo.h"
#import <objc/runtime.h>

static char kSTAR_SEARCH_STATE;
static char kSTAR_SEARCH_TIMEOUT_TIMER;

@implementation WristbandInfo (Player)

- (void)setSearchStartState:(STAR_SEARCH_STATE)searchStartState {
    
    objc_setAssociatedObject(self, &kSTAR_SEARCH_STATE, @(searchStartState), OBJC_ASSOCIATION_RETAIN);
}

- (STAR_SEARCH_STATE)searchStartState {
    
    NSNumber *state = objc_getAssociatedObject(self, &kSTAR_SEARCH_STATE);
    return [state integerValue];
}

- (void)setTimeoutTimer:(NSTimer *)timeoutTimer {
    
    [self.timeoutTimer invalidate];
    objc_setAssociatedObject(self, &kSTAR_SEARCH_TIMEOUT_TIMER, timeoutTimer, OBJC_ASSOCIATION_RETAIN);
}

- (NSTimer *)timeoutTimer {
    
    NSTimer *timer = objc_getAssociatedObject(self, &kSTAR_SEARCH_TIMEOUT_TIMER);
    return timer;
}

@end

@implementation PlayerBindInfo

- (void)setWristbandInfo:(WristbandInfo *)wristbandInfo {
    
    [wristbandInfo.timeoutTimer invalidate];
    _wristbandInfo = wristbandInfo;
    _wristbandInfo.searchStartState = STAR_SEARCH_STATE_IDLE;
}

@end

@implementation MatchBindInfo

@end
