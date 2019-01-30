//
//  BudgetThreeClass.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/25.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BudgetThreeClass.h"
#import <objc/runtime.h>

static void *YHModelCachedPropertyKeysKey = &YHModelCachedPropertyKeysKey;

@implementation BudgetThreeClass

- (id)copyWithZone:(NSZone *)zone {
//    BudgetThreeClass *model = [[BudgetThreeClass allocWithZone:zone] init];
//    model.amountzj = self.amountzj;
//    model.budgetid = self.budgetid;
//    model.budgetproid = self.budgetproid;
//    model.cateoneid = self.cateoneid;
//    model.catethreestatus = self.catethreestatus;
//    model.catetwoid = self.catetwoid;
//    model.catetwostatus = self.catetwostatus;
//    model.proname = self.proname;
//    model.proremark = self.proremark;
//    model.protypexb = self.protypexb;
//    model.protypeyg = self.protypeyg;
//    model.doubleamountzj = self.doubleamountzj;
//    model.catethreetipb = self.catethreetipb;
//    model.catethreetipa = self.catethreetipa;
//    model.catethreeunit = self.catethreeunit;
//    model.catethreepricelow = self.catethreepricelow;
//    model.catethreepricemid = self.catethreepricemid;
//    model.catethreepricehig = self.catethreepricehig;
//    model.pronum = self.pronum;
//    model.proamountunit = self.proamountunit;
//    return model;
    
    BudgetThreeClass *result = [[[self class] allocWithZone:zone] init];
    
    NSArray *propertyNames = [[self class] p_propertyKeys].allObjects;
    for (NSString *propertyName in propertyNames) {
        id propertyValue = [self valueForKey:propertyName];
        if ([propertyValue respondsToSelector:@selector(copyWithZone:)]) {
            propertyValue = [propertyValue copyWithZone:zone];
        }
        [result setValue:propertyValue forKey:propertyName];
    }
    return result;
    
}

#pragma mark - Private

+ (NSSet *)p_propertyKeys {
    
    NSSet *cachedKeys = objc_getAssociatedObject(self, YHModelCachedPropertyKeysKey);
    if (cachedKeys != nil) return cachedKeys;
    
    NSMutableSet *keys = [NSMutableSet set];
    unsigned int propertyCount = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &propertyCount);
    for (int i=0; i<propertyCount; i++) {
        objc_property_t *property = propertyList + i;
        NSString *propertyName = [NSString stringWithCString:property_getName(*property) encoding:NSUTF8StringEncoding];
        [keys addObject:propertyName];
    }
    free(propertyList);
    objc_setAssociatedObject(self, YHModelCachedPropertyKeysKey, keys, OBJC_ASSOCIATION_COPY);
    
    return keys;
}





//添加预算项目
- (NSString *)AddBudgetPortoPath{
    return @"api/inter/budgetpro/add";
}
- (NSDictionary *)AddBudgetPorParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@(_budgetid) forKey:@"budgetid"];
    [dic setValue:_proname forKey:@"proname"];
    [dic setValue:@(_amountzj) forKey:@"amountzj"];
    [dic setValue:@(_protypexb) forKey:@"protypexb"];
    [dic setValue:@(_protypeyg) forKey:@"protypeyg"];
    [dic setValue:_proremark forKey:@"proremark"];
    [dic setValue:@(_catetwoid) forKey:@"catetwoid"];
//    [dic setValue:@(_pronum) forKey:@"pronum"];
    return [dic copy];
}
//编辑预算项目
- (NSString *)EidtBudgetPortoPath{
    return @"api/inter/budgetpro/edit";
}
- (NSDictionary *)EidtBudgetPorParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@(_budgetproid) forKey:@"budgetproid"];
    [dic setValue:@(_amountzj) forKey:@"amountzj"];
    [dic setValue:@(_protypexb) forKey:@"protypexb"];
    [dic setValue:@(_protypeyg) forKey:@"protypeyg"];
    [dic setValue:_proremark forKey:@"proremark"];
    [dic setValue:@(_pronum) forKey:@"pronum"];
    [dic setValue:@(_proamountunit) forKey:@"proamountunit"];
    return [dic copy];
}

//删除预算项目
- (NSString *)RemoveBudgetPortoPath{
    return @"api/inter/budgetpro/remove";
}
- (NSDictionary *)RemoveBudgetPorParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@(_budgetproid) forKey:@"budgetproid"];
    return [dic copy];
}


@end
