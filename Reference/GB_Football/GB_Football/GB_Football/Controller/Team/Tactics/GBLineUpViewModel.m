//
//  GBTracticsViewModel.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/19.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBLineUpViewModel.h"
#import "TeamRequest.h"

@interface GBLineUpViewModel ()


@property (nonatomic, strong) NSMutableDictionary *tracticsDetailDict;
@property (nonatomic, strong) NSMutableDictionary *tempTracticsDetailDict;

@property (nonatomic, strong) NSArray<NSArray<LineUpPlayerModel *> *> *tmpTracticsPlayers;

@end

@implementation GBLineUpViewModel

- (instancetype)initWithHomeTeamInfo:(TeamHomeRespone *)teamInfo
{
    self = [super init];
    if (self) {
        _homeTeamInfo = teamInfo;
        [self loadData];
    }
    return self;
}

- (void)tracticsPlayerListWithHandle:(void(^)(NSArray<NSArray<LineUpPlayerModel *> *> *list, NSError *error))handle {
    
    @try {
        
        if (self.tmpTracticsPlayers) { //正处于编辑状态
            BLOCK_EXEC(handle, self.tmpTracticsPlayers, nil);
            return;
        }
        
        LineUpModel *currentTractics = self.tracticsList[self.currentTracticsIndex];
        if ([self.tempTracticsDetailDict objectForKey:currentTractics.name]) {
            BLOCK_EXEC(handle, [self.tempTracticsDetailDict objectForKey:currentTractics.name], nil);
            return;
        }
        
        if ([self.tracticsDetailDict objectForKey:currentTractics.name]) {
            BLOCK_EXEC(handle, [self.tracticsDetailDict objectForKey:currentTractics.name], nil);
            return;
        }
        
        [TeamRequest getLineUpInfoWithId:currentTractics.tracticsType handler:^(id result, NSError *error) {
            
            if (!error) {
                NSArray<TeamLineUpInfo *> *teamTracticsInfoList = result;
                NSMutableArray *tmpList = [NSMutableArray arrayWithCapacity:10];
                for (TeamLineUpInfo *info in teamTracticsInfoList) {
                    LineUpPlayerModel *model = [LineUpPlayerModel new];
                    model.posIndex = info.position;
                    model.playerInfo = info.user_mess;
                    model.emptyImageName = @"tractics_add_teammates";
                    [tmpList addObject:model];
                }
                //根据阵型划分球员
                NSArray<NSValue *> *pattern = [self subListWithTracticsName:currentTractics.name];
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
                [self.tracticsDetailDict setObject:result forKey:currentTractics.name];
                BLOCK_EXEC(handle, result, nil);
            }else {
                BLOCK_EXEC(handle, nil, error);
            }
        }];
    } @catch (NSException *exception) {
        BLOCK_EXEC(handle, nil, [NSError errorWithDomain:@"数据异常" code:0 userInfo:nil]);
    }
}

- (NSArray<TeamPalyerInfo *> *)otherPlayerList {
    
    NSArray<NSArray<LineUpPlayerModel *> *> *tmp = self.tmpTracticsPlayers;
    
    if (!tmp) {
        LineUpModel *currentTractics = self.tracticsList[self.currentTracticsIndex];
        tmp = [self.tempTracticsDetailDict objectForKey:currentTractics.name];
    }
    
    if (!tmp) {
        LineUpModel *currentTractics = self.tracticsList[self.currentTracticsIndex];
        tmp = [self.tracticsDetailDict objectForKey:currentTractics.name];
    }
    
    if (!tmp) {
        return self.homeTeamInfo.players;
    }else {
        //过滤已经在当前阵型的球员
        NSMutableArray *result = [NSMutableArray arrayWithArray:self.homeTeamInfo.players];
        [tmp enumerateObjectsUsingBlock:^(NSArray<LineUpPlayerModel *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj enumerateObjectsUsingBlock:^(LineUpPlayerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.playerInfo) {
                    for (TeamPalyerInfo *info in self.homeTeamInfo.players) {
                        if (info.user_id == obj.playerInfo.user_id) {
                            [result removeObject:info];
                        }
                    }
                }
            }];
        }];
        return [result copy];
    }
    
}

- (NSArray<NSString *> *)tracticsNameList {
    
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:self.tracticsList.count];
    for (LineUpModel *tractics in self.tracticsList) {
        [list addObject:tractics.name];
    }
    
    return [list copy];
}

#pragma mark 阵型编辑
- (void)startEdit {
    
    if (self.isEdit) {
        return;
    }
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:1];
    if ([self.tempTracticsDetailDict objectForKey:self.tracticsList[self.currentTracticsIndex].name]) {
        for (NSArray *list in [self.tempTracticsDetailDict objectForKey:self.tracticsList[self.currentTracticsIndex].name]) {
            NSMutableArray *tmpList = [NSMutableArray arrayWithCapacity:list.count];
            [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [tmpList addObject:[obj copy]];
            }];
            [result addObject:tmpList];
        }
        
    } else {
        for (NSArray *list in [self.tracticsDetailDict objectForKey:self.tracticsList[self.currentTracticsIndex].name]) {
            NSMutableArray *tmpList = [NSMutableArray arrayWithCapacity:list.count];
            [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [tmpList addObject:[obj copy]];
            }];
            [result addObject:tmpList];
        }
    }
    
    self.tmpTracticsPlayers = [result copy];
    
    self.isEdit = YES;
}

- (void)cancelEdit {
    
    self.tmpTracticsPlayers = nil;
    self.selectIndexPath = nil;
    
    self.isEdit = NO;
}

- (void)saveEditWithHandle:(void(^)(NSError *error))handle {
    
    //接口请求
    NSMutableDictionary *context = [NSMutableDictionary dictionaryWithCapacity:1];
    [self.tmpTracticsPlayers enumerateObjectsUsingBlock:^(NSArray<LineUpPlayerModel *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj enumerateObjectsUsingBlock:^(LineUpPlayerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.playerInfo) {
                [context setObject:@(obj.posIndex) forKey:@(obj.playerInfo.user_id).stringValue];
            }
        }];
    }];
    [TeamRequest savaLineUpWithId:self.tracticsList[self.currentTracticsIndex].tracticsType context:context handler:^(id result, NSError *error) {
        
        if (!error) {
            [self.tracticsDetailDict setObject:self.tmpTracticsPlayers forKey:self.tracticsList[self.currentTracticsIndex].name];
            self.tmpTracticsPlayers = nil;
            self.selectIndexPath = nil;
            self.isEdit = NO;
        }
        BLOCK_EXEC(handle, error);
    }];
    
}

// 保存临时数据
- (void)saveTempEditData:(void(^)(NSError *error))handle {
    if (!self.tmpTracticsPlayers) {
        BLOCK_EXEC(handle, nil);
        return;
    }
    
    [self.tempTracticsDetailDict setObject:self.tmpTracticsPlayers forKey:self.tracticsList[self.currentTracticsIndex].name];
    self.tmpTracticsPlayers = nil;
    self.selectIndexPath = nil;
    self.isEdit = NO;
    
    BLOCK_EXEC(handle, nil);
}

- (void)saveTempEditDataWithClearOther:(void(^)(NSError *error))handle {
    [self.tempTracticsDetailDict removeAllObjects];
    [self saveTempEditData:handle];
}

- (void)addPlayerWithTeamPlayerInfo:(TeamPalyerInfo *)playerInfo {
    
    if (!self.selectIndexPath) {
        return;
    }
    LineUpPlayerModel *model = [[self.tmpTracticsPlayers objectAtIndex:self.selectIndexPath.section] objectAtIndex:self.selectIndexPath.row];
    model.playerInfo = playerInfo;
}

- (void)removePlayerWithIndexPath:(NSIndexPath *)indexPath {

    LineUpPlayerModel *model = [[self.tmpTracticsPlayers objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    model.playerInfo = nil;
}

#pragma mark - Pravite

- (void)loadData {
    
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:1];
    for (NSInteger i=1; i<=7; i++) {
        LineUpModel *model = [[LineUpModel alloc] init];
        model.tracticsType = i;
        [list addObject:model];
    }
    self.tracticsList = [list copy];
    
    self.tracticsDetailDict = [NSMutableDictionary dictionaryWithCapacity:1];
    self.tempTracticsDetailDict = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if (!_homeTeamInfo) {
        [TeamRequest getTeamInfo:0 handler:^(id result, NSError *error) {
            if (error) {
                [[UIApplication sharedApplication].keyWindow showToastWithText:error.domain];
            }else {
                _homeTeamInfo = result;
                [RawCacheManager sharedRawCacheManager].userInfo.team_mess = _homeTeamInfo.team_mess;
            }
        }];
    }
}

- (NSArray<NSValue *> *)subListWithTracticsName:(NSString *)tracticsName {
    
    NSArray *numList = [tracticsName componentsSeparatedByString:@"-"];
    if (numList.count != 3) {
        return nil;
    }
    NSInteger first = [numList.firstObject integerValue];
    NSInteger second = [numList[1] integerValue];
    NSInteger third = [numList.lastObject integerValue];
    return @[[NSValue valueWithRange:NSMakeRange(0, 1)],
             [NSValue valueWithRange:NSMakeRange(1, first)],
             [NSValue valueWithRange:NSMakeRange(first+1, second)],
             [NSValue valueWithRange:NSMakeRange(first+second+1, third)]];
};

@end
