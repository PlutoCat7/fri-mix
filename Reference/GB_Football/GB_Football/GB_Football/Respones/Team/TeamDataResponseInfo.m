//
//  TeamDataResponseInfo.m
//  GB_Football
//
//  Created by 王时温 on 2017/8/4.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "TeamDataResponseInfo.h"

@implementation TeamDataPlayerInfo

- (void)setUser_name:(NSString *)user_name {
    
    _user_name = user_name;
    self.abbreviateName = user_name;
    if (self.abbreviateName.length>6) {
        self.abbreviateName = [NSString stringWithFormat:@"%@...%@", [self.abbreviateName substringWithRange:NSMakeRange(0, 3)], [self.abbreviateName substringWithRange:NSMakeRange(self.abbreviateName.length-3, 3)]];
    }
}

@end

@implementation TeamDataTeamInfo

- (NSArray<NSString *> *)historyScoreList {
    
    NSArray *tmpList = [self.score_history componentsSeparatedByString:@","];
    return tmpList;
}

@end

@implementation TeamDataInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"team_data":@"TeamDataPlayerInfo"};
}

@end

@implementation TeamDataResponseInfo

@end
