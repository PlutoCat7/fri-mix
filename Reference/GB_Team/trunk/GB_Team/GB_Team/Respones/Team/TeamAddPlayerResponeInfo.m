//
//  TeamAddPlayerInfo.m
//  GB_Team
//
//  Created by 王时温 on 2016/11/17.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "TeamAddPlayerResponeInfo.h"

@implementation TeamAddPlayerInfo

@end

@implementation TeamAddPlayerResponeInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"data":@"TeamAddPlayerInfo"};
}


- (NSArray *)onePageData {
    
    return self.data;
}

@end
