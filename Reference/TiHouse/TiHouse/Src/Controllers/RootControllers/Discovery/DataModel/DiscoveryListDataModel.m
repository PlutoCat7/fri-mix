//
//  DiscoveryListDataModel.m
//  TiHouse
//
//  Created by Teen Ma on 2018/4/17.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "DiscoveryListDataModel.h"

@implementation DiscoveryListDataModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"assemarcList" : [FindAssemarcInfo class],
             @"assemadvertList" : [DiscoveryAdvertisementsDataModel class]
             };
}


@end
