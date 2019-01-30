//
//  GBRecordPlayerDetailViewController.m
//  GB_Team
//
//  Created by Pizza on 16/9/20.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBRecordPlayerDetailViewController.h"
#import "GBPositionLabel.h"
#import "UIImageView+WebCache.h"
#import "LogicManager.h"

#import "MatchRequest.h"

@interface GBRecordPlayerDetailViewController () 

/* ＊＊＊＊＊＊＊＊＊
    球员简要信息
*＊＊＊＊＊＊＊＊＊ */
// 头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
// 姓名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
// 球衣号码
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
// 位置
@property (weak, nonatomic) IBOutlet GBPositionLabel *positionLabel1;
@property (weak, nonatomic) IBOutlet GBPositionLabel *positionLabel2;
// 移动距离
@property (weak, nonatomic) IBOutlet UILabel *moveDisctanceLabel;
// 最高速度
@property (weak, nonatomic) IBOutlet UILabel *highestSpeedLabel;
// 体能消耗
@property (weak, nonatomic) IBOutlet UILabel *calorieLabel;
/* ＊＊＊＊＊＊＊＊＊
    速度表
 *＊＊＊＊＊＊＊＊＊ */
// 冲刺累积距离
@property (weak, nonatomic) IBOutlet UILabel *dashDistanceLabel;
// 冲刺累积时间
@property (weak, nonatomic) IBOutlet UILabel *dashTimeLabel;
// 中速累积距离
@property (weak, nonatomic) IBOutlet UILabel *midDistanceLabel;
// 中速累积时间
@property (weak, nonatomic) IBOutlet UILabel *midTimeLabel;
// 低速累积距离
@property (weak, nonatomic) IBOutlet UILabel *lowDistanceLabel;
// 低速累积时间
@property (weak, nonatomic) IBOutlet UILabel *lowTimeLabel;

// 冲刺积累距离单位KM/M
@property (weak, nonatomic) IBOutlet UILabel *unitDashLabel;
// 中速积累距离单位KM/M
@property (weak, nonatomic) IBOutlet UILabel *unitMiddleLabel;
// 低速积累距离距离单位KM/M
@property (weak, nonatomic) IBOutlet UILabel *unitLowLabel;

// 冲刺累积时间单位
@property (weak, nonatomic) IBOutlet UILabel *minDashLabel;
// 中速累积时间单位
@property (weak, nonatomic) IBOutlet UILabel *minMiddleLabel;
// 低速累积时间单位
@property (weak, nonatomic) IBOutlet UILabel *minLowLabel;

/* ＊＊＊＊＊＊＊＊＊
    上下半场综合
 *＊＊＊＊＊＊＊＊＊ */

// 上半场体能消耗
@property (weak, nonatomic) IBOutlet UILabel *firstPhysicalLabel;
// 上半场冲刺次数
@property (weak, nonatomic) IBOutlet UILabel *firstDashCountLabel;
// 上半场冲刺距离
@property (weak, nonatomic) IBOutlet UILabel *firstDashDistanceLabel;
// 上半场最高速度
@property (weak, nonatomic) IBOutlet UILabel *firstHeightestSpeedLabel;
// 上半场移动距离
@property (weak, nonatomic) IBOutlet UILabel *firstMoveDistanceSpeedLabel;

// 下半场体能消耗
@property (weak, nonatomic) IBOutlet UILabel *secondPhysicalLabel;
// 下半场冲刺次数
@property (weak, nonatomic) IBOutlet UILabel *secondDashCountLabel;
// 下半场冲刺距离
@property (weak, nonatomic) IBOutlet UILabel *secondDashDistanceLabel;
// 下半场最高速度
@property (weak, nonatomic) IBOutlet UILabel *secondHeightestSpeedLabel;
// 下半场移动距离
@property (weak, nonatomic) IBOutlet UILabel *secondMoveDistanceSpeedLabel;

// 全场热力图
@property (strong, nonatomic) IBOutlet UIImageView *fullHeatMap;
// 上半场热力图
@property (strong, nonatomic) IBOutlet UIImageView *firstHeatMap;
// 下半场热力图
@property (strong, nonatomic) IBOutlet UIImageView *secondHeatMap;
@property (weak, nonatomic) IBOutlet UIButton *changDirectionButton;
// 全场图指示器
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *fullActivityIndicator;
// 上半场指示器
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *firstActivityIndicator;
// 下半场指示器
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *secondActivityIndicator;

@property (strong, nonatomic) MatchPlayerInfo *playerInfo;
@property (strong, nonatomic) MatchMessInfo *matchInfo;
@property (nonatomic, assign) BOOL changDirection;

// 短信发送按钮
@property (nonatomic, strong) UIButton *sendButton;

@end

@implementation GBRecordPlayerDetailViewController

- (instancetype)initWithMatchPlayer:(MatchPlayerInfo *)playerInfo matchInfo:(MatchMessInfo *)matchInfo {
    
    if (self = [super init]) {
        _playerInfo = playerInfo;
        _matchInfo = matchInfo;
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    self.headImageView.layer.cornerRadius = self.headImageView.width/2;
    self.headImageView.clipsToBounds = YES;
}

#pragma mark - Action
// 按下方向变化按钮
- (IBAction)actionChangeDirection:(id)sender {
    
    self.changDirection = !self.changDirection;
    CGFloat angle = self.changDirection?M_PI:0;
    CGAffineTransform at = CGAffineTransformMakeRotation(angle);
    
    [self.fullHeatMap setTransform:at];
    [self.firstHeatMap setTransform:at];
    [self.secondHeatMap setTransform:at];
}

- (void)actionSendPress {
    [self showLoadingToast];
    @weakify(self)
    [MatchRequest sendMatchShortMessage:self.matchInfo.match_id playerId:self.playerInfo.player_id handler:^(id result, NSError *error) {
        @strongify(self)
        [self dismissToast];
        
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            [self showToastWithText:LS(@"短信已经发送成功")];
        }
    }];
}

#pragma mark - Delegate

#pragma mark - Private

- (void)setupUI {
    
    self.title = self.playerInfo.player_name;
    [self setupBackButtonWithBlock:nil];
    
    if (![NSString stringIsNullOrEmpty:self.playerInfo.phone]) {
        [self setupRightButton];
    }

    [self setupUIData];
    
    [self showHeapMap];
}

- (void)setupRightButton {
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendButton setSize:CGSizeMake(100, 44)];
    [self.sendButton.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    [self.sendButton setTitle:LS(@"短信分享") forState:UIControlStateNormal];
    [self.sendButton setTitle:LS(@"短信分享") forState:UIControlStateHighlighted];
    [self.sendButton setTitleColor:[ColorManager textColor] forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[ColorManager disableColor] forState:UIControlStateDisabled];
    self.sendButton.backgroundColor = [UIColor clearColor];
    [self.sendButton addTarget:self action:@selector(actionSendPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:self.sendButton];
    [self.navigationItem setRightBarButtonItem:rightButton];
}

- (void)showHeapMap {
    
    [self.fullActivityIndicator startAnimating];
    @weakify(self)
    [self.fullHeatMap sd_setImageWithURL:[NSURL URLWithString:self.playerInfo.heatmap_data.final_url] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        @strongify(self)
        [self.fullActivityIndicator stopAnimating];
        self.changDirectionButton.enabled = YES;
    }];
    
    [self.firstActivityIndicator startAnimating];
    [self.firstHeatMap sd_setImageWithURL:[NSURL URLWithString:self.playerInfo.heatmap_data.first_half_url] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        @strongify(self)
        [self.firstActivityIndicator stopAnimating];
    }];
    
    [self.secondActivityIndicator startAnimating];
    [self.secondHeatMap sd_setImageWithURL:[NSURL URLWithString:self.playerInfo.heatmap_data.second_half_url] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        @strongify(self)
        [self.secondActivityIndicator stopAnimating];
    }];
}

- (void)setupUIData {
    
    if (_playerInfo == nil) {
        return;
    }
    
    UIImage *placeholderImage = [UIImage imageNamed:@"portrait_placeholder"];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.playerInfo.image_url] placeholderImage:placeholderImage];
    
    self.nameLabel.text = self.playerInfo.player_name;
    self.numberLabel.text = [NSString stringWithFormat:@"%td", self.playerInfo.clothes_no];
    
    NSArray<NSString*> *selectList = @[];
    if (![NSString stringIsNullOrEmpty:_playerInfo.position]) {
        selectList = [_playerInfo.position componentsSeparatedByString:@","];
    }
    if (selectList.count > 0) {
        self.positionLabel1.hidden = NO;
        self.positionLabel1.index = selectList.firstObject.integerValue;
    } else {
        self.positionLabel1.hidden = YES;
    }
    if (selectList.count > 1) {
        self.positionLabel2.hidden = NO;
        self.positionLabel2.index = selectList.lastObject.integerValue;
    } else {
        self.positionLabel2.hidden = YES;
    }
    
    if (self.playerInfo.move_distance>=1000) {
        self.moveDisctanceLabel.text = [NSString stringWithFormat:@"%.1f KM", self.playerInfo.move_distance/1000];
    }else {
        self.moveDisctanceLabel.text = [NSString stringWithFormat:@"%td M", (NSInteger) self.playerInfo.move_distance];
    }
    self.calorieLabel.text = [NSString stringWithFormat:@"%.1f KCAL", self.playerInfo.pc];
    self.highestSpeedLabel.text = [NSString stringWithFormat:@"%.1f M/S", self.playerInfo.max_speed];
    
    self.dashDistanceLabel.text = [self transformDistance:self.playerInfo.sprintSpeed.distance unitLabel:self.unitDashLabel];
    self.dashTimeLabel.text = [self transformTime:self.playerInfo.sprintSpeed.time unitLabel:self.minDashLabel];
    self.midDistanceLabel.text = [self transformDistance:self.playerInfo.runSpeed.distance unitLabel:self.unitMiddleLabel];
    self.midTimeLabel.text = [self transformTime:self.playerInfo.runSpeed.time unitLabel:self.minMiddleLabel];
    self.lowDistanceLabel.text = [self transformDistance:self.playerInfo.walkSpeed.distance unitLabel:self.unitLowLabel];
    self.lowTimeLabel.text = [self transformTime:self.playerInfo.walkSpeed.time unitLabel:self.minLowLabel];
    
    self.firstPhysicalLabel.text = [NSString stringWithFormat:@"%.1f", self.playerInfo.first_pc];
    self.firstDashCountLabel.text = @(self.playerInfo.first_sprint_times).stringValue;
    self.firstDashDistanceLabel.text = @((NSInteger)self.playerInfo.first_sprint_distance).stringValue;
    self.firstHeightestSpeedLabel.text = [NSString stringWithFormat:@"%.1f", self.playerInfo.first_max_speed];
    self.firstMoveDistanceSpeedLabel.text = [NSString stringWithFormat:@"%.1f", self.playerInfo.first_move_distance/1000];
    
    self.secondPhysicalLabel.text = [NSString stringWithFormat:@"%.1f", self.playerInfo.second_pc];
    self.secondDashCountLabel.text = @(self.playerInfo.second_sprint_times).stringValue;
    self.secondDashDistanceLabel.text = @((NSInteger)self.playerInfo.second_sprint_distance).stringValue;
    self.secondHeightestSpeedLabel.text = [NSString stringWithFormat:@"%.1f", self.playerInfo.second_max_speed];
    self.secondMoveDistanceSpeedLabel.text = [NSString stringWithFormat:@"%.1f", self.playerInfo.second_move_distance/1000];
    
    //颜色设置
    [self adjustTextColor];

    /**
    [self.fullHeatMap sd_setImageWithURL:[NSURL URLWithString:_playerInfo.globalData.heatmapUrl]];
    [self.firstHeatMap sd_setImageWithURL:[NSURL URLWithString:_playerInfo.firstHalfData.heatmapUrl]];
    [self.secondHeatMap sd_setImageWithURL:[NSURL URLWithString:_playerInfo.secondHalfData.heatmapUrl]];
     */
}

- (void)adjustTextColor {
    
    self.firstPhysicalLabel.textColor = [self colorWithfirst:self.playerInfo.first_pc second:self.playerInfo.second_pc];
    self.firstDashCountLabel.textColor = [self colorWithfirst:self.playerInfo.first_sprint_times second:self.playerInfo.second_sprint_times];
    self.firstDashDistanceLabel.textColor = [self colorWithfirst:self.playerInfo.first_sprint_distance second:self.playerInfo.second_sprint_distance];
    self.firstHeightestSpeedLabel.textColor = [self colorWithfirst:self.playerInfo.first_max_speed second:self.playerInfo.second_max_speed];
    self.firstMoveDistanceSpeedLabel.textColor = [self colorWithfirst:self.playerInfo.first_move_distance second:self.playerInfo.second_move_distance];
    
    self.secondPhysicalLabel.textColor = [self colorWithfirst:self.playerInfo.second_pc second:self.playerInfo.first_pc];
    self.secondDashCountLabel.textColor = [self colorWithfirst:self.playerInfo.second_sprint_times second:self.playerInfo.first_sprint_times];
    self.secondDashDistanceLabel.textColor = [self colorWithfirst:self.playerInfo.second_sprint_distance second:self.playerInfo.first_sprint_distance];
    self.secondHeightestSpeedLabel.textColor = [self colorWithfirst:self.playerInfo.second_max_speed second:self.playerInfo.first_max_speed];
    self.secondMoveDistanceSpeedLabel.textColor = [self colorWithfirst:self.playerInfo.second_move_distance second:self.playerInfo.first_move_distance];
    
    
}

- (UIColor *)colorWithfirst:(CGFloat)first second:(CGFloat)second {
    
    first = [NSString stringWithFormat:@"%.1f", first].floatValue;
    second = [NSString stringWithFormat:@"%.1f", second].floatValue;
    if (first>second) {
        return [UIColor greenColor];
    }else {
        return [UIColor whiteColor];
    }
}

- (NSString *)transformDistance:(CGFloat)distance unitLabel:(UILabel *)unitLabel {
    
    if (distance>=1000) {
        if (unitLabel != nil) {
            unitLabel.text = @"KM";
        }
        
        return [NSString stringWithFormat:@"%.1f", distance/1000];
        
    }else {
        if (unitLabel != nil) {
            unitLabel.text = @"M";
        }
        
        return @((NSInteger)distance).stringValue;
    }
}

- (NSString *)transformTime:(CGFloat)time unitLabel:(UILabel *)unitLabel {
    
    if (time>=60) {
        unitLabel.text = @"MIN";
        return [NSString stringWithFormat:@"%.1f", time/60];
    }else {
        unitLabel.text = @"S";
        return @((NSInteger)time).stringValue;
    }
}

@end
