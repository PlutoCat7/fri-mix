//
//  DailyResponeInfo.m
//  GB_Football
//
//  Created by wsw on 16/7/15.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "DailyResponeInfo.h"

@implementation DailyInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"dailyStep":@"step_number",
             @"dailyDistance":@"distance",
             @"dailyConsume":@"pc",
             @"sportStep":@"match_step_number",
             @"sportDistance":@"match_distance",
             @"sportConsume":@"match_pc",
             @"runStep":@"run_step_number",
             @"runDistance":@"run_distance",
             @"runConsume":@"run_pc"};
}

- (NSInteger)dailyAndRunStep {
    
    return self.dailyStep + self.runStep;
}

- (float) dailyAndRunDistance {
    return self.dailyDistance + self.runDistance;
}


- (float) dailyAndRunConsume {
    return self.dailyConsume + self.runConsume;
}


- (NSInteger) totalStep {
    return self.dailyStep + self.sportStep + self.runStep;
}

- (float) totalDistance {
    return self.dailyDistance + self.sportDistance + self.runDistance;
}

- (float) totalConsume {
    return self.dailyConsume + self.sportConsume + self.runConsume;
}

@end

@implementation DailyResponeInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"data":@"DailyInfo"};
}

@end
