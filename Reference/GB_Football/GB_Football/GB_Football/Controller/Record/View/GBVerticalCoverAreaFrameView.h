//
//  GBVerticalCoverAreaFrameView.h
//  GB_Football
//
//  Created by yahua on 2017/8/29.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXNibBridge.h"

typedef NS_ENUM(NSUInteger, VerticalCoverAreaFrameViewType) {
    VerticalCoverAreaFrameViewType_Three,
    VerticalCoverAreaFrameViewType_Six,
    VerticalCoverAreaFrameViewType_Nine,
};


@interface GBVerticalCoverAreaFrameView : UIView<XXNibBridge>


- (void)refreshWithData:(NSArray<NSString *> *)datas times:(NSArray<NSString *> *)times type:(VerticalCoverAreaFrameViewType)type;
- (void)setShowTimeRateInView:(BOOL)showTime;

@end
