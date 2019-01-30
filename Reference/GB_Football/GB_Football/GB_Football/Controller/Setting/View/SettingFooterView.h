//
//  SettingFooterView.h
//  GB_Football
//
//  Created by 王时温 on 2017/6/9.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingFooterViewDelegate <NSObject>

- (void)didClickFooterView;

@end

@interface SettingFooterView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, weak) id<SettingFooterViewDelegate> delegate;

@end
