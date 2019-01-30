//
//  SMSVerificationCodeResponse.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/16.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "COSResponseInfo.h"

@interface SMSVerificationCodeInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger lifeSecond;   // 有效期秒数，用于倒计时

@end

@interface SMSVerificationCodeResponse : COSResponseInfo

@property (nonatomic, strong) SMSVerificationCodeInfo *data;

@end
