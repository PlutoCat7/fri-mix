//
//  TacticeHeaderView.h
//  GB_Football
//
//  Created by yahua on 2017/12/27.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXNibBridge.h"

@protocol TacticeHeaderViewDelegate <NSObject>

- (void)didClickAddStep;

- (void)didClickDeleteStep;

@end


@interface TacticeHeaderView : UIView <XXNibBridge>

@property (nonatomic, weak) id<TacticeHeaderViewDelegate> delegate;

@end
