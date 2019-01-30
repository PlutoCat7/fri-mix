//
//  WithdrawOptionResponse.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/21.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "COSResponseInfo.h"

//"info": "提现需人工审核，请耐心等待。",
//"min": "100", // 可输入最小值
//"max": "2975.00" //可输入最大值


@interface WithdrawOptionInfo : YAHActiveObject

@property (nonatomic, copy) NSString *info;
@property (nonatomic, assign) CGFloat min;
@property (nonatomic, assign) CGFloat max;

@end

@interface WithdrawOptionData : YAHActiveObject

@property (nonatomic, strong) WithdrawOptionInfo *opt;

@end

@interface WithdrawOptionResponse : COSResponseInfo

@property (nonatomic, strong) WithdrawOptionData *data;

@end
