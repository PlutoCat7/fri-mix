//
//  PushItem.h
//  GB_Football
//
//  Created by weilai on 16/3/29.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "PushBaseItem.h"

@interface PushItem : PushBaseItem

@property (nonatomic, assign) NSInteger msgId;

@property (nonatomic, copy) NSString *param_url;
@property (nonatomic, copy) NSString *param_uri;
@property (nonatomic, assign) NSInteger param_id;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
