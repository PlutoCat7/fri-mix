//
//  Budget.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/24.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "Budget.h"
#import "House.h"
@implementation Budget

-(instancetype)initWithHouse:(House *)house{
    if (self = [super init]) {
        _house = house;
        _isLoading = NO;
    }
    return self;
}


- (NSString *)NewBudgetToPath{
    return @"api/inter/budget/add";
}
- (NSDictionary *)NewBudgetToParams{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:_budgetname forKey:@"budgetname"];
    [dic setObject:@(_amountqwzj) forKey:@"amountqwzj"];
    [dic setObject:@(_house.houseid) forKey:@"houseid"];
    [dic setObject:@(_area) forKey:@"area"];
    [dic setObject:@(_numroom) forKey:@"numroom"];
    [dic setObject:@(_numhall) forKey:@"numhall"];
    [dic setObject:@(_numkichen) forKey:@"numkichen"];
    [dic setObject:@(_numtoilet) forKey:@"numtoilet"];
    [dic setObject:@(_numbalcony) forKey:@"numbalcony"];
    [dic setObject:@(_regionid) forKey:@"regionid"];
    [dic setObject:@(_type) forKey:@"type"];
    [dic setObject:@(_lev) forKey:@"lev"];
    
    return dic;
}


- (NSString *)RemoveBudgetToPath{
    return @"api/inter/budget/remove";
}
- (NSDictionary *)RemoveBudgetToParams{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:@(_budgetid) forKey:@"budgetid"];
    return [dic copy];
}


+(NSString *)TipStr:(Budget *)Budget{
    NSString *str;
    if (Budget.budgetname.length<=0) {
        str = @"请给预算命个名称吧！";
    }
    if (Budget.amountqwzj<=0) {
        str = @"写个总价格吧！";
    }
    if (!Budget.regionid) {
        str = @"在哪里哦！";
    }
    if (!Budget.area) {
        str = @"填写装修面积！";
    }
    if (!Budget.numroom && !Budget.numhall && !Budget.numkichen  && !Budget.numtoilet  && !Budget.numbalcony ) {
        str = @"填写房屋类型！";
    }
    return str;
}

@end

