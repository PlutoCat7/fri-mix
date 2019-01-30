//
//  AssemDetailStore.m
//  TiHouse
//
//  Created by yahua on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AssemDetailStore.h"
#import "AssemHotArcListRequest.h"
#import "FindPostTool.h"
#import "FindAssemActivityRequest.h"

@interface AssemDetailStore()

@property (nonatomic, strong) NSArray<FindWaterfallModel *> *cellModels;

@property (nonatomic, strong) AssemHotArcListRequest *pageRequest;

@end

@implementation AssemDetailStore

- (instancetype)initWithAssemId:(long)assemId {
    
    self = [super init];
    if (self) {
        _pageRequest = [[AssemHotArcListRequest alloc] init];
        _pageRequest.type = 1;
        _pageRequest.assemId = assemId;
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

- (void)getAssemActivityInfoWithHandler:(void(^)(NSError *error, FindAssemActivityInfo *assemInfo))handler {
    
    [FindAssemActivityRequest getActivityInfoWithAssemId:self.pageRequest.assemId handler:^(id result, NSError *error) {
        
        BLOCK_EXEC(handler, error, result);
    }];
}

- (void)setType:(NSInteger)type {
    
    if (type == _type) {
        return;
    }
    _type = type;
    self.pageRequest.type = type;
    self.cellModels = nil;
    [self getFirstPageDataWithHandler:nil];
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
        NSMutableAttributedString *muti = [[NSMutableAttributedString alloc] initWithAttributedString:[FindPostTool htmlToAttribute:info.assemarccontent]];
        [muti addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0f] range:NSMakeRange(0, [muti string].length)];
        [muti addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRGBHex:0x606060] range:NSMakeRange(0, [muti string].length)];
        model.contentAttributedString = [muti copy];
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
