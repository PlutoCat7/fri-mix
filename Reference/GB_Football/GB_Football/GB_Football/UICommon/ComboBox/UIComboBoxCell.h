//
//  UIComboBoxCell.h
//  GB_Team
//
//  Created by weilai on 16/9/19.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIComboBoxCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *teamName;
-(void)setupShowLine:(BOOL)top bottom:(BOOL)bottom;
@end
