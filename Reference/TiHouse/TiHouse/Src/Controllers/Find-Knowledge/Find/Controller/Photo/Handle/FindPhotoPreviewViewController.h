//
//  FindPhotoPreviewViewController.h
//  TiHouse
//
//  Created by weilai on 2018/2/4.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindKnowledgeBaseViewController.h"
#import "FindAssemarcInfo.h"

@interface FindPhotoPreviewModel : NSObject

@property (nonatomic, assign) NSInteger imageId;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSArray<FindAssemarcFileTagJA *> *labelModelList;

@end

@interface FindPhotoPreviewViewController : FindKnowledgeBaseViewController

- (instancetype)initWithPhotoList:(NSArray<FindPhotoPreviewModel *> *)photoList showIndex:(NSInteger)showIndex arcInfo:(FindAssemarcInfo *)arcInfo;

@end
