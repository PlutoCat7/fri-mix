//
//  ShoppingCartViewModel.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/4.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShoppingCartModel.h"

@interface ShoppingCartViewModel : NSObject

//kvo
@property (nonatomic, strong, readonly) NSMutableArray<ShoppingCartModel *> *cellModels;
@property (nonatomic, copy, readonly) NSString *errorMsg;
// 解绑编辑状态
@property (nonatomic, assign) BOOL isEdit;

- (NSString *)shoppingTitle;

- (void)getNetData:(void(^)(NSError *error))hanlder;
- (CGFloat)selectGoodsPrice;
//是否有删除cell
- (BOOL)isSelectDeleteCell;
- (BOOL)isSelectAllDeleteCell;
//是否有选择的商品
- (BOOL)isSelectCell;
- (BOOL)isSelectAllCell;

#pragma mark

- (void)addGoodsQuantityWithIndexPath:(NSIndexPath *)indexPath count:(NSInteger)count handler:(void(^)(NSError *error))hanlder;
- (void)reduceGoodsQuantityWithIndexPath:(NSIndexPath *)indexPath count:(NSInteger)count handler:(void(^)(NSError *error))hanlder;
- (void)changeGoodsQuantityWithIndexPath:(NSIndexPath *)indexPath count:(NSInteger)count handler:(void(^)(NSError *error))hanlder;

- (void)startEdit;
- (void)cancelEdit;
- (void)selectWithIndexPath:(NSIndexPath *)indexPath;
- (void)selectAll;
- (void)deleteGoodsWithHandler:(void(^)(NSError *error))hanlder;
- (void)buyGoodsWithHandler:(void(^)(id data))hanlder;

@end
