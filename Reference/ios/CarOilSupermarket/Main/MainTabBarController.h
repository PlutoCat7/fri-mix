//
//  MainTabBarController.h
//  MagicBean
//
//  Created by yahua on 16/3/3.
//  Copyright © 2016年 wangsw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"
#import "LeftMenuViewController.h"

@interface MainTabBarController : UITabBarController <IIViewDeckControllerDelegate>

@property (nonatomic, weak) LeftMenuViewController *leftVC;

@end
