//
//  FindRootStore.m
//  TiHouse
//
//  Created by yahua on 2018/2/4.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindRootStore.h"
#import "FindAssemarcListRequest.h"
#import "FindAssemarcAttentionListRequest.h"
#import "FindPhotoPreviewViewController.h"
#import "AssemarcRequest.h"
#import "NotificationConstants.h"

@interface FindRootStore ()

@property (nonatomic, strong) BasePageNetworkRequest *pageRequest;
@property (nonatomic, strong) FindAssemarcListRequest *allPageRequest;
@property (nonatomic, strong) FindAssemarcAttentionListRequest *attentionPageRequest;

@property (nonatomic, strong) NSArray<FindAssemarcInfo *> *cellModels;
@property (nonatomic, strong) NSArray<FindAssemarcInfo *> *allCellModels;
@property (nonatomic, strong) NSArray<FindAssemarcInfo *> *attentionCellModels;

@end

@implementation FindRootStore

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _allPageRequest = [[FindAssemarcListRequest alloc] init];
        _attentionPageRequest = [[FindAssemarcAttentionListRequest alloc] init];
        _pageRequest = _allPageRequest;
        _cacheCellHeightDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
        //读取缓存
//        @try {
//            FindAssemarcListResponse *cacheResponse = (FindAssemarcListResponse *)[FindAssemarcListResponse loadCache];
//            self.cellModels = cacheResponse.data;
//            self.allCellModels = self.cellModels;
//        } @catch (NSException *exception) {
//
//        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postSuccessNotification) name:Notification_Posted_Photo object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postSuccessNotification) name:Notification_Posted_Article object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(attentionhandleSuccessNotification:) name:Notification_User_Attention object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectionhandleSuccessNotification) name:Notification_User_Collection object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likehandleSuccessNotification) name:Notification_User_Like object:nil];
    }
    return self;
}

- (void)setType:(NSInteger)type {
    
    if (type == _type) {
        return;
    }
    _type = type;
    if (type == 0) {
        self.pageRequest = self.allPageRequest;
        self.cellModels = self.allCellModels;
    }else {
        self.pageRequest = self.attentionPageRequest;
        self.cellModels = self.attentionCellModels;
    }
    //[self getFirstPageDataWithHandler:nil];
}

- (void)getFirstPageDataWithHandler:(void(^)(NSError *error))handler {
    
    [self.pageRequest reloadPageWithHandle:^(id result, NSError *error) {
        
        if (!error) {
            self.cellModels = self.pageRequest.responseInfo.items;
            
            if (self.pageRequest == self.allPageRequest) {
                self.allCellModels = self.cellModels;
                //缓存
                [self.pageRequest.responseInfo saveCache];
            }else {
                self.attentionCellModels = self.cellModels;
            }
        }
        BLOCK_EXEC(handler, error);
    }];
}
- (void)getNextPageDataWithHandler:(void(^)(NSError *error))handler {
    
    [self.pageRequest loadNextPageWithHandle:^(id result, NSError *error) {
        if (!error) {
            self.cellModels = self.pageRequest.responseInfo.items;

            if (self.pageRequest == self.allPageRequest) {
                self.allCellModels = self.cellModels;
            }else {
                self.attentionCellModels = self.cellModels;
            }
        }
        BLOCK_EXEC(handler, error);
    }];
}

- (BOOL)isLoadEnd {
    
    return self.pageRequest.isLoadEnd;
}

- (FindAssemarcInfo *)assemarcInfoWithIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row<self.cellModels.count) {
        return self.cellModels[indexPath.row];
    }
    
    return nil;
}

- (NSArray<FindPhotoPreviewModel *> *)photoPreviewModelsWithIndexPath:(NSIndexPath *)indexPath {
    
    FindAssemarcInfo *info = self.cellModels[indexPath.row];
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:1];
    for (FindAssemarcFileJA *file in info.assemarcfileJA) {
        FindPhotoPreviewModel *model = [[FindPhotoPreviewModel alloc] init];
        model.imageId = file.assemarcfileid;
        model.imageUrl = file.assemarcfileurl;
        model.labelModelList = file.assemarcfiletagJA;
        [result addObject:model];
    }
    return [result copy];
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
            BLOCK_EXEC(handler, error==nil)
        }];
    }else {
        [AssemarcRequest addAssemarcZan:info.assemarcid handler:^(id result, NSError *error) {
            
            info.assemarciszan = YES;
            info.assemarcnumzan += 1;
            BLOCK_EXEC(handler, error==nil)
        }];
    }
}

- (void)favorArticleWithIndexPath:(NSIndexPath *)indexPath handler:(void(^)(BOOL isSuccess))handler {
    
    FindAssemarcInfo *info  = [self assemarcInfoWithIndexPath:indexPath];
    if (info.assemarciscoll) {
        [AssemarcRequest addAssemarcFavor:info.assemarcid handler:^(id result, NSError *error) {
            
            info.assemarciscoll = NO;
            info.assemarcnumcoll -= 1;
            BLOCK_EXEC(handler, error==nil)
            
        }];
    }else {
        [AssemarcRequest removeAssemarcFavor:info.assemarcid handler:^(id result, NSError *error) {
            
            info.assemarciscoll = YES;
            info.assemarcnumcoll += 1;
            BLOCK_EXEC(handler, error==nil)
            
        }];
    }
}

- (void)attentionWithIndexPath:(NSIndexPath *)indexPath handler:(void(^)(BOOL isSuccess))handler {
    
    FindAssemarcInfo *info  = [self assemarcInfoWithIndexPath:indexPath];
    if (info.assemarcisconcern) {
        [AssemarcRequest removeAttentionWithConcernuidon:info.assemarcuid handler:^(id result, NSError *error) {
            info.assemarcisconcern = NO;
            BLOCK_EXEC(handler, error==nil)
            
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_User_Attention object:info];
        }];
    }else {
        [AssemarcRequest addAttentionWithConcernuidon:info.assemarcuid handler:^(id result, NSError *error) {
            info.assemarcisconcern = YES;
            BLOCK_EXEC(handler, error==nil)
            
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_User_Attention object:info];
        }];
    }
}

#pragma mark - Notification

- (void)postSuccessNotification {
    
    [self getFirstPageDataWithHandler:nil];
}

- (void)attentionhandleSuccessNotification:(NSNotification *)notification {
    
    FindAssemarcInfo *changedInfo = notification.object;
    if (changedInfo) {
        for (FindAssemarcInfo *info in self.cellModels) {
            if (changedInfo.assemarcuid == info.assemarcuid) {
                info.assemarcisconcern = changedInfo.assemarcisconcern;
            }
        }
        [self willChangeValueForKey:@"cellModels"];
        [self didChangeValueForKey:@"cellModels"];
    }else {
        [self getFirstPageDataWithHandler:nil];
    }
}

- (void)collectionhandleSuccessNotification {
    
    //触发kvo
    [self willChangeValueForKey:@"cellModels"];
    [self didChangeValueForKey:@"cellModels"];
}

- (void)likehandleSuccessNotification {
    
    //触发kvo
    [self willChangeValueForKey:@"cellModels"];
    [self didChangeValueForKey:@"cellModels"];
}

@end
