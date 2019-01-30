//
//  FindDraftStore.m
//  TiHouse
//
//  Created by yahua on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindDraftStore.h"
#import "FindDraftCellModel.h"
#import "FindManager.h"
#import "NSDate+Extend.h"

@interface FindDraftStore()

@property (nonatomic, strong) NSArray<FindDraftCellModel *> *cellModels;
@property (nonatomic, strong) NSArray<FindDraftSaveModel *> *draftList;

@end

@implementation FindDraftStore

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadData];
    }
    return self;
}

#pragma mark - Public

- (FindDraftSaveModel *)findDraftSaveModelWithIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < self.draftList.count) {
        return self.draftList[indexPath.row];
    }
    return nil;
}

- (void)deleteCellWithIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row>=self.draftList.count) {
        return;
    }
    //删除本地
    FindDraftSaveModel *willDeleteDraftModel = self.draftList[indexPath.row];
    [FindManager deleteDraftWithModel:willDeleteDraftModel];
    
    NSMutableArray *tmpList = [NSMutableArray arrayWithArray:self.draftList];
    [tmpList removeObjectAtIndex:indexPath.row];
    self.draftList = [tmpList copy];
    
    tmpList = [NSMutableArray arrayWithArray:self.cellModels];
    [tmpList removeObjectAtIndex:indexPath.row];
    self.cellModels = [tmpList copy];
}

#pragma mark - Private

- (void)loadData {
    
    self.draftList = [FindManager getFindDraftList];
    NSMutableArray<FindDraftCellModel *> *result = [NSMutableArray arrayWithCapacity:self.draftList.count];
    for (FindDraftSaveModel *saveModel in self.draftList) {
        FindDraftCellModel *cellModel = [FindDraftCellModel new];
        cellModel.coverImageUrl = [NSURL URLWithString:saveModel.coverFullImageUrl];
        cellModel.title = saveModel.title;
        NSDate *editDate = [NSDate dateWithTimeIntervalSince1970:saveModel.editTimeInterval];
        cellModel.editDateString = [NSString stringWithFormat:@"最近编辑：%td/%02td/%02td %02td:%02td", editDate.year, editDate.month, editDate.day, editDate.hour, editDate.minute];
        
        [result addObject:cellModel];
    }
    self.cellModels = [result copy];
}



@end
