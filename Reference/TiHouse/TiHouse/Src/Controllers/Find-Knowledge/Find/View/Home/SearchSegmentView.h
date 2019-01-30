//
//  SearchSegmentView.h
//  TiHouse
//
//  Created by weilai on 2018/4/16.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchSegmentView;
@protocol SearchSegmentViewDelegate <NSObject>

- (void)searchSegmentViewMenuChange:(SearchSegmentView *)view Index:(NSInteger)index;

@end

@interface SearchSegmentView : UIView

@property (nonatomic, weak) id<SearchSegmentViewDelegate> delegate;

@end
