//
//  PointsViewModel.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/18.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "PointsViewModel.h"
#import "MyPointsPageRequest.h"
#import "PointsCellModel.h"

@interface PointsViewModel ()

@property (nonatomic, strong) NSArray<PointsCellModel *> *cellModels;
@property (nonatomic, strong) MyPointsPageRequest *pageRequest;

@end

@implementation PointsViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pageRequest = [[MyPointsPageRequest alloc] init];
    }
    return self;
}

#pragma mark - Public

- (void)getFirstPageDataWithHandler:(void(^)(NSError *error))handler {
    
    [self.pageRequest reloadPageWithHandle:^(id result, NSError *error) {
        
        if (!error) {
            MyPointsPageResponse *response = (MyPointsPageResponse *)result;
            self.infos = response.data.info;
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

- (void)handlerNetworkData:(NSArray<MyPointsInfo *> *)infoList {
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:infoList.count];
    for (MyPointsInfo *info in infoList) {
        PointsCellModel *cellModel = [[PointsCellModel alloc] init];
        cellModel.name = info.remark;
        cellModel.dateString = info.fTime;
        cellModel.point = [NSString stringWithFormat:@"%@%@", info.prefix1, info.point];
        cellModel.pointColor = [info.prefix1 isEqualToString:@"+"]?[UIColor colorWithHex:0xE43937]:[UIColor colorWithHex:0x898A8B];
        
        [result addObject:cellModel];
    }
    self.cellModels = [result copy];
}

@end
