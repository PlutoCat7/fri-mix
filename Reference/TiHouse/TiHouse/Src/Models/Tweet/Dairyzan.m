//
//  Dairyzan.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "Dairyzan.h"
#import "Login.h"
@implementation Dairyzan



-(NSString *)toPathisZan:(BOOL)isZan{
    return isZan ? @"api/inter/dairyzan/add" : @"api/inter/dairyzan/remove";
}

-(NSDictionary *)toParams{
    return @{@"dairyid":@(_dairyid),@"dairyzanuid":@(_dairyzanuid),@"houseid":@(_houseid)};
}


@end
