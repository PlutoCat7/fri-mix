//
//  CaptchaViewController.h
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"
@class CaptchaModel;

@interface CaptchaViewController : BaseViewController

@property (nonatomic, copy) void(^block)(NSString *);
@property (nonatomic, copy) void(^captchaCallback)(CaptchaModel *model);

@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, assign) BOOL isRegister;

@end
