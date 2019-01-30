//
//  FindDraftStore.h
//  TiHouse
//
//  Created by yahua on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FindDraftCellModel;
@class FindDraftSaveModel;
@interface FindDraftStore : NSObject

@property (nonatomic, strong, readonly) NSArray<FindDraftCellModel *> *cellModels;

- (void)deleteCellWithIndexPath:(NSIndexPath *)indexPath;

- (FindDraftSaveModel *)findDraftSaveModelWithIndexPath:(NSIndexPath *)indexPath;

@end
