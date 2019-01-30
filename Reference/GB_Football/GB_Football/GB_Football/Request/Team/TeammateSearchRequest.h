//
//  TeammateSearchRequest.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/26.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "BasePageNetworkRequest.h"
#import "TeamNewTeammateSearchResponsePageInfo.h"

@interface TeammateSearchRequest : BasePageNetworkRequest

@property (nonatomic, copy) NSString *searchPhone;

@end
