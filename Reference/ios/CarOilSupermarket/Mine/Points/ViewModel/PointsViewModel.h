//
//  PointsViewModel.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/18.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PointsCellModel;

@interface PointsViewModel : NSObject

@property (nonatomic, strong, readonly) NSArray<PointsCellModel *> *cellModels;
@property (nonatomic, copy) NSString *infos;

- (void)getFirstPageDataWithHandler:(void(^)(NSError *error))handler;
- (void)getNextPageDataWithHandler:(void(^)(NSError *error))handler;

- (BOOL)isLoadEnd;

@end
