//
//  SettingWristHeaderView.m
//  GB_Football
//
//  Created by gxd on 2018/1/11.
//  Copyright © 2018年 Go Brother. All rights reserved.
//

#import "SettingWristHeaderView.h"

#import "GBBluetoothManager.h"

@interface SettingWristHeaderView()
@property (weak, nonatomic) IBOutlet UIImageView *wristImageView;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@end


@implementation SettingWristHeaderView

- (IBAction)actionClickHeader:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickWristHeader)]) {
        [self.delegate didClickWristHeader];
    }
}

#pragma mark - Public

- (void)refreshUI {
    if ([GBBluetoothManager sharedGBBluetoothManager].isConnectedBean) {
        self.wristImageView.image = [UIImage imageNamed:@"t_goal_y.png"];
        self.desLabel.text = LS(@"menu.icon.connected");
        
    } else {
        self.wristImageView.image = [UIImage imageNamed:@"t_goal_n.png"];
        self.desLabel.text = LS(@"setting.label.wrist.unconnect");
    }
}
@end
