//
//  TacticsContainerHeaderView.h
//  GB_Football
//
//  Created by yahua on 2018/1/12.
//  Copyright © 2018年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXNibBridge.h"

@protocol TacticsContainerHeaderViewDelegate <NSObject>

- (void)didClickTactics;

- (void)didClickLineUp;

@end

@interface TacticsContainerHeaderView : UIView <XXNibBridge>

@property (nonatomic, weak) id<TacticsContainerHeaderViewDelegate> delegate;

@end
