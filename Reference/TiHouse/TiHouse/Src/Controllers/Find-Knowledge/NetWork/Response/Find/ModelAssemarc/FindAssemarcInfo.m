//
//  FindAssemarcInfo.m
//  TiHouse
//
//  Created by yahua on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindAssemarcInfo.h"
#import "YAHJSONAdapter.h"
#import "FindPhotoLabelModel.h"

@implementation FindAssemarcFileTagJA

- (instancetype)init
{
    self = [super init];
    if (self) {
        _assemarcfiletagside = 1;
        _assemarcfiletagwper = 0.5;
        _assemarcfiletaghper = 0.5;
    }
    return self;
}

- (NSString *)combineBrandAndPrice {
    
    if (([_assemarcfiletagbrand isEmpty] || !_assemarcfiletagbrand) && ([_assemarcfiletagprice isEmpty] || !_assemarcfiletagprice)) {
        return @"";
    }
    if (!([_assemarcfiletagbrand isEmpty] || !_assemarcfiletagbrand) &&
        !([_assemarcfiletagprice isEmpty] || !_assemarcfiletagprice)) {
        return [NSString stringWithFormat:@"¥%@ | %@", _assemarcfiletagprice, _assemarcfiletagbrand];
    }
    if (!([_assemarcfiletagbrand isEmpty] || !_assemarcfiletagbrand)) {
        return _assemarcfiletagbrand;
    }
    if (!([_assemarcfiletagprice isEmpty] || !_assemarcfiletagprice)) {
        return [NSString stringWithFormat:@"¥%@", _assemarcfiletagprice];
    }
    return @"";
}

@end

@implementation FindAssemarcFileJA

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"assemarcfiletagJA":[FindAssemarcFileTagJA class]};
}

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"assemarcfiletagJA" : [FindAssemarcFileTagJA class]};
}


@end

@implementation FindAssemarcInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"listModelAssemarccomm":[FindAssemarcCommentInfo class],
             @"assemarcfileJA":[FindAssemarcFileJA class]
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"assemarcfileJA" : [FindAssemarcFileJA class]};
}

- (NSDictionary<NSString *, NSArray<FindPhotoLabelModel *> *> *)getLabelsDictionary {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSData *labelData = [self.assemarcfiletagJson dataUsingEncoding:NSUTF8StringEncoding];
    if (labelData) {
        NSDictionary *labelDic = [NSJSONSerialization JSONObjectWithData:labelData options:0 error:nil];
        if ([labelDic isKindOfClass:[NSDictionary class]]) {
            
            [labelDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                NSMutableArray *labelModelList = [NSMutableArray arrayWithCapacity:1];
                if ([obj isKindOfClass:[NSArray class]]) {
                    NSArray *labelStringArray = (NSArray *)obj;
                    for (NSInteger index=0; index<labelStringArray.count; index++) {
                        FindPhotoLabelModel *model = [YAHJSONAdapter objectFromJsonData:labelStringArray[index] objectClass:[FindPhotoLabelModel class]];
                        [labelModelList addObject:model];
                    }
                }
                [dic setObject:[labelModelList copy] forKey:key];
            }];
        }
    }
    
    return dic;
}

- (NSString *)username {
    return _username ? [_username URLDecoding] : @"";
}

@end
