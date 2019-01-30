//
//  HomeViewControllerViewModel.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/8.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeResponseInfo.h"

@interface HomeViewControllerViewModel : NSObject

@property (nonatomic, strong) HomeNetworkData *homeData;
@property (nonatomic, strong) NSArray<NSArray<HomeGoodsInfo *> *> *showGoodsList;

- (void)getNetworkDataWithHandler:(void(^)(NSError *error))handler;

@end
