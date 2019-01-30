//
//  PosterListPesponse.m
//  TiHouse
//
//  Created by weilai on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "PosterListPesponse.h"

@implementation PosterListPesponse

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"data":[GroupKnowModeInfo class]};
}


- (NSArray *)onePageData {
    
    return self.data;
}

@end
