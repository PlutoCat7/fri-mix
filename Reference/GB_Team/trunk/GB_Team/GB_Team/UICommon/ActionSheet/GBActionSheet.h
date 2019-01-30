//
//  GBActionSheet.h
//  GB_Football
//
//  Created by Pizza on 16/9/6.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GBActionSheet;
@protocol GBActionSheetDelegate <NSObject>
@optional
- (void)GBActionSheet:(GBActionSheet*)actionSheet index:(NSInteger)index;
@end

@interface GBActionSheet : UIView
+ (instancetype)showWithTitle:(NSString*)title button1:(NSString*)button1 button2:(NSString*)button2 cancel:(NSString*)cancel;
@property(nonatomic, weak) id <GBActionSheetDelegate> delegate;
+ (BOOL)hide;
@end
