//
//  ShoppingAddressViewModel.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/6.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "ShoppingAddressViewModel.h"

#import "UserRequest.h"

@interface ShoppingAddressViewModel ()

@property (nonatomic, strong) NSMutableArray<AddressInfo *> *addressInfoList;

@property (nonatomic, strong) NSMutableArray<AddressModel *> *cellModels;
@property (nonatomic, copy) NSString *errorMsg;

@end

@implementation ShoppingAddressViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAddress) name:Notification_Address_Add_OR_Edit object:nil];
    }
    return self;
}

- (void)getAddressList:(void(^)(NSError *error))hanlder {
    
    [UserRequest getAddressListWithHandler:^(id result, NSError *error) {
       
        if (error) {
            self.errorMsg = error.domain;
        }else {
            self.addressInfoList = [NSMutableArray arrayWithArray:result];
            [self handlerNetworkData:[self.addressInfoList copy]];
        }
        BLOCK_EXEC(hanlder, error);
    }];
}
- (void)setDefaultAddressWithIndexPath:(NSIndexPath *)indexPath handler:(void(^)(NSError *error))hanlder {
    
    AddressModel *model = [self.cellModels objectAtIndex:indexPath.row];
    if (model.isdefault || !model) {
        BLOCK_EXEC(hanlder, nil);
        return;
    }
    [UserRequest setDefaultAddressWithAddressId:model.addressId handler:^(id result, NSError *error) {
        if (error) {
            self.errorMsg = error.domain;
        }else {
            for (AddressModel *tmpModel in self.cellModels) { //清除旧的默认地址
                tmpModel.isdefault = NO;
                NSInteger index = [self.cellModels indexOfObject:model];
                self.addressInfoList[index].isdefault = NO;
            }
            [self willChangeValueForKey:@"cellModels"];
            model.isdefault = YES;
            [self didChangeValueForKey:@"cellModels"];
            
            NSInteger index = [self.cellModels indexOfObject:model];
            self.addressInfoList[index].isdefault = YES;
        }
        BLOCK_EXEC(hanlder, error);
    }];
}

- (void)deleteAddressWithIndexPath:(NSIndexPath *)indexPath handler:(void(^)(NSError *error))hanlder {
    
    AddressModel *model = [self.cellModels objectAtIndex:indexPath.row];
    if (!model) {
        BLOCK_EXEC(hanlder, nil);
        return;
    }
    [UserRequest deleteAddressWithAddressId:model.addressId handler:^(id result, NSError *error) {
        if (error) {
            self.errorMsg = error.domain;
        }else {
            [self.addressInfoList removeObjectAtIndex:indexPath.row];
            [self.cellModels removeObject:model];
        }
        BLOCK_EXEC(hanlder, error);
    }];
}

- (AddressInfo *)addressInfoWithIndexPath:(NSIndexPath *)indexPath {
    
    AddressInfo *info = self.addressInfoList[indexPath.row];
    return info;
}

#pragma mark - NSNotidication

- (void)notificationAddress {
    
    [self getAddressList:nil];
}

#pragma mark - Private

- (void)handlerNetworkData:(NSArray<AddressInfo *> *)infos {
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:infos.count];
    for (AddressInfo *info in infos) {
        
        AddressModel *model = [[AddressModel alloc] init];
        model.addressId = info.addressId;
        model.realname = info.realname;
        model.mobile = info.mobile;
        model.province = info.province;
        model.city = info.city;
        model.area = info.area;
        model.address = info.address;
        model.isdefault = info.isdefault;
        [result addObject:model];
    }
    self.cellModels = result;
}

@end
