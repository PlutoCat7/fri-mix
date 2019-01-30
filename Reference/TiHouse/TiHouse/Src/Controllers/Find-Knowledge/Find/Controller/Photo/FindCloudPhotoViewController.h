//
//  FindCloudPhotoViewController.h
//  TiHouse
//
//  Created by yahua on 2018/2/3.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindKnowledgeBaseViewController.h"
#import "FindCloudCellModel.h"

@protocol FindCloudPhotoViewControllerDelegate <NSObject>

@optional;
- (void)findCloudPhotoViewControllerDidDone:(NSArray<FindCloudCellModel *> *)selectModels;

@end

@interface FindCloudPhotoViewController : BaseViewController

@property (nonatomic, weak) id<FindCloudPhotoViewControllerDelegate> delegate;
@property (nonatomic, assign) NSInteger maxCount;

@end
