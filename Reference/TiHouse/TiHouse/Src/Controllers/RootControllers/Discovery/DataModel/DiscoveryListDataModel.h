//
//  DiscoveryListDataModel.h
//  TiHouse
//
//  Created by Teen Ma on 2018/4/17.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FindAssemarcInfo.h"
#import "DiscoveryAdvertisementsDataModel.h"

@interface DiscoveryListDataModel : NSObject

@property (nonatomic, strong  ) NSArray<FindAssemarcInfo *> *assemarcList;
@property (nonatomic, strong  ) NSArray<DiscoveryAdvertisementsDataModel *> *assemadvertList;
@property (nonatomic, strong  ) NSArray<NSString *> *sortRules;

@end
