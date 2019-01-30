//
//  BalanceDetailsViewModel.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/21.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "BalanceDetailsViewModel.h"
#import "BalanceDetailsRequest.h"

@interface BalanceDetailsViewModel ()

@property (nonatomic, strong) NSArray<BalanceDetailsCellModel *> *cellModels;
@property (nonatomic, strong) BalanceDetailsRequest *pageRequest;

@end

@implementation BalanceDetailsViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pageRequest = [[BalanceDetailsRequest alloc] init];
    }
    return self;
}

#pragma mark - Public

- (void)getFirstPageDataWithHandler:(void(^)(NSError *error))handler {
    
    [self.pageRequest reloadPageWithHandle:^(id result, NSError *error) {
        
        if (!error) {
            [self handlerNetworkData:self.pageRequest.responseInfo.items];
        }
        BLOCK_EXEC(handler, error);
    }];
}
- (void)getNextPageDataWithHandler:(void(^)(NSError *error))handler {
    
    [self.pageRequest loadNextPageWithHandle:^(id result, NSError *error) {
        if (!error) {
            [self handlerNetworkData:self.pageRequest.responseInfo.items];
        }
        BLOCK_EXEC(handler, error);
    }];
}

- (BOOL)isLoadEnd {
    
    return self.pageRequest.isLoadEnd;
}

#pragma mark - Private

- (void)handlerNetworkData:(NSArray<BalanceDetailsInfo *> *)infoList {
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:infoList.count];
    for (BalanceDetailsInfo *info in infoList) {
        BalanceDetailsCellModel *cellModel = [[BalanceDetailsCellModel alloc] init];
        cellModel.name = info.remark;
        cellModel.dateString = info.fTime;
        cellModel.money = [NSString stringWithFormat:@"%@%@", info.prefix1, info.money];
        cellModel.moneyColor = [info.prefix1 isEqualToString:@"+"]?[UIColor colorWithHex:0x14b0ff]:[UIColor blackColor];
        cellModel.state = info.status;
        cellModel.detailId = info.balanceDetailsId;
        cellModel.canSelect = info.type==1;
        
        [result addObject:cellModel];
    }
    self.cellModels = [result copy];
}


@end
