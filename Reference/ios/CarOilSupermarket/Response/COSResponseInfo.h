//
//  COSResponseInfo.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/6.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "YAHDataResponseInfo.h"
#import "GBRespDefine.h"

@interface COSResponseInfo : YAHDataResponseInfo

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSString *msg;

/**
 * @brief 重置数据
 */
- (void)resetResponseInfo;

@end
