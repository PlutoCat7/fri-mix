//
//  SettingHeaderView.m
//  GB_Football
//
//  Created by 王时温 on 2017/6/8.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "SettingHeaderView.h"
#import "UIImageView+WebCache.h"

@interface SettingHeaderView ()

@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation SettingHeaderView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self localUI];
    
    [self setupNotification];
    
    [self refreshUI];
    
    [self.button addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
    [self.button addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.avatorContainerView.layer.cornerRadius = self.avatorContainerView.width/2;
    self.avatorImageView.layer.cornerRadius = self.avatorImageView.width/2;
}

- (void)localUI {
    
    self.numberStaticLabel.text = [NSString stringWithFormat:@"%@：", LS(@"setting.label.team.number")];
    self.teamStaticLabel.text = [NSString stringWithFormat:@"%@：", LS(@"setting.label.team.name")];
}

#pragma mark - Public

- (void)refreshUI {
    
    UserInfo *userInfo = [RawCacheManager sharedRawCacheManager].userInfo;
    [self.avatorImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.imageUrl] placeholderImage:self.avatorImageView.image];
    NSArray *positionList = [userInfo.position componentsSeparatedByString:@","];
    self.pos1View.index = [positionList.firstObject integerValue];
    self.userNameLabel.text = userInfo.nick;
    self.numberLabel.text = @(userInfo.teamNo).stringValue;
    
    NSString *teamName = userInfo.teamName.length == 0 ? LS(@"team.info.name.empty") : userInfo.teamName;
    if (userInfo.team_mess) {
        teamName = userInfo.team_mess.teamName;
    }
    self.teamNameLabel.text = teamName;
}

#pragma mark - NSNotification 

- (void)setupNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAvatorNotification:) name:Notification_User_Avator object:nil];
}

- (void)changeAvatorNotification:(NSNotification *)notification {
    
    UIImage *image = notification.object;
    if (image) {
        self.avatorImageView.image = image;
    }
}

#pragma mark - Action

- (IBAction)actionClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickUserInfo)]) {
        [self.delegate didClickUserInfo];
    }
}

-(void)touchDown
{
    self.button.backgroundColor = [UIColor colorWithHex:0x202020 andAlpha:0.5f];
}

-(void)touchUp
{
    self.button.backgroundColor = [UIColor colorWithHex:0x202020];
}

@end
