//
//  MessageRequest.m
//  GB_Football
//
//  Created by wsw on 16/7/13.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "MessageRequest.h"

@implementation MessageRequest

+ (void)checkHasNewMessageWithHandler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"anno_is_have_anno_controller/doishave";
    NSDictionary *parameters = @{@"date":@([RawCacheManager sharedRawCacheManager].lastGetMessageTime),
                                 @"invite_time":@([RawCacheManager sharedRawCacheManager].lastGetInviteMessageTime),
                                 @"team_mess_time":@([RawCacheManager sharedRawCacheManager].lastGetTeamMessageTime)};
    
    [self POST:urlString parameters:parameters responseClass:[NewMessageResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            NewMessageResponseInfo *info = (NewMessageResponseInfo *)result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)deleteMatchInviteWithMatchIdList:(NSArray<NSNumber *> *)deleteList handler:(RequestCompleteHandler)handler {

    NSString *urlString = @"match_manage_controller/hideInvite";
    NSMutableString *listString = [NSMutableString string];
    for (NSNumber *idNumber in deleteList) {
        if ([NSString stringIsNullOrEmpty:listString]) {
            [listString appendString:idNumber.stringValue];
        } else {
            [listString appendFormat:@",%@", idNumber.stringValue];
        }
    }
    NSDictionary *parameters = @{@"match_id_list":[listString copy]};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        
        BLOCK_EXEC(handler, nil, error);
    }];
}

+ (void)deleteTeamMessageWithList:(NSArray<MessageTeamInfo *> *)deleteList handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"team_manage_controller/dosethide";
    NSMutableArray *paramList = [NSMutableArray arrayWithCapacity:deleteList.count];
    for (MessageTeamInfo *info in deleteList) {
        
        [paramList addObject:@{@"id":@(info.messageId),
                               @"team_id":@(info.team_id),
                               @"apply_id":@(info.user_id),
                               @"type_id":@(info.messageType)}];
    }
    NSDictionary *parseDic = @{@"messlist":[paramList copy]};
    NSData *parseData = [NSJSONSerialization dataWithJSONObject:parseDic options:0 error:nil];
    NSString *dataString = [[NSString alloc] initWithData:parseData encoding:NSUTF8StringEncoding];

    NSDictionary *parameters = @{@"mess_json":dataString};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        
        BLOCK_EXEC(handler, nil, error);
    }];
}

@end
