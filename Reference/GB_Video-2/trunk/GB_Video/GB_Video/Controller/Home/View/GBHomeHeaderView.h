//
//  GBHomeHeaderView.h
//  GB_Video
//
//  Created by gxd on 2018/1/24.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GBHomeResponseInfo.h"

@protocol GBHomeHeaderViewDelegate <NSObject>
@optional
- (void)didSelectBannerInfo:(BannerInfo *)bannerInfo;
- (void)didSelectTopicInfo:(TopicInfo *)topicInfo;
@end

@interface GBHomeHeaderView : UICollectionReusableView

// 接受邀请点击按钮回调
@property (nonatomic, weak) id<GBHomeHeaderViewDelegate> delegate;

- (void)refreshWithHomeHeaderInf:(HomeHeaderInfo *)homeHeaderInfo;

@end
