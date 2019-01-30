//
//  UserTextField.h
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/25.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserTextField : UIView

@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, assign) UIEdgeInsets textFieldInsets;
-(instancetype)initWithPlaceholder:(NSString *)placeholder IconImage:(NSString *)icon;

@end
