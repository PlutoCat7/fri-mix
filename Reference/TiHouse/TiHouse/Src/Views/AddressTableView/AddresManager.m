//
//  AddresManager.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/8.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AddresManager.h"

@implementation AddresManager

-(NSMutableArray *)address{
    
    if (!_address) {
        _address = [NSMutableArray array];
    }
    return _address;
}

-(void)setItem:(id)item{
    
    ItemModel *_curModel = [[ItemModel alloc]init];
    if ([item isKindOfClass:[Province class]]) {
        Province *pro = item;
        _curModel.Title = pro.provname;
        _curModel.isSelect = pro.isSelect;
        _curModel.modleid = pro.provid;
    }
    if ([item isKindOfClass:[City class]]) {
        City *pro = item;
        _curModel.Title = pro.cityname;
        _curModel.isSelect = pro.isSelect;
        _curModel.modleid = pro.cityid;
    }
    if ([item isKindOfClass:[Region class]]) {
        Region *pro = item;
        _curModel.Title = pro.regionname;
        _curModel.isSelect = pro.isSelect;
        _curModel.modleid = pro.regionid;
    }
    [_titles addObject:_curModel.Title];
    _item = _curModel;
}

-(NSString *)toPath{
    NSString *toPath;
    switch (_GoToAddres) {
        case GoToPathTypeProvince:
            toPath = @"api/outer/prov/list";
            break;
        case GoToPathTypeCity:
            toPath = @"api/outer/city/listByProv";
            break;
        case GoToPathTypeRegion:
            toPath = @"api/outer/region/listByCity";
            break;
        default:
            break;
    }
    return toPath;
}

-(NSMutableDictionary *)toParams{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    switch (_GoToAddres) {
        case GoToPathTypeProvince:
            dic = nil;
            break;
        case GoToPathTypeCity:
            [dic removeAllObjects];
            [dic setValue:[NSString stringWithFormat:@"%ld",_province.provid] forKey:@"provid"];
            break;
        case GoToPathTypeRegion:
            [dic removeAllObjects];
            [dic setValue:[NSString stringWithFormat:@"%ld",_city.cityid] forKey:@"cityid"];
            break;
        default:
            break;
    }
    return dic;
}



@end
