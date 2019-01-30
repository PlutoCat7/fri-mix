//
//  ColorCardRequest.h
//  TiHouse
//
//  Created by weilai on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseNetworkRequest.h"

@interface ColorCardRequest : BaseNetworkRequest

+ (void)addColorCardFavor:(NSInteger)colorCardId handler:(RequestCompleteHandler)handler;
+ (void)removeColorCardFavor:(NSInteger)colorCardId handler:(RequestCompleteHandler)handler;

@end
