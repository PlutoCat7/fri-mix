//
//  RunResponseInfo.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/6.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "RunResponseInfo.h"

@implementation RunDetailInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"stepNumber":@"step_number",
             @"avgSpeed":@"avg_speed",
             @"consume":@"pc",
             @"consumeTime":@"consume_time"};
}

- (void)setConsumeTime:(NSInteger)consumeTime {
    
    _consumeTime = consumeTime;
    NSInteger hour = consumeTime / 3600;
    NSInteger min = (consumeTime - hour * 3600) / 60;
    NSInteger sec = (consumeTime - hour * 3600) % 60;;
    self.consumeTimeString = [NSString stringWithFormat:@"%02d:%02d:%02d", (int)hour, (int)min, (int)sec];
}

- (void)setAvgSpeed:(float)avgSpeed {
    
    _avgSpeed = avgSpeed;
    float speed = avgSpeed == 0 ? 0 : (1000.f / (avgSpeed * 60.f));
    if (speed>60) {
        self.withSpeedString = @">60\'00\"";
    }else {
        self.withSpeedString = [NSString stringWithFormat:@"%td\'%02td\"", (NSInteger)speed, (NSInteger)((speed-((NSInteger)speed))*60)];
    }
}

@end

@implementation RunResponseInfo

- (NSString *)getCacheKey {
    
    NSString *key = [super getCacheKey];
    key = [NSString stringWithFormat:@"%@_%@", key, self.key];
    return key;
}

@end
