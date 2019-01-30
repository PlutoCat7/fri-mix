//
//  MessagePageRequest.m
//  GB_Football
//
//  Created by wsw on 16/7/13.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "MessagePageRequest.h"

@implementation MessagePageRequest

- (Class)responseClass {
    
    return [MessageListResponseInfo class];
}

- (NSString *)requestAction {
    
    return @"anno_page_list_controller/dolist";
}


@end
