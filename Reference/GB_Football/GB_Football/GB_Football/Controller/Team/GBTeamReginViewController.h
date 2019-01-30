//
//  GBTeamReginViewController.h
//  GB_Football
//
//  Created by gxd on 17/7/24.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBBaseViewController.h"

@interface GBTeamReginViewController : GBBaseViewController

@property (nonatomic,copy) void(^saveBlock)(AreaInfo *province, AreaInfo *city, AreaInfo *region);
@property (nonatomic, assign) BOOL isShowSelectRegion;

- (instancetype)initWithAreaList:(NSArray<AreaInfo *> *)areaList selectRegion:(NSString *)regionName level:(NSInteger)level;

@end
