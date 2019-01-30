//
//  TracticsModel.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/31.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "LineUpModel.h"

@interface LineUpModel ()

@property (nonatomic, copy) NSString *name;

@end

@implementation LineUpModel

- (void)setTracticsType:(TracticsType)tracticsType {
    
    _tracticsType = tracticsType;
    switch (tracticsType) {
        case TracticsType_352:
            self.name = @"3-5-2";
            break;
        case TracticsType_541:
            self.name = @"5-4-1";
            break;
        case TracticsType_442:
            self.name = @"4-4-2";
            break;
        case TracticsType_433:
            self.name = @"4-3-3";
            break;
        case TracticsType_343:
            self.name = @"3-4-3";
            break;
        case TracticsType_451:
            self.name = @"4-5-1";
            break;
        case TracticsType_532:
            self.name = @"5-3-2";
            break;
            
        default:
            break;
    }
}

@end
