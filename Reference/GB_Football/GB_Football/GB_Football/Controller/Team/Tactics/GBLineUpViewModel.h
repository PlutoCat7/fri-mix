//
//  GBTracticsViewModel.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/19.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LineUpPlayerModel.h"
#import "LineUpModel.h"
#import "TeamHomeResponeInfo.h"

@interface GBLineUpViewModel : NSObject

@property (nonatomic, strong) TeamHomeRespone *homeTeamInfo;

@property (nonatomic, strong) NSArray<LineUpModel *> *tracticsList;
@property (nonatomic, assign) NSInteger currentTracticsIndex;


@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) NSIndexPath *selectIndexPath;

- (instancetype)initWithHomeTeamInfo:(TeamHomeRespone *)teamInfo;

- (void)tracticsPlayerListWithHandle:(void(^)(NSArray<NSArray<LineUpPlayerModel *> *> *list, NSError *error))handle;

- (NSArray<TeamPalyerInfo *> *)otherPlayerList;

- (NSArray<NSString *> *)tracticsNameList;

//编辑
- (void)startEdit;
- (void)cancelEdit;
- (void)saveEditWithHandle:(void(^)(NSError *error))handle;
- (void)addPlayerWithTeamPlayerInfo:(TeamPalyerInfo *)playerInfo;
- (void)removePlayerWithIndexPath:(NSIndexPath *)indexPath;

// 保存临时数据
- (void)saveTempEditData:(void(^)(NSError *error))handle;
- (void)saveTempEditDataWithClearOther:(void(^)(NSError *error))handle;

@end
