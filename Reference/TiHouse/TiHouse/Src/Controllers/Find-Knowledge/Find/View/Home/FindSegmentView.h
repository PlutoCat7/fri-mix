//
//  FindSegmentView.h
//  TiHouse
//
//  Created by yahua on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FindSegmentView;
@protocol FindSegmentViewDelegate <NSObject>

- (void)findSegmentViewMenuChange:(FindSegmentView *)view Index:(NSInteger)index;

@end

@interface FindSegmentView : UIView

@property (nonatomic, weak) id<FindSegmentViewDelegate> delegate;

@end
