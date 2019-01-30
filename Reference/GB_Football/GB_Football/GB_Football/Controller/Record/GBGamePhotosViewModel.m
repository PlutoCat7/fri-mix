//
//  GBGamePhotosViewModel.m
//  GB_Football
//
//  Created by yahua on 2017/12/15.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBGamePhotosViewModel.h"

#import "MatchRequest.h"

@implementation GBGamePhotosCellModel

@end

@implementation GBGamePhotosSectionModel

@end

@interface GBGamePhotosViewModel ()

@property (nonatomic, assign) NSInteger matchId;

@property (nonatomic, strong) NSArray<GBGamePhotosSectionModel *> *sectionModels;

@end

@implementation GBGamePhotosViewModel

- (instancetype)initWithMatchId:(NSInteger)matchId {
    
    self = [super init];
    if (self) {
        _matchId = matchId;
    }
    return self;
}

#pragma mark - Private

- (void)requestNetworkData:(void(^)(NSError *error))complete {
    
    [MatchRequest getMatchData:self.matchId handler:^(id result, NSError *error) {
        
        if (!error) {
            NSMutableArray *resultList = [NSMutableArray arrayWithCapacity:1];
            NSArray<MatchDetailPhotoInfo *> *list = result;
            for (NSInteger i=0; i<list.count; i++) {
                MatchDetailPhotoInfo *photoInfo = list[i];
                GBGamePhotosSectionModel *sectionModel = [[GBGamePhotosSectionModel alloc] init];
                sectionModel.sectionName = photoInfo.nick_name;
                NSMutableArray *cellModelList = [NSMutableArray arrayWithCapacity:1];
                //图片
                for (NSString *url in photoInfo.img) {
                    if ([NSString stringIsNullOrEmpty:url]) {
                        continue;
                    }
                    GBGamePhotosCellModel *cellModel = [[GBGamePhotosCellModel alloc] init];
                    cellModel.state = 0;
                    cellModel.url = url;
                    [cellModelList addObject:cellModel];
                }
                //视频
                for (NSString *url in photoInfo.video) {
                    if ([NSString stringIsNullOrEmpty:url]) {
                        continue;
                    }
                    GBGamePhotosCellModel *cellModel = [[GBGamePhotosCellModel alloc] init];
                    cellModel.state = 1;
                    cellModel.url = url;
                    [cellModelList addObject:cellModel];
                }
                sectionModel.cellModels = [cellModelList copy];
                
                [resultList addObject:sectionModel];
            }
            self.sectionModels = [resultList copy];
            BLOCK_EXEC(complete, nil);
        }else {
            BLOCK_EXEC(complete, error);
        }
    }];
}



@end
