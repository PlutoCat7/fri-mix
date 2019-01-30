//
//  AddresManager.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/8.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Province.h"
#import "City.h"
#import "Region.h"
#import "ItemModel.h"

typedef  NS_ENUM(NSInteger ,GoToAddresPathType){
    GoToPathTypeProvince = 1,
    GoToPathTypeCity,
    GoToPathTypeRegion,
    GoToPathTypeRests
};
@interface AddresManager : NSObject

@property (nonatomic, retain) Province *province;
@property (nonatomic, retain) City *city;
@property (nonatomic, retain) Region *region;
@property (nonatomic, retain) id item;
@property (nonatomic, retain) NSMutableArray *address, *titles;
@property (nonatomic, assign) GoToAddresPathType GoToAddres;

- (NSString *)toPath;
- (NSMutableDictionary *)toParams;

@end
