//
//  FindWaterfallStore.m
//  TiHouse
//
//  Created by yahua on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindWaterfallStore.h"
#import "AssemPhotoSearchListRequest.h"
#import "AssemarcRequest.h"

@interface FindWaterfallStore()

@property (nonatomic, strong) NSArray<FindWaterfallModel *> *cellModels;
@property (nonatomic, strong) AssemPhotoSearchListRequest *pageRequest;

@end

@implementation FindWaterfallStore

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pageRequest = [[AssemPhotoSearchListRequest alloc] init];
    }
    return self;
}

- (void)setSearchName:(NSString *)searchName {
    
    _searchName = searchName;
    _pageRequest.searchText = searchName;
}

- (void)getFirstPageDataWithHandler:(void(^)(NSError *error))handler {
    
    [self.pageRequest reloadPageWithHandle:^(id result, NSError *error) {
        
        if (!error) {
            [self handlerNetworkData:self.pageRequest.responseInfo.items];
        }
        BLOCK_EXEC(handler, error);
    }];
}

- (void)getNextPageDataWithHandler:(void(^)(NSError *error))handler {
    
    [self.pageRequest loadNextPageWithHandle:^(id result, NSError *error) {
        if (!error) {
            [self handlerNetworkData:self.pageRequest.responseInfo.items];
        }
        BLOCK_EXEC(handler, error);
    }];
}

- (BOOL)isLoadEnd {
    
    return self.pageRequest.isLoadEnd;
}

- (FindAssemarcInfo *)assemarcInfoWithIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row<self.pageRequest.responseInfo.items.count) {
        return self.pageRequest.responseInfo.items[indexPath.row];
    }
    
    return nil;
}

- (void)likeArticleWithIndexPath:(NSIndexPath *)indexPath handler:(void(^)(BOOL isSuccess))handler {
    
    FindAssemarcInfo *info  = [self assemarcInfoWithIndexPath:indexPath];
    if (!info) {
        BLOCK_EXEC(handler, NO);
    }
    if (info.assemarciszan) {
        [AssemarcRequest removeAssemarcZan:info.assemarcid handler:^(id result, NSError *error) {
            
            info.assemarciszan = NO;
            info.assemarcnumzan -= 1;
            FindWaterfallModel *model = self.cellModels[indexPath.row];
            model.isMeLike = NO;
            model.likeCount -= 1;

            BLOCK_EXEC(handler, error==nil)
        }];
    }else {
        [AssemarcRequest addAssemarcZan:info.assemarcid handler:^(id result, NSError *error) {
            
            info.assemarciszan = YES;
            info.assemarcnumzan += 1;
            FindWaterfallModel *model = self.cellModels[indexPath.row];
            model.isMeLike = YES;
            model.likeCount += 1;
            BLOCK_EXEC(handler, error==nil)
        }];
    }
}

#pragma mark - Private

#pragma mark - Private

- (void)handlerNetworkData:(NSArray<FindAssemarcInfo *> *)infoList {
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:infoList.count];
    for (FindAssemarcInfo *info in infoList) {
        FindWaterfallModel *model = nil;
        for (FindWaterfallModel *hasCellModel in self.cellModels) {
            if (hasCellModel.identifier == info.assemarcid) {
                model = hasCellModel;
                break;
            }
        }
        if (model) {
            [result addObject:model];
            continue;
        }
        model = [[FindWaterfallModel alloc] init];
        model.imageWidth = info.assemarcpicwidth;
        model.imageHeight = info.assemarcpicheigh;
        model.imageUrl = [NSURL URLWithString:info.urlindex];
        model.title = info.assemarctitle;
        model.userAvatorUrl = [NSURL URLWithString:info.urlhead];
        model.userName = info.username;
        model.likeCount = info.assemarcnumzan;
        model.isMeLike = info.assemarciszan;
        [result addObject:model];
    }
    self.cellModels = [result copy];
}

@end
