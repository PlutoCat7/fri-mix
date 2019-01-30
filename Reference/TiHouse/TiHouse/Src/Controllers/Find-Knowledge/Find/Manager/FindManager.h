//
//  FindManager.h
//  TiHouse
//
//  Created by yahua on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FindDraftSaveModel.h"

@interface FindManager : NSObject

+ (NSArray<FindDraftSaveModel *> *)getFindDraftList;
+ (void)deleteDraftWithModel:(FindDraftSaveModel *)model;
+ (void)modifyOrInsertDraftWithModel:(FindDraftSaveModel *)model;

@end
