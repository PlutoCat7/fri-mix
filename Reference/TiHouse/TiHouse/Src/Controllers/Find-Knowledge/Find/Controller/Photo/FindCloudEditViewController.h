//
//  FindCloudEditViewController.h
//  TiHouse
//
//  Created by weilai on 2018/2/7.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindKnowledgeBaseViewController.h"

#import "FindCloudCellModel.h"

@interface FindCloudEditViewController : FindKnowledgeBaseViewController

- (instancetype)initWithCloudPhotos:(NSArray<FindCloudCellModel *> *)photoList;

@end
