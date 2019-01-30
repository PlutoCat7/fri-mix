//
//  TacticsJsonModel.m
//  GB_Football
//
//  Created by yahua on 2018/1/11.
//  Copyright © 2018年 Go Brother. All rights reserved.
//

#import "TacticsJsonModel.h"

@implementation TacticsJsonPointModel

@end

@implementation TacticsJsonLineModel

@end

@implementation TacticsJsonPlayerMoveModel

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"pathList":@"TacticsJsonPointModel"};
}

@end

@implementation TacticsJsonStepModel

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"homePlayersMoveList":@"TacticsJsonPlayerMoveModel",
             @"guestPlayersMoveList":@"TacticsJsonPlayerMoveModel",
             @"arrowLineList":@"TacticsJsonLineModel",
             };
}

@end

@implementation TacticsJsonModel

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"stepList":@"TacticsJsonStepModel"};
}

@end
