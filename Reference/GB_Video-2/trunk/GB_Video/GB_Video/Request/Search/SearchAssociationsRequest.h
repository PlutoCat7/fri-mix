//
//  SearchAssociationsRequest.h
//  联想词搜索
//
//  Created by Pizza on 2017/2/14.
//  Copyright © 2017年 gxd. All rights reserved.
//

#import "BaseNetworkRequest.h"
#import "SearchAssociationsResponseInfo.h"

@interface SearchAssociationsRequest : BaseNetworkRequest
+ (void)searchAssociation:(NSString*)keyword handler:(RequestCompleteHandler)handler;
+ (void)searchHotKeyword:(RequestCompleteHandler)handler;
@end
