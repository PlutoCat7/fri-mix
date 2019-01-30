//
//  FindManager.m
//  TiHouse
//
//  Created by yahua on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindManager.h"
#import "YAHDataResponseInfo.h"
#import "Login.h"

@interface FindDraftSaveListModel : YAHDataResponseInfo

@property (nonatomic, strong) NSArray<FindDraftSaveModel *> *draftList;

@end

@implementation FindDraftSaveListModel

- (NSString *)getCacheKey {
    
    return [NSString stringWithFormat:@"FindDraftSave_%td", [Login curLoginUser].uid];
}

@end

@interface FindManager ()

@end

@implementation FindManager

+ (NSArray<FindDraftSaveModel *> *)getFindDraftList {
    
    FindDraftSaveListModel *listModel = [FindDraftSaveListModel loadCache];
    return listModel.draftList;
}

+ (void)deleteDraftWithModel:(FindDraftSaveModel *)model {
    
    if (!model) {
        return;
    }
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        FindDraftSaveListModel *listModel = [FindDraftSaveListModel loadCache];
        NSMutableArray *tmpList = [NSMutableArray arrayWithArray:listModel.draftList];
        FindDraftSaveModel *willDeleteModel = nil;
        for (FindDraftSaveModel *tmpModel in tmpList) {
            if (tmpModel.identifier == model.identifier) {
                willDeleteModel = tmpModel;
                break;
            }
        }
        if (willDeleteModel) {
            [tmpList removeObject:willDeleteModel];
            listModel.draftList = [tmpList copy];
            [listModel saveCache];
        }
    //});
}

+ (void)modifyOrInsertDraftWithModel:(FindDraftSaveModel *)model {
    
    if (!model) {
        return;
    }
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        FindDraftSaveListModel *listModel = [FindDraftSaveListModel loadCache];
        if (!listModel) {
            listModel = [[FindDraftSaveListModel alloc] init];
        }
        NSMutableArray *tmpList = [NSMutableArray arrayWithArray:listModel.draftList];
        FindDraftSaveModel *modifyModel = nil;
        for (FindDraftSaveModel *tmpModel in tmpList) {
            if (tmpModel.identifier == model.identifier) {
                modifyModel = tmpModel;
                break;
            }
        }
        if (modifyModel) {
            [tmpList removeObject:modifyModel]; //移除旧的
            model.editTimeInterval = [NSDate date].timeIntervalSince1970;
            [tmpList insertObject:model atIndex:0];   //添加新的
            listModel.draftList = [tmpList copy];
            [listModel saveCache];
        }else { //插入
            model.identifier = listModel.draftList.count;
            NSMutableArray *tmpList = [NSMutableArray arrayWithArray:listModel.draftList];
            [tmpList insertObject:model atIndex:0];
            listModel.draftList = [tmpList copy];
            [listModel saveCache];
        }
    //});
}

@end
