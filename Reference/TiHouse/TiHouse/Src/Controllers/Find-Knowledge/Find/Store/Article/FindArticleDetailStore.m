//
//  FindArticleDetailStore.m
//  TiHouse
//
//  Created by yahua on 2018/2/4.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindArticleDetailStore.h"
#import "AssemarcRequest.h"
#import "FindAssemarcInfo.h"

@interface FindArticleDetailStore()



@end

@implementation FindArticleDetailStore

- (instancetype)initWithAssemarcInfo:(FindAssemarcInfo *)arcInfo {
    
    self = [super init];
    if (self) {
        _arcInfo = arcInfo;
    }
    return self;
}

- (void)likeArticleWithHandler:(void(^)(BOOL isSuccess))handler {
    
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

- (void)favorArticleWithHandler:(void(^)(BOOL isSuccess))handler {
    
    if (_arcInfo.assemarciscoll) {
        [AssemarcRequest removeAssemarcFavor:_arcInfo.assemarcid handler:^(id result, NSError *error) {
            
            self.arcInfo.assemarciscoll = NO;
            self.arcInfo.assemarcnumcoll -= 1;
            BLOCK_EXEC(handler, error==nil)
        }];
    }else {
        [AssemarcRequest addAssemarcFavor:_arcInfo.assemarcid handler:^(id result, NSError *error) {
            
            self.arcInfo.assemarciscoll = YES;
            self.arcInfo.assemarcnumcoll += 1;
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
