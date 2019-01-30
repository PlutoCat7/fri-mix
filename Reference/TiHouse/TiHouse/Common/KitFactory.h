//
//  KitFactory.h
//  Express_ios
//
//  Created by Mateen on 16/3/28.
//  Copyright © 2016年 MaTeen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KitFactory : NSObject

+ (UIView *)view;

+ (UILabel *)label;

+ (UIButton *)button;

+ (UITextField *)textField;

+ (UITextView *)textView;

+ (WebImageView *)imageView;

+ (UITableView *)tableView;

+ (UIScrollView *)scrollView;

@end
