//
//  KitFactory.m
//  Express_ios
//
//  Created by Mateen on 16/3/28.
//  Copyright © 2016年 MaTeen. All rights reserved.
//

#import "KitFactory.h"
#import "WebImageView.h"

#define defaultTextColor [UIColor blackColor]
#define defaultFontSize 14
#define defaultBackgroundColor [UIColor clearColor]
#define defaultHighTextColor [UIColor lightGrayColor]

@interface KitFactory ()

@end

@implementation KitFactory

+ (UILabel *)label
{
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = defaultBackgroundColor;
    label.font = [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:defaultFontSize]];
    label.textColor = defaultTextColor;
    return label;
}

+ (UIButton *)button
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = defaultBackgroundColor;
    [button setTitleColor:defaultTextColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:defaultFontSize]];
    [button setTitleColor:defaultHighTextColor forState:UIControlStateHighlighted];
    return button;
}

+ (WebImageView *)imageView
{
    WebImageView *imageView = [[WebImageView alloc]init];
    imageView.backgroundColor = defaultBackgroundColor;
    return imageView;
}

+ (UIView *)view
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = defaultBackgroundColor;
    return view;
}

+ (UITextField *)textField
{
    UITextField *textField = [[UITextField alloc]init];
    textField.backgroundColor = defaultBackgroundColor;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.spellCheckingType = UITextAutocorrectionTypeNo;
    textField.font = [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:defaultFontSize]];
    textField.enablesReturnKeyAutomatically = YES;
    textField.textColor = defaultTextColor;
    textField.keyboardType = UIKeyboardTypeDefault;
    return textField;
}

+ (UITextView *)textView
{
    UITextView *textView = [[UITextView alloc]init];
    textView.backgroundColor = defaultBackgroundColor;
    textView.font = [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:defaultFontSize]];
    textView.textColor = defaultTextColor;
    textView.keyboardType = UIKeyboardTypeDefault;
    textView.returnKeyType = UIReturnKeyDone;
    return textView;
}

+ (UITableView *)tableView
{
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    table.separatorColor = [UIColor clearColor];
    table.separatorInset = UIEdgeInsetsZero;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.backgroundView = [[UIView alloc]init];
    table.backgroundColor = [UIColor clearColor];
    table.showsVerticalScrollIndicator = NO;
    table.showsHorizontalScrollIndicator = NO;
    if (@available(iOS 11.0, *))
    {
        table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    table.estimatedRowHeight = 0;
    table.estimatedSectionFooterHeight = 0;
    table.estimatedSectionHeaderHeight = 0;
    return table;
}

+ (UIScrollView *)scrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    if (@available(iOS 11.0, *))
    {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return scrollView;
}

@end
