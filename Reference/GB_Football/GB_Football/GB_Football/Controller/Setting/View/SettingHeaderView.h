//
//  SettingHeaderView.h
//  GB_Football
//
//  Created by 王时温 on 2017/6/8.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBPositionLabel.h"

@protocol SettingHeaderViewDelegate <NSObject>

- (void)didClickUserInfo;

@end

@interface SettingHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIView *avatorContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet GBPositionLabel *pos1View;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;

//静态文本
@property (weak, nonatomic) IBOutlet UILabel *numberStaticLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamStaticLabel;

@property (nonatomic, weak) id<SettingHeaderViewDelegate> delegate;

- (void)refreshUI;

@end
