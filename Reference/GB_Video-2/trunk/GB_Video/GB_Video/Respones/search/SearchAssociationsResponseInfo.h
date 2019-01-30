//
//  SearchAssociationsResponseInfo.h
//  GB_TransferMarket
//
//  Created by Pizza on 2017/2/14.
//  Copyright © 2017年 gxd. All rights reserved.
//

#import "GBResponseInfo.h"


@interface SearchAssociationsResponseInfo : GBResponseInfo
@property (nonatomic, strong) NSArray<NSString *> *data;
@end
