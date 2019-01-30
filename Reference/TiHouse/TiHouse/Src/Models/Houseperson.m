//
//  Houseperson.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/11.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "Houseperson.h"

@implementation Houseperson

- (NSString *)typerelationName{
     NSArray *arr = @[@"尚未选择",@"女主人",@"男主人",@"亲人",@"设计方",@"施工方",@"朋友"];
    
    if (_typerelation>6) {
        return @"";
    }
    
    return arr[_typerelation];
}

@end
