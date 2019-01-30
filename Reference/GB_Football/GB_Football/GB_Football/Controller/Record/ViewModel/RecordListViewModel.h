//
//  RecordListViewModel.h
//  GB_Football
//
//  Created by yahua on 2017/9/19.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RecordListCellModel;

typedef NS_ENUM(NSUInteger, RecordGameType) {
    RecordGameType_All = 0,
    RecordGameType_Standard,   //标准
    RecordGameType_Define,    //多节
    RecordGameType_ATeam      //球队
};

@interface RecordListViewModel : NSObject

@property (nonatomic, strong, readonly) NSArray<RecordListCellModel *> *cellModels;
@property (nonatomic, copy, readonly) NSString *errorMsg;
@property (nonatomic, assign) RecordGameType gameType;

- (void)getFirstPageMatchList:(void(^)(NSError *error))handler;
- (void)getNextPageMatchList:(void(^)(NSError *error))handler;

- (MatchInfo *)matchInfoWithIndexPath:(NSIndexPath *)indexPath;
- (void)deleteMatchWithIndexPath:(NSIndexPath *)indexPath;

@end
