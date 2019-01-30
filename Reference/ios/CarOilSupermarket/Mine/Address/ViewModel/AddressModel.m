//
//  AddressModel.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/6.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel

- (void)setArea:(NSString *)area {
    
    _area = area;
    if (!_area) {
        _area = @"";
    }
}

- (NSString *)allAddress {
    
    return [NSString stringWithFormat:@"%@ %@ %@ %@", self.province, self.city, self.area, self.address];
}

@end
