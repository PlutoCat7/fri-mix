//
//  FindPhotoAddLabelAlertView.h
//  TiHouse
//
//  Created by yahua on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FindPhotoThingResponse.h"
#import "FindPhotoLabelResponse.h"
#import "FindPhotoStyleResponse.h"

@interface FindPhotoAddLabelAlertView : UIView

+ (instancetype)showWithNavigation:(UINavigationController *)nav doneBlock:(void(^)(FindPhotoThingInfo *info, NSArray<FindPhotoLabelInfo *> *labelList, NSArray<FindPhotoStyleInfo *> *styleList))doneBlock;

@property (nonatomic, assign) BOOL isSpaceVaild;
@property (nonatomic, assign) BOOL isStyleVaild;

@end
