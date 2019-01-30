//
//  TallyDetail.m
//  TiHouse
//
//  Created by AlienJunX on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "TallyDetail.h"

@implementation TallyDetail

- (NSDictionary *)addTallDetailtoParams {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:_tallyprocatename forKey:@"tallyprocatename"];
    [dic setValue:_tallyproremark forKey:@"tallyproremark"];
    [dic setValue:_tallyprobrand forKey:@"tallyprobrand"];
    [dic setValue:_tallyproxh forKey:@"tallyproxh"];
    [dic setValue:[NSString stringWithFormat:@"%ld",_tallyid] forKey:@"tallyid"];
    [dic setValue:[NSString stringWithFormat:@"%ld",_catetwoid] forKey:@"catetwoid"];
    [dic setValue:[NSString stringWithFormat:@"%ld",_tallyprotime] forKey:@"tallyprotime"];
    [dic setValue:[NSString stringWithFormat:@"%ld",_tallyprotype] forKey:@"tallyprotype"];
    [dic setValue:[NSString stringWithFormat:@"%lf",_locationlng] forKey:@"locationlng"];
    [dic setValue:[NSString stringWithFormat:@"%lf",_locationlat] forKey:@"locationlat"];
    [dic setValue:[NSString stringWithFormat:@"%ld",_amountzj] forKey:@"amountzj"];
    [dic setValue:_arrurlcert forKey:@"arrurlcert"];
    [dic setValue:_paywayname forKey:@"paywayname"];
    [dic setValue:_locationname forKey:@"locationname"];
    if (_isEdit) {
        [dic setValue:[NSString stringWithFormat:@"%ld",_tallyproid] forKey:@"tallyproid"];
    }
    
    return dic;
}

- (NSString *)validPostParams {
    NSString *result = @"";
    if (_amountzj == 0) {
        result = @"请输入金额";
    } else if (_tallyprocatename.length == 0) {
        result = @"请选择类别";
    }
//    else if (_tallyproremark.length == 0) {
//        result = @"请输入备注";
//    }
    
    
    
    return result;
}
@end
