//
//  RecordListViewModel.m
//  GB_Football
//
//  Created by yahua on 2017/9/19.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "RecordListViewModel.h"
#import "RecordListCellModel.h"

#import "MatchReordPageRequest.h"
#import "MatchRequest.h"

@interface RecordListViewModel ()

@property (nonatomic, strong) NSArray<RecordListCellModel *> *cellModels;
@property (nonatomic, copy) NSString *errorMsg;
@property (nonatomic, strong) NSArray<MatchInfo *> *recordList;

@property (nonatomic, strong) MatchReordPageRequest *recordPageRequest;

@end

@implementation RecordListViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _recordPageRequest = [[MatchReordPageRequest alloc] init];
        _recordPageRequest.gameType = -1;
    }
    return self;
}

- (void)setGameType:(RecordGameType)gameType {
    
    _gameType = gameType;
    switch (gameType) {
        case RecordGameType_All:
            self.recordPageRequest.gameType = -1;
            break;
        case RecordGameType_Standard:
            self.recordPageRequest.gameType = 0;
            break;
        case RecordGameType_Define:
            self.recordPageRequest.gameType = 1;
            break;
        case RecordGameType_ATeam:
            self.recordPageRequest.gameType = 2;
            break;
            
        default:
            break;
    }
    
}

- (void)getFirstPageMatchList:(void(^)(NSError *error))handler {
    
    @weakify(self)
    [self.recordPageRequest reloadPageWithHandle:^(id result, NSError *error) {
        @strongify(self)
        if (error) {
            self.errorMsg = error.domain;
        }else {
            self.recordList = self.recordPageRequest.responseInfo.items;
            [self handlerNetworkData];
        }
        BLOCK_EXEC(handler, error);
    }];
}

- (void)getNextPageMatchList:(void(^)(NSError *error))handler {
    
    if ([self.recordPageRequest isLoadEnd]) {
        BLOCK_EXEC(handler, nil);
        return;
    }
    
    [self.recordPageRequest loadNextPageWithHandle:^(id result, NSError *error) {
        if (error) {
            self.errorMsg = error.domain;
        }else {
            self.recordList = self.recordPageRequest.responseInfo.items;
            [self handlerNetworkData];
        }
        BLOCK_EXEC(handler, error);
    }];
}

- (MatchInfo *)matchInfoWithIndexPath:(NSIndexPath *)indexPath; {
    
    MatchInfo *info = self.recordList[indexPath.row];
    return info;
}

- (void)deleteMatchWithIndexPath:(NSIndexPath *)indexPath {
    
    MatchInfo *info = self.recordList[indexPath.row];
    @weakify(self)
    [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        @strongify(self)
        if (buttonIndex == 1) {
            [MatchRequest deleteMatchData:info.matchId handler:^(id result, NSError *error) {
                if (error) {
                    self.errorMsg = error.domain;
                }else {
                    NSMutableArray *list = [NSMutableArray arrayWithArray:self.recordList];
                    [list removeObjectAtIndex:indexPath.row];
                    self.recordList = [list copy];

                    list = [NSMutableArray arrayWithArray:self.cellModels];
                    [list removeObjectAtIndex:indexPath.row];
                    self.cellModels = [list copy];
                }
            }];
        }
    } title:LS(@"common.popbox.title.tip") message:LS(@"record.hint.delete.message") cancelButtonName:LS(@"common.btn.cancel") otherButtonTitle:LS(@"common.btn.yes") style:GBALERT_STYLE_NOMAL];
}

#pragma mark - Private

- (void)handlerNetworkData {
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.recordList.count];
    for (MatchInfo *info in self.recordList) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:info.matchTime];
        RecordListCellModel *model = [[RecordListCellModel alloc] init];
        model.dayString = [NSString stringWithFormat:@"%02td",date.day];
        model.yearMonthString = [NSString stringWithFormat:@"%td-%02td", date.year, date.month];
        model.matchName = info.matchName;
        model.matchAddress = info.courtName;
        model.isWating = info.status==0;
        if (info.gameType == GameType_Standard) {
            model.matchTypeString = LS(@"multi-section.standard.mode");
        } else if (info.gameType == GameType_Team) {
            model.matchTypeString = LS(@"team.match.section.mode");
        } else {
            model.matchTypeString = LS(@"multi-section.multi-section.mode");
        }
        [result addObject:model];
    }
    self.cellModels = [result copy];
}

@end
