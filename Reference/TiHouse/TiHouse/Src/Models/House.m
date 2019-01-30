//
//  House.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/10.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#define kRecordHouse  @"RecordHouse"
#define kRecordHouseNumRecord @"kRecordHouseNumRecord"

#import "House.h"

@implementation House


- (NSString *)AddHousetoPath{
    return _edit ? @"api/inter/house/edit" : @"api/inter/house/add";
}

-(NSDictionary *)AddHousetoParams{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:_housename forKey:@"housename"];
    [dic setValue:_residentname forKey:@"residentname"];
    [dic setValue:[NSString stringWithFormat:@"%ld",_area] forKey:@"area"];
    [dic setValue:[NSString stringWithFormat:@"%ld",_numroom] forKey:@"numroom"];
    [dic setValue:[NSString stringWithFormat:@"%ld",_numhall] forKey:@"numhall"];
    [dic setValue:[NSString stringWithFormat:@"%ld",_numkichen] forKey:@"numkichen"];
    [dic setValue:[NSString stringWithFormat:@"%ld",_numtoilet] forKey:@"numtoilet"];
    [dic setValue:[NSString stringWithFormat:@"%ld",_numbalcony] forKey:@"numbalcony"];
    [dic setValue:[NSString stringWithFormat:@"%ld",_regionid] forKey:@"regionid"];
    [dic setValue:[NSString stringWithFormat:@"%ld",_typerelation] forKey:@"typerelation"];
    [dic setValue:[NSString stringWithFormat:@"%ld",_houseid] forKey:@"houseid"];
    [dic setValue:_addrname forKey:@"addrname"];
    [dic setValue:_halfurlfront forKey:@"urlfront"];
    [dic setValue:_halfurlback forKey:@"urlback"];
    
    return dic;
}


-(NSString *)TipStr{
    NSString *TipStr;
    if (!self.housename.length) {
        TipStr = @"请填写房屋名称！";
    }
    if (!self.residentname.length) {
        TipStr = @"请填写小区！";
    }
    if (!self.numroom && !self.numroom && !self.numhall && !self.numkichen && !self.numtoilet && !self.numbalcony) {
        TipStr = @"请选择房屋类型！";
    }
    if (!self.regionid) {
        TipStr = @"请选择地区！";
    }
//    if (!self.typerelation) {
//        TipStr = @"请选择您与房屋的关系！";
//    }
    return TipStr;
}


+ (instancetype)getRecordHouse{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    long houseid = [[defaults objectForKey:kRecordHouse] longLongValue];
    NSInteger housenumrecord = [[defaults objectForKey:kRecordHouseNumRecord] integerValue];
    House *house = [[House alloc]init];
    house.houseid = houseid;
    house.numrecord = housenumrecord;
    return house;
}

+(void)setgetRecordWithHouseid:(long)houseid housenumrecord:(NSInteger)housenumrecord{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(houseid) forKey:kRecordHouse];
    [defaults setObject:@(housenumrecord) forKey:kRecordHouseNumRecord];
    [defaults synchronize];
}


@end

