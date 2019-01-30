//
//  AssemarcRequest.m
//  TiHouse
//
//  Created by yahua on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AssemarcRequest.h"
#import "Login.h"

@implementation AssemarcRequest

+ (void)postArticleWithAssemarctitle:(NSString *)assemarctitle
                      urlindex:(NSString *)urlindex
            assemarccontent:(NSString *)assemarccontent
                      handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"/api/inter/assemarc/addWz";
    NSDictionary *parameters = @{@"uid":@([Login curLoginUser].uid),
                                 @"urlindex":urlindex,
                                 @"assemarctitle":assemarctitle,
                                 @"assemarccontent":assemarccontent
                                 };
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        
        BLOCK_EXEC(handler, nil, error);
    }];
}

+ (void)postPhotosWithAssemid:(long)assemid
                assemarctitle:(NSString *)assemarctitle
            assemarcfileJAstr:(NSString *)assemarcfileJAstr
                      handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"/api/inter/assemarc/addTt";
    NSDictionary *parameters = @{@"uid":@([Login curLoginUser].uid),
                                 @"assemid":@(assemid),
                                 @"assemarctitle":assemarctitle,
                                 @"assemarcfileJAstr":assemarcfileJAstr
                                 };
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        
        BLOCK_EXEC(handler, nil, error);
    }];
}

+ (void)addAssemarcFavor:(NSInteger)assemarcId handler:(RequestCompleteHandler)handler {
    NSString *urlString = @"api/inter/assemarccoll/add";
    
    NSDictionary *parameters = @{@"assemarcid":@(assemarcId)};
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            GBResponseInfo *info = result;
            BLOCK_EXEC(handler, info, nil);
        }
    }];
}

+ (void)removeAssemarcFavor:(NSInteger)assemarcId handler:(RequestCompleteHandler)handler {
    NSString *urlString = @"api/inter/assemarccoll/remove";
    
    NSDictionary *parameters = @{@"assemarcid":@(assemarcId)};
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            GBResponseInfo *info = result;
            BLOCK_EXEC(handler, info, nil);
        }
    }];
}

+ (void)addAssemarcZan:(NSInteger)assemarcid handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"api/inter/assemarczan/add";
    
    NSDictionary *parameters = @{@"assemarcid":@(assemarcid),
                                 @"assemarczanuid":@([Login curLoginUser].uid)
                                 };
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        
        GBResponseInfo *info = result;
        
        BLOCK_EXEC(handler, info, error);
    }];
}
//取消征集图文点赞
+ (void)removeAssemarcZan:(NSInteger)assemarcid handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"api/inter/assemarczan/remove";
    
    NSDictionary *parameters = @{@"assemarcid":@(assemarcid),
                                 @"assemarczanuid":@([Login curLoginUser].uid)
                                 };
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        
        GBResponseInfo *info = result;
        
        BLOCK_EXEC(handler, info, error);
    }];
}

+ (void)addAttentionWithConcernuidon:(NSInteger)concernuidon handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"api/inter/concern/add";
    
    NSDictionary *parameters = @{@"concernuidon":@(concernuidon),
                                 @"concernuid":@([Login curLoginUser].uid)
                                 };
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        
        BLOCK_EXEC(handler, nil, error);
    }];
}

+ (void)removeAttentionWithConcernuidon:(NSInteger)concernuidon handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"api/inter/concern/remove";
    
    NSDictionary *parameters = @{@"concernuidon":@(concernuidon),
                                 @"concernuid":@([Login curLoginUser].uid)
                                 };
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        
        BLOCK_EXEC(handler, nil, error);
    }];
}

+ (void)addSinglePhotoFavor:(NSInteger)assemarcfileid handler:(RequestCompleteHandler)handler {
    NSString *urlString = @"api/inter/assemarcfilecoll/add";
    
    NSDictionary *parameters = @{@"assemarcfileid":@(assemarcfileid)
                                 };
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        
        BLOCK_EXEC(handler, nil, error);
    }];
}

+ (void)removeSinglePhotoFavor:(NSInteger)assemarcfileid handler:(RequestCompleteHandler)handler {
    NSString *urlString = @"api/inter/assemarcfilecoll/remove";
    
    NSDictionary *parameters = @{@"assemarcfileid":@(assemarcfileid)
                                 };
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        
        BLOCK_EXEC(handler, nil, error);
    }];
}

+ (void)moveToSoulFolder:(NSInteger)assemarcfileid soulFolderId:(NSInteger)soulFolderId handler:(RequestCompleteHandler)handler {
    NSString *urlString = @"api/inter/assemaarcfilecoll/move";
    
    NSDictionary *parameters = @{@"assemarcfileid":@(assemarcfileid),
                                 @"soulfolderid":@(soulFolderId)
                                 };
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        
        BLOCK_EXEC(handler, nil, error);
    }];
}

+ (void)addDownloadCount:(NSInteger)assemarcfileid handler:(RequestCompleteHandler)handler {
    NSString *urlString = @"api/inter/assemarcfile/addDownload";
    
    NSDictionary *parameters = @{@"assemarcfileid":@(assemarcfileid)
                                 };
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        
        BLOCK_EXEC(handler, nil, error);
    }];
}

@end
