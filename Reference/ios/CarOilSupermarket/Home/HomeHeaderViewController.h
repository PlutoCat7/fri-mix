//
//  HomeHeaderViewController.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/5.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeResponseInfo.h"

@interface HomeHeaderViewController : UIViewController

- (void)refreshWithBanners:(NSArray<HomeBannerInfo *> *)banners categorys:(NSArray<HomeCategoryInfo *> *)categorys notice:(NSString *)notice;

@end
