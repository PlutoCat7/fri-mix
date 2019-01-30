//
//  WithdrawDetailViewModel.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/21.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WithdrawDetailUIModel.h"

@interface WithdrawDetailViewModel : NSObject

@property (nonatomic, strong) WithdrawDetailUIModel *detailModel;

- (instancetype)initWithDetailId:(NSInteger)detailId;

- (void)getDetailInfoHanlder:(void(^)(NSString *errorMsg))hanlder;

@end
