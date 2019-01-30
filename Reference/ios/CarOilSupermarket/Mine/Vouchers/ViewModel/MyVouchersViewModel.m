//
//  MyVouchersViewModel.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/15.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "MyVouchersViewModel.h"


@interface MyVouchersViewModel ()

@property (nonatomic, strong) MyVouchersPageRequest *pageRequest;

@end

@implementation MyVouchersViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pageRequest = [[MyVouchersPageRequest alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vouchersBuyNotification) name:Notification_Vouchers_Buy_Success object:nil];
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

- (void)selectVouchersWithIndexPath:(NSIndexPath *)indexPath {
    
    MyVouchersInfo *info = self.pageRequest.responseInfo.items[indexPath.row];
    NSMutableArray *tmpList = [NSMutableArray arrayWithArray:self.selectedVouchersInfos];
    MyVouchersInfo *findHasInfo = nil;
    for (MyVouchersInfo *selectedInfo in self.selectedVouchersInfos) {
        if (selectedInfo.vouchersId == info.vouchersId) {
            findHasInfo = selectedInfo;
            break;
        }
    }
    if (!findHasInfo) {
        CGFloat nowPrice = 0;
        for (MyVouchersInfo *selectedInfo in self.selectedVouchersInfos) {
            nowPrice += selectedInfo.price;
        }
        if (nowPrice >= self.orderPrice) { //不需要再多选代金券了
            return;
        }
        [tmpList addObject:info];
        MyVouchersCellModel *cellModel = [self cellModelWithVoucherId:info.vouchersId];
        cellModel.isSelected = YES;
        self.selectedVouchersInfos = [tmpList copy];
        
    }else {
        [tmpList removeObject:findHasInfo];
        MyVouchersCellModel *cellModel = [self cellModelWithVoucherId:findHasInfo.vouchersId];
        cellModel.isSelected = NO;
        self.selectedVouchersInfos = [tmpList copy];
    }
}

#pragma mark - Notification

- (void)vouchersBuyNotification {
    
    [self getFirstPageDataWithHandler:nil];
}


#pragma mark - Private

- (void)handlerNetworkData:(NSArray<MyVouchersInfo *> *)infoList {
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:infoList.count];
    for (MyVouchersInfo *info in infoList) {
        MyVouchersCellModel *cellModel = [[MyVouchersCellModel alloc] init];
        cellModel.vouchersId = info.vouchersId;
        cellModel.title = info.title;
        cellModel.validDate = @"";
        cellModel.buyDate = info.buyTime;
        NSString *worthString = [NSString stringWithFormat:@"%@%td", info.prefix1, (NSInteger)info.price];
        NSMutableAttributedString *mutAttributedString = [[NSMutableAttributedString alloc] initWithString:worthString];
        [mutAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15*kAppScale] range:[worthString rangeOfString:info.prefix1]];
        cellModel.worthAttributedString = [mutAttributedString copy];
        for (MyVouchersInfo *selectedInfo in self.selectedVouchersInfos) {
            if (selectedInfo.vouchersId == info.vouchersId) {
                cellModel.isSelected = YES;
                break;
            }
        }
        
        [result addObject:cellModel];
    }
    self.cellModels = [result copy];
}

- (MyVouchersCellModel *)cellModelWithVoucherId:(NSInteger)vouchersId {
    
    for (MyVouchersCellModel *cellModel in self.cellModels) {
        if (cellModel.vouchersId == vouchersId) {
            return cellModel;
        }
    }
    return nil;
}

@end
