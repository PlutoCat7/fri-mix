//
//  GBCoverAreaCarveView.h
//  GB_Football
//
//  Created by yahua on 2017/8/28.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXNibBridge.h"

@class GBCoverAreaCarveView;

@protocol GBCoverAreaCarveViewDelegate <NSObject>

- (void)didSelectCoverAreaCarveViewWithIndex:(NSInteger)index;

@end

@interface GBCoverAreaCarveView : UIView <XXNibBridge>

@property (nonatomic, weak) id<GBCoverAreaCarveViewDelegate> delegate;

- (void)selectWithIndex:(NSInteger)index;

@end
