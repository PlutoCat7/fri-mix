//
//  WithdrawDetailViewModel.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/21.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "WithdrawDetailViewModel.h"

#import "BalanceRequest.h"

@interface WithdrawDetailViewModel ()

@property (nonatomic, assign) NSInteger detailId;

@end

@implementation WithdrawDetailViewModel

- (instancetype)initWithDetailId:(NSInteger)detailId {
    
    self = [super init];
    if (self) {
        _detailId = detailId;
    }
    
    return self;
}

- (void)getDetailInfoHanlder:(void(^)(NSString *errorMsg))hanlder {
    
    [BalanceRequest getWithdrawWithId:self.detailId handler:^(id result, NSError *error) {
        
        if (error) {
            BLOCK_EXEC(hanlder, error.domain);
        }else {
            WithdrawDetailInfo *info = result;
            [self handlerDataWith:info];
            BLOCK_EXEC(hanlder, nil);
        }
    }];
}

#pragma mark - Private

- (void)handlerDataWith:(WithdrawDetailInfo *)info {
    
    WithdrawDetailUIModel *uiModel = [[WithdrawDetailUIModel alloc] init];
    uiModel.bank = info.bank;
    uiModel.money = [NSString stringWithFormat:@"%@ %@", info.prefix1, info.money];
    uiModel.status = info.status;
    uiModel.userName = info.name;
    uiModel.account = info.acc;
    uiModel.mobile = info.mobile;
    uiModel.createDateString = info.fTime;
    uiModel.contactUs = [NSString stringWithFormat:@"如有疑问请咨询 : %@", info.contact];
    
    self.detailModel = uiModel;
}

@end
