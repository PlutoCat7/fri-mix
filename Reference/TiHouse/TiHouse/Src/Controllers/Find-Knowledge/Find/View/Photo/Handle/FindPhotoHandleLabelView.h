//
//  FindPhotoHandleLabelView.h
//  TiHouse
//
//  Created by yahua on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMDragView.h"

@class FindAssemarcFileTagJA;
@interface FindPhotoHandleLabelView : WMDragView

+ (instancetype)createWithLabelModel:(FindAssemarcFileTagJA *)model longPressBlock:(void(^)(FindPhotoHandleLabelView *labelView))longPressBlock clickBlock:(void(^)(FindPhotoHandleLabelView *labelView))clickBlock edit:(BOOL)edit;

@end
