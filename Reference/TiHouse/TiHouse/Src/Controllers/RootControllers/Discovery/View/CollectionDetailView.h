//
//  CollectionDetailView.h
//  TiHouse
//
//  Created by Teen Ma on 2018/4/11.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CollectionDetailViewModel;

@protocol CollectionDetailViewDelegate;

@interface CollectionDetailView : UIView

@property (nonatomic, weak  ) id<CollectionDetailViewDelegate> delegate;

- (void)resetViewWithViewModel:(CollectionDetailViewModel *)viewModel;

@end

@protocol CollectionDetailViewDelegate <NSObject>

- (void)collectionDetailView:(CollectionDetailView *)view clickLargeImageWithViewModel:(CollectionDetailViewModel *)viewModel;

@end
