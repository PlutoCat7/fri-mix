//
//  GBBatteryIndicator.m
//  GB_Football
//
//  Created by Pizza on 16/8/11.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBBatteryIndicator.h"
#import "XXNibBridge.h"
#import "GBBluetoothManager.h"
@interface GBBatteryIndicator()<XXNibBridge>

// 电池状态
@property (assign,nonatomic) BATTERY_STATE state;
// 电池背景图
@property (weak, nonatomic) IBOutlet UIImageView *batteyImageView;
// 百分比标志
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@end

@implementation GBBatteryIndicator

-(void)setState:(BATTERY_STATE)state
{
    _state = state;
    switch (state)
    {
        case BATTERY_STATE_NULL:
            self.batteyImageView.image = [GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.chargeType==iBeaconCharge_Charging
            ?[UIImage imageNamed:@"charging_1"]:[UIImage imageNamed:@"electricity_1"];
            break;
        case BATTERY_STATE_LOW:
            self.batteyImageView.image = [GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.chargeType==iBeaconCharge_Charging
            ?[UIImage imageNamed:@"charging_1"]:[UIImage imageNamed:@"electricity_2"];
            break;
        case BATTERY_STATE_MIDDLE:
            self.batteyImageView.image = [GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.chargeType==iBeaconCharge_Charging
            ?[UIImage imageNamed:@"charging_2"]:[UIImage imageNamed:@"electricity_3"];
            break;
        case BATTERY_STATE_HIGH:
            self.batteyImageView.image = [GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.chargeType==iBeaconCharge_Charging
            ?[UIImage imageNamed:@"charging_2"]:[UIImage imageNamed:@"electricity_4"];
            break;
        case BATTERY_STATE_FULL:
            self.batteyImageView.image = [GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.chargeType==iBeaconCharge_Charging
            ?[UIImage imageNamed:@"charging_2"]:[UIImage imageNamed:@"electricity_5"];
            break;
        default:
            break;
    }
}

-(void)setPercent:(NSInteger)percent
{
    _percent = percent;
    if ([GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.chargeType==iBeaconCharge_Charging) {
        self.percentLabel.text = LS(@"menu.icon.charging");
    } else {
        self.percentLabel.text = [NSString stringWithFormat:@"%d%%",(int)percent];
    }
    
    if (percent<=30) {
        self.state = BATTERY_STATE_NULL;
        self.percentLabel.textColor = [UIColor redColor];
    }else if (percent > 30 && percent<= 45) {
        self.state = BATTERY_STATE_LOW;
        self.percentLabel.textColor = [UIColor redColor];
    }else if (percent > 45 && percent<= 55) {
        self.state = BATTERY_STATE_MIDDLE;
        self.percentLabel.textColor = [UIColor greenColor];
    }else if (percent > 55 && percent<= 70) {
        self.state = BATTERY_STATE_HIGH;
        self.percentLabel.textColor = [UIColor greenColor];
    }else if (percent > 70) {
        self.state = BATTERY_STATE_FULL;
        self.percentLabel.textColor = [UIColor greenColor];
    }
    
}

@end
