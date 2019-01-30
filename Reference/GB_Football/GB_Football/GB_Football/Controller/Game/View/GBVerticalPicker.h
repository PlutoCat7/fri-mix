//
//  GBVerticalPicker.h
//  GB_Football
//
//  Created by Pizza on 16/8/22.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GBVerticalViewDelegate;
@protocol GBVerticalViewDataSource;



@interface GBVerticalPicker : UIView

@property (nonatomic, weak) id<GBVerticalViewDelegate> delegate;
@property (nonatomic, weak) id<GBVerticalViewDataSource> dataSource;
@property (nonatomic, assign) NSUInteger topRowCount;
@property (nonatomic, assign) NSUInteger bottomRowCount;
@property (nonatomic, assign) NSUInteger selectedRow;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, strong) UIFont *selectedRowFont;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) CGFloat unselectedRowScale;
@property (nonatomic, readonly, assign) NSUInteger rowCount;
@property (nonatomic, readonly, assign) CGFloat fitHeight;
- (void)reloadData;
- (void)selectRow:(NSInteger)row animated:(BOOL)animated;
@end

@protocol GBVerticalViewDelegate <NSObject>

@optional
- (NSString *)pickerView:(GBVerticalPicker *)pickerView titleForRow:(NSUInteger)indexPath;
- (void)pickerView:(GBVerticalPicker *)pickerView changedIndex:(NSUInteger)indexPath;

@end
@protocol GBVerticalViewDataSource <NSObject>

- (NSInteger)pickerView:(GBVerticalPicker*)pickerView;

@end
