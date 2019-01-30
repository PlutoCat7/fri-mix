//
//  BindVercodeViewController.h
//  TiHouse
//
//  Created by 尚文忠 on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"
#import "CaptchaModel.h"

extern NSString * const editMobileSuccessNotification;

@interface BindVercodeViewController : BaseViewController

@property (nonatomic, copy) NSString *verCode;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, strong) CaptchaModel *captchaModel;

@end
