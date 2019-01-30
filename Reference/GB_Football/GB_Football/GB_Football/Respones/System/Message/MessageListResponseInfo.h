//
//  MessageListResponseInfo.h
//  GB_Football
//
//  Created by wsw on 16/7/13.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBResponsePageInfo.h"

@interface MessageInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger messageId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) MessageType type;
@property (nonatomic, copy) NSString *param_url;   //客户端打开web页需要的url参数
@property (nonatomic, copy) NSString *param_uri;   //客户端打开三方app的需要的url参数
@property (nonatomic, assign) NSInteger param_id;  //客户端打开本地界面需要的id参数
@property (nonatomic, assign) long createTime;

@end

@interface MessageListResponseInfo : GBResponsePageInfo

@property (nonatomic, strong) NSArray<MessageInfo *> *data;

@end
