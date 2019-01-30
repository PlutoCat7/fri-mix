//
//  TweetComment.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "TweetComment.h"
#import "Login.h"

@implementation TweetComment



- (NSString *)toPath{
    
    return @"api/inter/dairycomm/add";
}
- (NSDictionary *)toParams{
    User *user = [Login curLoginUser];
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@(_dairyid) forKey:@"dairyid"];
    [dic setValue:@(_houseid) forKey:@"houseid"];
    [dic setValue:@(user.uid) forKey:@"dairycommuid"];
    [dic setValue:@(_dairycommuidon) forKey:@"dairycommuidon"];
    [dic setValue:_dairycommcontent forKey:@"dairycommcontent"];
    [dic setValue:_dairycommid ? @(_dairycommid) : @(-1) forKey:@"dairycommid"];
    
    return [dic copy];
}


@end
