//
//  LeftMenuFooterView.h
//  MagicBean
//
//  Created by yahua on 16/3/29.
//  Copyright © 2016年 wangsw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftMenuFooterView : UIView

@property (weak, nonatomic) IBOutlet UILabel *btcPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *topLine;

- (void)reloadWithBtcPrice:(NSString *)btcPrice;

@end
