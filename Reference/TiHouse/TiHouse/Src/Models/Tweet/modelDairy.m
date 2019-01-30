//
//  modelDairy.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "modelDairy.h"
#import "Dairyzan.h"
#import "Login.h"
@implementation modelDairy


+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"listModelDairyzan" : @"Dairyzan",
             @"listModelDairycomm" : @"TweetComment"
             
             };
}



-(NSString *)toCommentPath{
    return @"api/inter/dairycomm/pageByDairyid";
}



-(void)ClickZan:(Dairyzan *)zan{
    [_listModelDairyzan insertObject:zan atIndex:0];
}
-(void)CancelZan{
    
    User *user = [Login curLoginUser];
    [_listModelDairyzan enumerateObjectsUsingBlock:^(Dairyzan *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.dairyzanuid == user.uid) {
            [_listModelDairyzan removeObject:obj];
        }
    }];
}

- (void)configWithHouess:(NSArray *)responseA{
    if (responseA && [responseA count] > 0) {
        self.canLoadMore = YES;
        if (_willLoadMore) {
            [_listModelDairycomm addObjectsFromArray:responseA];
        }else{
            [_listModelDairycomm removeAllObjects];
            [_listModelDairycomm addObjectsFromArray:responseA];
        }
    }else{
        self.canLoadMore = NO;
    }
}


@end

