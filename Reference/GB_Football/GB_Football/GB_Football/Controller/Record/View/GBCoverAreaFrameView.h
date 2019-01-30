//
//  GBCoverAreaFrameView.h
//  GB_Football
//
//  Created by yahua on 2017/8/28.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXNibBridge.h"

typedef NS_ENUM(NSUInteger, CoverAreaFrameViewType) {
    CoverAreaFrameViewType_Three,
    CoverAreaFrameViewType_Six,
    CoverAreaFrameViewType_Nine,
};

@interface GBCoverAreaFrameView : UIView <XXNibBridge>

- (void)refreshWithData:(NSArray<NSString *> *)datas times:(NSArray<NSString *> *)times type:(CoverAreaFrameViewType)type;
- (void)setShowTimeRateInView:(BOOL)showTime;

@end
