//
//  ShoppingCartViewModel.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/4.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "ShoppingCartViewModel.h"
#import "ShoppingRequest.h"
#import "OrderRequest.h"

@interface ShoppingCartViewModel ()

@property (nonatomic, strong) ShoppingListInfo *info;
@property (nonatomic, copy) NSString *errorMsg;

@property (nonatomic, strong) NSMutableArray<ShoppingCartModel *> *cellModels;

@end

@implementation ShoppingCartViewModel

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadCacheData];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationShoppingAdd) name:Notification_Shoping_Add object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationUserLoginIn) name:Notification_Has_Login_In object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationUserLoginOut) name:Notification_Has_Login_Out object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationOrderCreate) name:Notification_Order_Create object:nil];
    }
    return self;
}

- (void)getNetData:(void(^)(NSError *error))hanlder {
    
    if (![LogicManager isUserLogined]) {
        self.errorMsg = @"请先登录";
        self.cellModels = nil;
        BLOCK_EXEC(hanlder, nil);
        return;
    }
    
    [ShoppingRequest getShoppingInfoWithHandler:^(id result, NSError *error) {
        
        if (error) {
            self.errorMsg = error.domain;
        }else {
            self.info = result;
            [self.info saveCache];
            [self handlerNetworkData:self.info.list];
        }
        BLOCK_EXEC(hanlder, error);
    }];
}

- (NSString *)shoppingTitle {
    
    if (self.cellModels.count == 0) {
        return @"购物车";
    }else {
        return [NSString stringWithFormat:@"购物车(%td)", self.cellModels.count];
    }
}

- (CGFloat)selectGoodsPrice {
    
    CGFloat price = 0.0;
    for (ShoppingCartModel *model in self.cellModels) {
        if (model.isSelect) {
            price += [model goodsTotalPrice];
        }
    }
    return price;
}

//是否有删除cell
- (BOOL)isSelectDeleteCell {
    
    for(NSInteger index=0; index<self.cellModels.count; index++) {
        ShoppingCartModel *model = self.cellModels[index];
        if (model.isEdit && model.isDeleteSelect) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isSelectAllDeleteCell {
    
    for(NSInteger index=0; index<self.cellModels.count; index++) {
        ShoppingCartModel *model = self.cellModels[index];
        if (model.isEdit && !model.isDeleteSelect) {
            return NO;
        }
    }
    return YES;
}

//是否有选择的商品
- (BOOL)isSelectCell {
    
    for(NSInteger index=0; index<self.cellModels.count; index++) {
        ShoppingCartModel *model = self.cellModels[index];
        if (model.isSelect) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isSelectAllCell {
    
    for(NSInteger index=0; index<self.cellModels.count; index++) {
        ShoppingCartModel *model = self.cellModels[index];
        if (!model.isSelect) {
            return NO;
        }
    }
    return YES;
}

- (void)addGoodsQuantityWithIndexPath:(NSIndexPath *)indexPath count:(NSInteger)count handler:(void(^)(NSError *error))hanlder {
    
    ShoppingCartModel *model = [self.cellModels objectAtIndex:indexPath.row];
    
    [ShoppingRequest addToShoppingWithGoodId:model.goodsId number:count handler:^(id result, NSError *error) {
        ShoppingInfo *info = self.info.list[indexPath.row];
        if (error) {
            self.errorMsg = error.domain;
        }else {
            model.total += count;
            info.total = model.total;
            [self.info saveCache];
            
            [self willChangeValueForKey:@"cellModels"];
            [self didChangeValueForKey:@"cellModels"];
        }
        BLOCK_EXEC(hanlder, error)
    }];
}

- (void)reduceGoodsQuantityWithIndexPath:(NSIndexPath *)indexPath count:(NSInteger)count handler:(void(^)(NSError *error))hanlder {
    
    ShoppingCartModel *model = [self.cellModels objectAtIndex:indexPath.row];
    
    [ShoppingRequest reduceToShoppingWithGoodId:model.goodsId number:count handler:^(id result, NSError *error) {
        ShoppingInfo *info = self.info.list[indexPath.row];
        if (error) {
            self.errorMsg = error.domain;
        }else {
            model.total -= count;;
            info.total = model.total;
            [self.info saveCache];
            
            [self willChangeValueForKey:@"cellModels"];
            [self didChangeValueForKey:@"cellModels"];
        }
        BLOCK_EXEC(hanlder, error)
    }];
}

- (void)changeGoodsQuantityWithIndexPath:(NSIndexPath *)indexPath count:(NSInteger)count handler:(void(^)(NSError *error))hanlder {
    
    ShoppingCartModel *model = [self.cellModels objectAtIndex:indexPath.row];
   
    if (count-model.total>0) {
        [self addGoodsQuantityWithIndexPath:indexPath count:count-model.total handler:hanlder];
    }else if (count-model.total<0) {
        [self reduceGoodsQuantityWithIndexPath:indexPath count:model.total-count handler:hanlder];
    }else {
        BLOCK_EXEC(hanlder, nil);
    }
}

- (void)startEdit {
    
    self.isEdit = YES;
    [self willChangeValueForKey:@"cellModels"];
    for (ShoppingCartModel *model in self.cellModels) {
        model.isEdit = YES;
    }
    [self didChangeValueForKey:@"cellModels"];
}

- (void)cancelEdit {
    
    self.isEdit = NO;
    [self willChangeValueForKey:@"cellModels"];
    for (ShoppingCartModel *model in self.cellModels) {
        model.isEdit = NO;
        model.isDeleteSelect = NO;
    }
    [self didChangeValueForKey:@"cellModels"];
}

- (void)selectWithIndexPath:(NSIndexPath *)indexPath {
    
    [self willChangeValueForKey:@"cellModels"];
    ShoppingCartModel *model = [self.cellModels objectAtIndex:indexPath.row];
    if (model.isEdit) {
        model.isDeleteSelect = !model.isDeleteSelect;
    }else {
        model.isSelect = !model.isSelect;
    }
    [self didChangeValueForKey:@"cellModels"];
}

- (void)selectAll {
    
    [self willChangeValueForKey:@"cellModels"];
    BOOL willSelect = NO;
    if (self.isEdit) {
        willSelect = ![self isSelectAllDeleteCell];
    }else {
        willSelect = ![self isSelectAllCell];
    }
    
    for (ShoppingCartModel *model in self.cellModels) {
        if (model.isEdit) {
            model.isDeleteSelect = willSelect;
        }else {
            model.isSelect = willSelect;
        }
    }
    [self didChangeValueForKey:@"cellModels"];
}

- (void)deleteGoodsWithHandler:(void(^)(NSError *error))hanlder {
    
    NSMutableArray *deleteIds = [NSMutableArray arrayWithCapacity:1];
    NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
    for (NSInteger index=0; index<self.cellModels.count; index++) {
        ShoppingCartModel *model = self.cellModels[index];
        if (model.isEdit && model.isDeleteSelect) {
            [deleteIds addObject:@(model.shoppingId)];
            [indexSet addIndex:index];
        }
    }
    if (deleteIds.count <= 0) {
        BLOCK_EXEC(hanlder, nil);
    }
    [ShoppingRequest removeFromShoppingWithGoodIds:deleteIds handler:^(id result, NSError *error) {
        
        if (error) {
            self.errorMsg = error.domain;
        }else {
            self.isEdit = NO;
            NSMutableArray *tmpList = [NSMutableArray arrayWithArray:self.info.list];
            [tmpList removeObjectsAtIndexes:indexSet];
            self.info.list = [tmpList copy];
            [self.info saveCache];
            
            [self.cellModels removeObjectsAtIndexes:indexSet];
            [self cancelEdit];
        }
        BLOCK_EXEC(hanlder, error)
    }];
    
}
- (void)buyGoodsWithHandler:(void(^)(id data))hanlder {
    
    NSMutableArray *selectIdList = [NSMutableArray arrayWithCapacity:1];
    for (NSInteger index=0; index<self.cellModels.count; index++) {
        ShoppingCartModel *model = self.cellModels[index];
        if (model.isSelect) {
            [selectIdList addObject:@(model.shoppingId).stringValue];
        }
    }
    [OrderRequest confirmOrderWithIds:[selectIdList copy] handler:^(id result, NSError *error) {
        
        if (error) {
            self.errorMsg = error.domain;
        }
        BLOCK_EXEC(hanlder, result);
    }];
}

#pragma mark - Notification

- (void)notificationShoppingAdd {
    
    [self getNetData:nil];
}

- (void)notificationUserLoginIn {
    
    [self getNetData:nil];
}

- (void)notificationUserLoginOut {
    
    //清空购物车
    self.cellModels = nil;
}

- (void)notificationOrderCreate {
    
    [self getNetData:nil];
}

#pragma mark - Private

- (void)loadCacheData {
    
    self.info = [ShoppingListInfo loadCache];
    [self handlerNetworkData:self.info.list];
}

- (void)handlerNetworkData:(NSArray<ShoppingInfo *> *)infos {
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:infos.count];
    for (ShoppingInfo *info in infos) {
        
        ShoppingCartModel *model = [[ShoppingCartModel alloc] init];
        model.shoppingId = info.shoppingId;
        model.total = info.total;
        model.goodsId = info.goodsId;
        model.stock = info.stock;
        model.maxbuy = info.maxbuy;
        model.title = info.title;
        model.thumb = info.thumb;
        model.marketprice = info.marketprice;
        model.productprice = info.productprice;
        
        [result addObject:model];
    }
    self.cellModels = result;
}

@end
