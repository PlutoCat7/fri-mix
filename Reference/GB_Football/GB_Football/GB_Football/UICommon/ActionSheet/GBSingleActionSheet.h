//
//  GBSingleActionSheet.h
//  GB_Football
//
//  Created by gxd on 17/7/26.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GBSingleActionSheet;
@protocol GBSingleActionSheetDelegate <NSObject>
@optional
- (void)GBSingleActionSheet:(GBSingleActionSheet*)actionSheet index:(NSInteger)index;
@end

@interface GBSingleActionSheet : UIView

+ (instancetype)showWithTitle:(NSString*)title button1:(NSString*)button1 cancel:(NSString*)cancel;
+ (instancetype)showWithTitle:(NSString*)title button1:(NSString*)button1 cancel:(NSString*)cancel handle:(void(^)(NSInteger index))handle;
@property(nonatomic, weak) id <GBSingleActionSheetDelegate> delegate;
+ (BOOL)hide;

@end
