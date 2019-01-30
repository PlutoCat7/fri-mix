//
//  PushBaseItem.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/31.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushBaseItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) PushType type;
@property (nonatomic, copy) NSString *content;

@property (nonatomic, strong) NSDictionary *pushDict;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
