//
//  AddressModel.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/6.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YAHActiveObject.h"

@interface AddressModel : YAHActiveObject

@property (nonatomic, copy) NSString *addressId;
@property (nonatomic, copy) NSString *realname;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) BOOL isdefault;

- (NSString *)allAddress;

@end
