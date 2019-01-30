//
//  FindPhotoPostCheckViewController.h
//  TiHouse
//
//  Created by yahua on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindKnowledgeBaseViewController.h"
@class FindPhotoHandleModel;
@interface FindPhotoPostCheckViewController : FindKnowledgeBaseViewController

- (instancetype)initWithPhotoList:(NSArray<FindPhotoHandleModel *> *)photoList selectIndex:(NSInteger)selectIndex deleteBlock:(void(^)(NSInteger deleteIndex))deleteBlock;


@end
