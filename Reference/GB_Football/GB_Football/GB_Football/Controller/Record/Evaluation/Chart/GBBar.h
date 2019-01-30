//
//  GBBar.h
//  GB_Football
//
//  Created by Pizza on 2017/1/6.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBBar : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progress;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *axiLabel;

@end
