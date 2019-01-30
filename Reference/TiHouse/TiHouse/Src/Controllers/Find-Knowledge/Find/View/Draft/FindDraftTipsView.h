//
//  FindDraftTipsView.h
//  TiHouse
//
//  Created by yahua on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kFindDraftTipsViewHeight kRKBWIDTH(35)

@class FindDraftTipsView;
@protocol FindDraftTipsViewDelegate <NSObject>

- (void)FindDraftTipsView_ClickClose:(FindDraftTipsView *)tipsView;

@end

@interface FindDraftTipsView : UIView

@property (nonatomic, weak) id<FindDraftTipsViewDelegate> delegate;

@end
