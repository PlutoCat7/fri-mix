//
//  BaseViewController.h
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/15.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewControllerProtocol.h"

@interface BaseViewController : UIViewController<BaseViewControllerProtocol>

/**
 *  VIEW是否渗透导航栏
 * (YES_VIEW渗透导航栏下／NO_VIEW不渗透导航栏下)
 */
@property (assign,nonatomic) BOOL isExtendLayout;

@end
