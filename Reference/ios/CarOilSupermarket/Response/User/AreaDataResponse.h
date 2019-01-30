//
//  AreaDataResponse.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/5.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "COSResponseInfo.h"

@interface AreaDataInfo : YAHActiveObject

@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *downloadUrl;

@end

@interface AreaDataResponse : COSResponseInfo

@property (nonatomic, strong) AreaDataInfo *data;

@end
