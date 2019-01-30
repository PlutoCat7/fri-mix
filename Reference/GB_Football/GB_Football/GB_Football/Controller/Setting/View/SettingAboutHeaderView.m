//
//  SettingAboutHeaderView.m
//  GB_Football
//
//  Created by gxd on 2018/1/11.
//  Copyright © 2018年 Go Brother. All rights reserved.
//

#import "SettingAboutHeaderView.h"

@interface SettingAboutHeaderView()
@property (weak, nonatomic) IBOutlet UIImageView *appImageView;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@end

@implementation SettingAboutHeaderView

- (void)awakeFromNib {
    
    [super awakeFromNib];

    self.desLabel.text = LS(@"setting.label.aboutus.des");
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.appImageView.layer.cornerRadius = 10.f;
}

@end
