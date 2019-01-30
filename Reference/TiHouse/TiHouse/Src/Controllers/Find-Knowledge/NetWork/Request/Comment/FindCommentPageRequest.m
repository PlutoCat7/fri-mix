//
//  FindCommentPageRequest.m
//  TiHouse
//
//  Created by weilai on 2018/2/5.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindCommentPageRequest.h"

@implementation FindCommentPageRequest

- (Class)responseClass {
    
    return [FindComListResponse class];
}

- (NSString *)requestAction {
    
    return @"/api/inter/assemarccomm/pageByAssemarcid";
}

- (NSDictionary *)parameters {
    
    return @{@"assemarcid" : @(_assemId),
             @"ordertype" : @(_rankType)
             };
}

@end
