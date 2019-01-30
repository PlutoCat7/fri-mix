//
//  GBShareItem.h
//  GB_Football
//
//  Created by Pizza on 2016/11/18.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMShareManager.h"

@class GBShareItem;

@protocol GBShareItemDelegate <NSObject>
@optional
- (void)GBShareItemAction:(GBShareItem*)item tag:(SHARE_TYPE)tag;
@end

@interface GBShareItem : UIView

@property (nonatomic, weak) id<GBShareItemDelegate> delegate;

@end
