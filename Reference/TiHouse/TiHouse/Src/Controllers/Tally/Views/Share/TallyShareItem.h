//
//  TallyShareItem.h
//
//  Created by Pizza on 2016/11/18.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMShareManager.h"

@class TallyShareItem;

@protocol TallyShareItemDelegate <NSObject>
@optional
- (void)TallyShareItemAction:(TallyShareItem*)item tag:(SHARE_TYPE)tag;
@end

@interface TallyShareItem : UIView

@property (nonatomic, weak) id<TallyShareItemDelegate> delegate;

@end
