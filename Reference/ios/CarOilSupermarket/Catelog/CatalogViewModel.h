//
//  CatalogViewModel.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/13.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CatalogModel.h"

@interface CatalogViewModel : NSObject

@property (nonatomic, strong, readonly) NSArray<CatalogModel *> *datas;

- (void)getNetworkDataWithHandler:(void(^)(NSError *error))handler;

- (void)enterDetailViewWithNavigationController:(UINavigationController *)nav indexPath:(NSIndexPath *)indexPath;

@end
