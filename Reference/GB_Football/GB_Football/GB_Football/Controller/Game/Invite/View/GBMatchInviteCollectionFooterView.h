//
//  GBMatchInviteCollectionFooterView.h
//  GB_Football
//
//  Created by 王时温 on 2017/5/25.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GBMatchInviteCollectionFooterView;
@protocol GBMatchInviteCollectionFooterViewDelegate <NSObject>

- (void)didClickFoldButton:(GBMatchInviteCollectionFooterView *)footerView;

@end

@interface GBMatchInviteCollectionFooterView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIButton *arrowButton;

@property (nonatomic, weak) id<GBMatchInviteCollectionFooterViewDelegate> delegate;
@property (nonatomic, assign) BOOL isUnFlod;

@end
