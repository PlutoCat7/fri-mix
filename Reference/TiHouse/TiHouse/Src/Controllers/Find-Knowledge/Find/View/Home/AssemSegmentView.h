//
//  AssemSegmentView.h
//  TiHouse
//
//  Created by yahua on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AssemSegmentView;
@protocol AssemSegmentViewDelegate <NSObject>

- (void)assemSegmentViewMenuChange:(AssemSegmentView *)view Index:(NSInteger)index;

@end


@interface AssemSegmentView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, weak) id<AssemSegmentViewDelegate> delegate;

@end
