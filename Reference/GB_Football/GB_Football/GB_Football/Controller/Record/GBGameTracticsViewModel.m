//
//  GBGameTracticsViewModel.m
//  GB_Football
//
//  Created by 王时温 on 2017/8/16.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBGameTracticsViewModel.h"

@interface GBGameTracticsViewModel ()

@property (nonatomic, strong) LineUpModel *tracticsModel;
@property (nonatomic, strong) NSArray<NSArray<LineUpPlayerModel *> *> *dataList;

@end

@implementation GBGameTracticsViewModel

- (instancetype)initWithTracticsType:(TracticsType)type players:(NSArray<TeamLineUpInfo *> *)players {
    
    self = [super init];
    if (self) {
        _tracticsModel = [[LineUpModel alloc] init];
        _tracticsModel.tracticsType = type;
        if (players.count != 11) {  //安全判断
            return self;
        }
        
        NSMutableArray *tmpList = [NSMutableArray arrayWithCapacity:10];
        for (TeamLineUpInfo *info in players) {
            LineUpPlayerModel *model = [LineUpPlayerModel new];
            model.posIndex = info.position;
            model.playerInfo = info.user_mess;
            model.emptyImageName = @"portrait";
            [tmpList addObject:model];
        }
        //根据阵型划分球员
        NSArray<NSValue *> *pattern = [self subListWithTracticsName:_tracticsModel.name];
        NSArray<NSArray<LineUpPlayerModel *> *> *result = @[[tmpList subarrayWithRange:pattern[0].rangeValue],
                                                              [tmpList subarrayWithRange:pattern[1].rangeValue],
                                                              [tmpList subarrayWithRange:pattern[2].rangeValue],
                                                              [tmpList subarrayWithRange:pattern[3].rangeValue]];
        //附上默认值
        [result enumerateObjectsUsingBlock:^(NSArray<LineUpPlayerModel *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger pos = idx;
            [obj enumerateObjectsUsingBlock:^(LineUpPlayerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                switch (pos) {
                    case 0:
                        obj.posName = LS(@"team.tractics.GK");
                        break;
                    case 1:
                        obj.posName = LS(@"team.tractics.DF");
                        break;
                    case 2:
                        obj.posName = LS(@"team.tractics.Mid");
                        break;
                    case 3:
                        obj.posName = LS(@"team.tractics.SK");
                        break;
                        
                    default:
                        break;
                }
            }];
        }];
        self.dataList = [result copy];
    }
    
    return self;
}

- (NSArray<NSValue *> *)subListWithTracticsName:(NSString *)tracticsName {
    
    NSArray *numList = [tracticsName componentsSeparatedByString:@"-"];
    if (numList.count != 3) {
        return nil;
    }
    NSInteger first = [numList.firstObject integerValue];
    NSInteger second = [numList[1] integerValue];
    NSInteger third = [numList.lastObject integerValue];
    //守门员默认第一个
    return @[[NSValue valueWithRange:NSMakeRange(0, 1)],
             [NSValue valueWithRange:NSMakeRange(1, first)],
             [NSValue valueWithRange:NSMakeRange(first+1, second)],
             [NSValue valueWithRange:NSMakeRange(first+second+1, third)]];
};

@end
