//
//  CommentPageRequest.m
//  TiHouse
//
//  Created by weilai on 2018/2/3.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CommentPageRequest.h"

@implementation CommentPageRequest

- (Class)responseClass {
    
    return [CommentListResponse class];
}

- (NSString *)requestAction {
    
    return @"/api/inter/knowcomm/pageByKnowid";
}

- (NSDictionary *)parameters {
    
    return @{@"knowid" : @(_knowledgeId),
             @"ordertype" : @(_rankType)
             };
}

@end
