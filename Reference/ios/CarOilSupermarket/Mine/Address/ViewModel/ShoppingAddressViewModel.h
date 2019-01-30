//
//  ShoppingAddressViewModel.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/6.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AddressModel.h"
#import "AddressListResponse.h"

@interface ShoppingAddressViewModel : NSObject

//kvo
@property (nonatomic, strong, readonly) NSMutableArray<AddressModel *> *cellModels;
@property (nonatomic, copy, readonly) NSString *errorMsg;

- (void)getAddressList:(void(^)(NSError *error))hanlder;
- (void)setDefaultAddressWithIndexPath:(NSIndexPath *)indexPath handler:(void(^)(NSError *error))hanlder;
- (void)deleteAddressWithIndexPath:(NSIndexPath *)indexPath handler:(void(^)(NSError *error))hanlder;

- (AddressInfo *)addressInfoWithIndexPath:(NSIndexPath *)indexPath;

@end
