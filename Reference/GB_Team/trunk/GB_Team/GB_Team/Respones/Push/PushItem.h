//
//  PushItem.h
//  GB_Football
//
//  Created by weilai on 16/3/29.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

typedef enum
{
    PushType_Friend = 1,
    PushType_MatchData,
} PushType;

@interface PushItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger msgId;
@property (nonatomic, assign) PushType type;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
