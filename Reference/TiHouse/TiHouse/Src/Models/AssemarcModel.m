//
//  AssemarcModel.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/2/4.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AssemarcModel.h"
#import "YAHJSONAdapter.h"

@implementation AssemarcModel

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

@end
