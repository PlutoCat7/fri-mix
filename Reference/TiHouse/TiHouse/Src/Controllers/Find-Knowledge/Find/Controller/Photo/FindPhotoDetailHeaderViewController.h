//
//  FindPhotoDetailHeaderViewController.h
//  TiHouse
//
//  Created by yahua on 2018/2/4.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindKnowledgeBaseViewController.h"
#import "FindAssemarcInfo.h"

@protocol FindPhotoDetailHeaderViewControllerDelegate;
@class FindAssemarcFileJA;
@interface FindPhotoDetailHeaderViewController : FindKnowledgeBaseViewController

@property (nonatomic, assign) CGFloat viewHeight;

@property (strong, nonatomic) NSArray <FindAssemarcCommentInfo *> *commentArray;

@property (nonatomic, weak  ) id<FindPhotoDetailHeaderViewControllerDelegate> delegate;

- (void)refreshWithInfo:(FindAssemarcInfo *)info;

@end

@protocol FindPhotoDetailHeaderViewControllerDelegate <NSObject>

- (void)findPhotoDetailHeaderViewController:(FindPhotoDetailHeaderViewController *)controller clickContentImageViewWithViewModel:(FindAssemarcFileJA *)dataModel;
@end
