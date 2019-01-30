//
//  MenuItemBar.h
//  GB_Football
//
//  Created by Pizza on 2016/11/25.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuItemBar;

@protocol GBMenuItemBarDelegate <NSObject>
-(void)menuItemBar:(MenuItemBar*)menubar index:(NSInteger)index;
@end

@interface MenuItemBar : UIView

@property (nonatomic,strong) NSArray *iconNames;
@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,weak) id<GBMenuItemBarDelegate> delegate;

- (void)refreshUI;

@end
