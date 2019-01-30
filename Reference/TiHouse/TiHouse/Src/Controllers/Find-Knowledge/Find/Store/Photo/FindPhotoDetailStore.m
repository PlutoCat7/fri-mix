//
//  FindPhotoDetailStore.m
//  TiHouse
//
//  Created by yahua on 2018/2/4.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindPhotoDetailStore.h"
#import "AssemPhotoMoreListRequest.h"
#import "AssemarcRequest.h"

@interface FindPhotoDetailStore()

@property (nonatomic, strong) NSArray<FindWaterfallModel *> *cellModels;

@property (nonatomic, strong) AssemPhotoMoreListRequest *pageRequest;

@end

@implementation FindPhotoDetailStore

- (instancetype)initWithAssemarcInfo:(FindAssemarcInfo *)arcInfo {
    
    self = [super init];
    if (self) {
        _arcInfo = arcInfo;
        _pageRequest = [[AssemPhotoMoreListRequest alloc] init];
        _pageRequest.assemarcid = arcInfo.assemarcid;
    }
    return self;
}

- (void)getFirstPageDataWithHandler:(void(^)(NSError *error))handler {
    
    [self.pageRequest reloadPageWithHandle:^(id result, NSError *error) {
        
        if (!error) {
            self.isEmptyData = self.pageRequest.responseInfo.items.count==0;
            [self handlerNetworkData:self.pageRequest.responseInfo.items];
        }else {
            self.isEmptyData = YES;
            self.cellModels = nil;
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

- (void)favorArticleWithHandler:(void(^)(BOOL isSuccess))handler {
    
    if (_arcInfo.assemarciscoll) {
        [AssemarcRequest addAssemarcFavor:_arcInfo.assemarcid handler:^(id result, NSError *error) {
            
            self.arcInfo.assemarciscoll = NO;
            self.arcInfo.assemarcnumcoll -= 1;
            BLOCK_EXEC(handler, error==nil)
        }];
    }else {
        [AssemarcRequest removeAssemarcFavor:_arcInfo.assemarcid handler:^(id result, NSError *error) {
            
            self.arcInfo.assemarciscoll = YES;
            self.arcInfo.assemarcnumcoll += 1;
            BLOCK_EXEC(handler, error==nil)
        }];
    }
}

- (void)zanArticleWithHandler:(void(^)(BOOL isSuccess))handler {
    
    if (_arcInfo.assemarciszan) {
        [AssemarcRequest removeAssemarcZan:_arcInfo.assemarcid handler:^(id result, NSError *error) {
            
            self.arcInfo.assemarciszan = NO;
            self.arcInfo.assemarcnumzan -= 1;
            BLOCK_EXEC(handler, error==nil)
        }];
    }else {
        [AssemarcRequest addAssemarcZan:_arcInfo.assemarcid handler:^(id result, NSError *error) {
            
            self.arcInfo.assemarciszan = YES;
            self.arcInfo.assemarcnumzan += 1;
            BLOCK_EXEC(handler, error==nil)
        }];
    }
}

- (void)attentionWithHandler:(void(^)(BOOL isSuccess))handler {
    
    FindAssemarcInfo *info  = self.arcInfo;
    if (info.assemarcisconcern) {
        [AssemarcRequest removeAttentionWithConcernuidon:info.assemarcuid handler:^(id result, NSError *error) {
            info.assemarcisconcern = NO;
            BLOCK_EXEC(handler, error==nil)
        }];
    }else {
        [AssemarcRequest addAttentionWithConcernuidon:info.assemarcuid handler:^(id result, NSError *error) {
            info.assemarcisconcern = YES;
            BLOCK_EXEC(handler, error==nil)
        }];
    }
}

@end
