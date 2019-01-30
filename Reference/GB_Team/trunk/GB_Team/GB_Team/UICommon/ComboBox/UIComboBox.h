//
//  UIComboBox.h
//  Sample
//
//  Created by abc123 on 14-12-24.
//  Copyright (c) 2014 Ralph Shane. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIComboBox;

@protocol UIComboBoxDelegate <NSObject>
@optional
-(void) comboBox:(UIComboBox *)comboBox selected:(int)selected;
@end

@interface UIComboBox : UIControl
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSArray *entries;
@property (nonatomic) NSUInteger selectedItem;
@property(nonatomic, weak) id<UIComboBoxDelegate> delegate;
@property(strong, nonatomic) UIColor *borderColor;
@property(nonatomic, strong) UIFont *font;
@property(nonatomic, assign) BOOL topShow;

- (void)resetComboBoxSelect;
- (void)setComboBoxPlaceholder:(NSString *)placeholder color:(UIColor *)color;

@end
