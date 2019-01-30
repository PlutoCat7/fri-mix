//
//  CaptchaResponse.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/27.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "COSResponseInfo.h"

@interface CaptchaInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger captchaId;
@property (nonatomic, copy) NSString *url;

//图片验证码，  用户输入
@property (nonatomic, copy) NSString *imageCode;

@end

@interface CaptchaResponse : COSResponseInfo

@property (nonatomic, strong) CaptchaInfo *data;

@end
