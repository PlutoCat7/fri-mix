//
//  CatalogViewModel.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/13.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "CatalogViewModel.h"
#import "CatalogRequest.h"

#import "CatalogDetailViewController.h"

@interface CatalogViewModel ()

//网络返回数据
@property (nonatomic, strong) CatalogResponseData *catalogResponseData;

//显示数据
@property (nonatomic, strong) NSArray<CatalogModel *> *datas;

@end

@implementation CatalogViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadData];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationUserInfoChange) name:Notification_Has_Login_In object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationUserInfoChange) name:Notification_Has_Login_Out object:nil];
    }
    return self;
}

#pragma mark - Public

- (void)getNetworkDataWithHandler:(void(^)(NSError *error))handler {
    
    NSString *userId = [RawCacheManager sharedRawCacheManager].userId;
    [CatalogRequest getCatalogDataWithUserId:userId handler:^(id result, NSError *error) {
        
        if (!error) {
            self.catalogResponseData = result;
            
            [self.catalogResponseData saveCache];
        }
        BLOCK_EXEC(handler, error);
    }];
}

- (void)enterDetailViewWithNavigationController:(UINavigationController *)nav indexPath:(NSIndexPath *)indexPath {
    
    CatalogInfo *info = self.catalogResponseData.catalogs[indexPath.section];
    NSInteger firstCid = info.catalogId;
    NSInteger secondCid = 0;
    if (info.children.count>0) {
        secondCid = info.children[indexPath.row].catalogId;
    }
    CatalogDetailViewController *vc = [[CatalogDetailViewController alloc] initWithTitle:info.name firstCid:firstCid secondCid:secondCid];
    vc.hidesBottomBarWhenPushed = YES;
    [nav pushViewController:vc animated:YES];
}

#pragma mark - Notification

- (void)notificationUserInfoChange {
    
    //刷新列表
    [self getNetworkDataWithHandler:nil];
}

#pragma mark - Private

- (void)loadData {
    
    self.catalogResponseData = [CatalogResponseData loadCache];
}

#pragma mark - Setter and Getter

- (void)setCatalogResponseData:(CatalogResponseData *)catalogResponseData {
    
    _catalogResponseData = catalogResponseData;
    
    NSMutableArray *tmpList = [NSMutableArray arrayWithCapacity:catalogResponseData.catalogs.count];
    for (CatalogInfo *info in catalogResponseData.catalogs) {
        CatalogModel *model = [[CatalogModel alloc] init];
        model.title = info.name;
        NSMutableArray *subList = [NSMutableArray arrayWithCapacity:info.children.count];
        for (CatalogInfo *subInfo in info.children) {
            CatalogModel *subModel = [[CatalogModel alloc] init];
            subModel.title = subInfo.name;
            [subList addObject:subModel];
        }
        model.subCatalogs = [subList copy];
        [tmpList addObject:model];
    }
    self.datas = [tmpList copy];
}

@end
