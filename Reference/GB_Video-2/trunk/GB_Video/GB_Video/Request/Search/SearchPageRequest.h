//
//  SearchPageRequest.h
//  GB_Video
//
//  Created by gxd on 2018/2/24.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "BasePageNetworkRequest.h"
#import "TopicVideoListResponse.h"

@interface SearchPageRequest : BasePageNetworkRequest

@property (nonatomic, copy) NSString *keyword;

@end
