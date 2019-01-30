//
//  GBPersonReginViewController.h
//  GB_Football
//
//  Created by 王时温 on 2017/4/18.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBBaseViewController.h"

@interface GBPersonReginViewController : GBBaseViewController

@property (nonatomic, assign) BOOL isShowSelectRegion;

- (instancetype)initWithAreaList:(NSArray<AreaInfo *> *)areaList selectRegion:(NSString *)regionName;

@end
