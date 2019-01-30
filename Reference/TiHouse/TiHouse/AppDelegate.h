//
//  AppDelegate.h
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/15.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WXApi.h>
#import <UMSocialCore/UMSocialCore.h>
//#import "UMSocial.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)setupTabViewController;
- (void)setRootViewController;
@end

