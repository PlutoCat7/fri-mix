//
//  TeamMatchRecordRequest.h
//  GB_Football
//
//  Created by gxd on 17/7/27.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "BasePageNetworkRequest.h"
#import "TeamMatchRecordResponeInfo.h"

@interface TeamMatchRecordRequest : BasePageNetworkRequest

@property (nonatomic, assign) NSInteger teamId;

@end
