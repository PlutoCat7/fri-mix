//
//  TacticsListViewModel.m
//  GB_Football
//
//  Created by yahua on 2018/1/12.
//  Copyright © 2018年 Go Brother. All rights reserved.
//

#import "TacticsListViewModel.h"
#import "TeamTacticsListRequest.h"
#import "TeamRequest.h"

@implementation TacticsListCellModel

@end

@interface TacticsListViewModel ()

@property (nonatomic, strong) TeamTacticsListRequest *request;

@property (nonatomic, strong, readwrite) NSArray<TacticsListCellModel *> *cellModels;

@end

@implementation TacticsListViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _request = [[TeamTacticsListRequest alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataNotification) name:Notification_Team_Tactics_Modify object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataNotification) name:Notification_Team_Tactics_Add object:nil];
    }
    return self;
}

- (void)getFirstPageListWithBlock:(void(^)(NSError *error))block {
    
    @weakify(self)
    [_request reloadPageWithHandle:^(id result, NSError *error) {
        @strongify(self)
        if (!error) {
            [self handlerNetworkData];
        }
        BLOCK_EXEC(block, error);
    }];
}

- (void)getNextPageListWithBlock:(void(^)(NSError *error))block {
    
    @weakify(self)
    [_request loadNextPageWithHandle:^(id result, NSError *error) {
        @strongify(self)
        if (error) {
            [self handlerNetworkData];
        }
        BLOCK_EXEC(block, error);
    }];
}

- (void)deleteTacticsWithIndex:(NSInteger)index block:(void(^)(NSError *error))block; {
    
    TeamTacticsInfo *tacticsInfo = [self tacticsInfoWithIndex:index];
    [TeamRequest deleteTacticsWithId:tacticsInfo.tacticsId handler:^(id result, NSError *error) {
       
        if (!error) {
            NSMutableArray *tmpCellModels = [NSMutableArray arrayWithArray:self.cellModels];
            [tmpCellModels removeObjectAtIndex:index];
            self.cellModels = [tmpCellModels copy];
        }
        BLOCK_EXEC(block, error);
    }];
}

- (TeamTacticsInfo *)tacticsInfoWithIndex:(NSInteger)index {
    
    if (index >= self.request.responseInfo.items.count) {
        return nil;
    }
    return self.request.responseInfo.items[index];
}

#pragma mark - Notification

- (void)refreshDataNotification {
    
    [self getFirstPageListWithBlock:nil];
}

#pragma mark - Private

- (void)handlerNetworkData {
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.request.responseInfo.items.count];
    for (TeamTacticsInfo *info in self.request.responseInfo.items) {
        
        TacticsListCellModel *model = [[TacticsListCellModel alloc] init];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:info.update_time];
        model.dateString = [date stringWithFormat:@"yyyy-MM-dd"];
        model.tacticsName = info.tactics_name;
        NSString *playerString = [NSString stringWithFormat:@"%td%@", info.people_num, @"人"];
        NSMutableAttributedString *mutAttributedString = [[NSMutableAttributedString alloc] initWithString:playerString];
        [mutAttributedString addAttribute:NSFontAttributeName value:[UIFont autoBoldFontOfSize:20] range:[playerString rangeOfString:[NSString stringWithFormat:@"%td", info.people_num]]];
        model.playerNumberAttributedString = [mutAttributedString copy];
        [result addObject:model];
    }
    self.cellModels = [result copy];
}

@end
