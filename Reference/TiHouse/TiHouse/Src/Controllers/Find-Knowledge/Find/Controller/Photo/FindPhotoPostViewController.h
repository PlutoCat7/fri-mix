//
//  FindPhotoPostViewController.h
//  TiHouse
//
//  Created by yahua on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindKnowledgeBaseViewController.h"
#import "FindPhotoLabelModel.h"

@class FindAssemActivityInfo;

@interface FindPhotoPostDataManager : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, strong) FindAssemActivityInfo *currentAssemActivity;

@end

@interface FindPhotoPostViewController : FindKnowledgeBaseViewController

- (instancetype)initWithWithPhotoModelList:(NSArray<FindPhotoHandleModel *> *)list;

@end
