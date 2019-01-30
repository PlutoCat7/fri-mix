//
//  GBFullGameViewController.m
//  GB_Football
//
//  Created by Pizza on 16/8/23.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBFullGameViewController.h"
#import "GBPositionLabel.h"
#import "GBBoxButton.h"
#import "UIImageView+WebCache.h"
#import "GBPopAnimateTool.h"
#import "GBGameDetailUserInfoView.h"
#import "GBCoverAreaCarveView.h"
#import "GBCoverAreaFrameView.h"

#import "LogicManager.h"
#import "GBFullGameViewModel.h"

@interface GBFullGameViewController () <GBCoverAreaCarveViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet GBGameDetailUserInfoView *userInfoView;

// 移动距离
@property (weak, nonatomic) IBOutlet UILabel *moveDistanceLabel;
// 体能消耗
@property (weak, nonatomic) IBOutlet UILabel *calorieLabel;
// 最高速度
@property (weak, nonatomic) IBOutlet UILabel *highestSpeedLabel;

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

// 转变按钮
@property (weak, nonatomic) IBOutlet GBBoxButton *changDirectionButton;

// 移动距离单位KM/M
@property (weak, nonatomic) IBOutlet UILabel *unitMoveLabel;
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

@property (nonatomic, assign) BOOL changDirection;

@property (weak, nonatomic) IBOutlet UILabel *movingStLabel;
@property (weak, nonatomic) IBOutlet UILabel *calorieStLabel;
@property (weak, nonatomic) IBOutlet UILabel *fastestStLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceStLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedStLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationStLabel;

@property (weak, nonatomic) IBOutlet UILabel *sprintStLabel;
@property (weak, nonatomic) IBOutlet UILabel *midspeedStLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowspeedStLabel;

// UI - 业务完成后需移出viewController
// 新增forceTip提示
@property (weak, nonatomic) IBOutlet UIView *forceTipGroup;
@property (weak, nonatomic) IBOutlet UIButton    *forceTipButton;
@property (weak, nonatomic) IBOutlet UIImageView *forceTipIcon;
// 打开状态forece提示
@property (weak, nonatomic) IBOutlet UIView *forceOpenGroup;
@property (weak, nonatomic) IBOutlet UIView *forceOpenBack;
@property (weak, nonatomic) IBOutlet UILabel *forceOpenLabel;
@property (weak, nonatomic) IBOutlet UIImageView *forceOpenIcon;
// 是否展开标志
@property (nonatomic, assign) CGRect rectForceTipBox;
@property (nonatomic, assign) CGPoint iconCenter;
@property (nonatomic, assign) BOOL isForceTipShow;


//热力图
@property (weak, nonatomic) IBOutlet UIImageView *heatMapContainer;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *heatMapIndicator;
//冲刺轨迹
@property (weak, nonatomic) IBOutlet UIImageView *sprintContainer;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *sprintIndicator;
//覆盖面积
@property (weak, nonatomic) IBOutlet UIView *areaContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *areaContainer;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *areaIndicator;
@property (weak, nonatomic) IBOutlet UILabel *areaNumberLabel;
@property (weak, nonatomic) IBOutlet GBCoverAreaFrameView *coverAreaFrameView;
@property (weak, nonatomic) IBOutlet GBCoverAreaCarveView *coverAreaCarveView;

@property (weak, nonatomic) IBOutlet UIImageView *chooseTimeRateImageView;
//静态文本
@property (weak, nonatomic) IBOutlet UILabel *staticHeatMapLabel;
@property (weak, nonatomic) IBOutlet UILabel *staticSprintLabel;
@property (weak, nonatomic) IBOutlet UILabel *staticAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *staticShowRateTimeLabel;

@property (nonatomic, strong) GBFullGameViewModel *viewModel;
@property (nonatomic, assign) BOOL showTimeRate;

@end

@implementation GBFullGameViewController

#pragma mark -
#pragma mark Memory

-(void)localizeUI{
    
    self.movingStLabel.text  = LS(@"full.label.moving");
    self.calorieStLabel.text = LS(@"full.label.calorie");
    self.fastestStLabel.text = LS(@"full.label.fastest");
    self.distanceStLabel.text = LS(@"full.label.distance");
    self.speedStLabel.text    = LS(@"full.label.speed");
    self.durationStLabel.text = LS(@"full.label.duration");
    self.sprintStLabel.text   = LS(@"full.label.sprint");
    self.midspeedStLabel.text = LS(@"full.label.midspeed");
    self.lowspeedStLabel.text = LS(@"full.label.lowspeed");
    self.staticHeatMapLabel.text = LS(@"full.label.whole.heatmap");
    self.staticSprintLabel.text = LS(@"full.label.sprint.track");
    self.staticAreaLabel.text = LS(@"full.label.cover.area");
    self.staticShowRateTimeLabel.text = LS(@"match.record.label.time.rate");
}
#pragma mark - Life Cycle

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
       self.contentScrollView.contentSize = CGSizeMake(kUIScreen_Width, self.areaContainerView.bottom);
    });
}

#pragma mark - Public

- (void)refreshWithMatchInfo:(MatchInfo *)matchInfo {
    
    self.viewModel.matchInfo = matchInfo;
    
    self.moveDistanceLabel.text = [self transformDistance:matchInfo.globalData.moveDistance unitLabel:self.unitMoveLabel];
    self.calorieLabel.text = [NSString stringWithFormat:@"%.1f", matchInfo.globalData.consume];
    self.highestSpeedLabel.text = [NSString stringWithFormat:@"%.1f", matchInfo.globalData.maxSpeed];
    
    self.dashDistanceLabel.text = [self transformDistance:matchInfo.sprintSpeed.distance unitLabel:self.unitDashLabel];
    self.dashTimeLabel.text = [self transformTime:matchInfo.sprintSpeed.time unitLabel:self.minDashLabel];
    self.midDistanceLabel.text = [self transformDistance:matchInfo.runSpeed.distance unitLabel:self.unitMiddleLabel];
    self.midTimeLabel.text = [self transformTime:matchInfo.runSpeed.time unitLabel:self.minMiddleLabel];
    self.lowDistanceLabel.text = [self transformDistance:matchInfo.walkSpeed.distance unitLabel:self.unitLowLabel];
    self.lowTimeLabel.text = [self transformTime:matchInfo.walkSpeed.time unitLabel:self.minLowLabel];
    
    //更新球员基本信息
    self.userInfoView.matchUserInfo = matchInfo.matchUserInfo;
    
    // 全场都没有数据,判定为无数据点
    if (matchInfo.heatmap_data.point_count_status == 4) {
        [self showForceTipAtRightCornner:LS(@"force.popbar.tip")];
    }
    
    //载入图片
    [self loadImageData];
    
}

#pragma mark - Action
// 按下方向变化按钮
- (IBAction)actionChangeDirection:(id)sender {
    self.changDirection = !self.changDirection;
    CGFloat angle = self.changDirection?M_PI:0;
    CGAffineTransform at = CGAffineTransformMakeRotation(angle);
    [self.heatMapContainer setTransform:at];
    [self.sprintContainer setTransform:at];
    [self.areaContainer setTransform:at];
    //覆盖面积翻转
    [self.viewModel swipeCoverArea];
    [self.coverAreaFrameView refreshWithData:[self.viewModel.model currentRateInfo] times:[self.viewModel.model currentTimeInfo] type:self.viewModel.model.coverAreaStyle];
    
    [self UIEffectButton];
    BLOCK_EXEC(self.didChangeHeatMapDirection, self.changDirection);
}

- (IBAction)actionSwipeTimeRate:(id)sender {
    
    [UMShareManager event:Analy_Click_Record_Stay];
    
    self.showTimeRate = !self.showTimeRate;
}

-(void)UIEffectButton
{
    self.changDirectionButton.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:0.5 delay:0.1 usingSpringWithDamping:0.3 initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveLinear animations:^{
                            self.changDirectionButton.transform = CGAffineTransformIdentity;
                        } completion:nil];
}
#pragma mark - Private

- (void)loadData {
    
    self.viewModel = [[GBFullGameViewModel alloc] init];
}

- (void)setupUI {
    
    self.coverAreaCarveView.delegate = self;
}

- (void)initPageData {
    self.showTimeRate = YES;
}

- (void)loadImageData {
    
    [self.heatMapIndicator startAnimating];
    [self.sprintIndicator startAnimating];
    [self.areaIndicator startAnimating];
    @weakify(self)
    [self.heatMapContainer sd_setImageWithURL:[NSURL URLWithString:self.viewModel.model.heatmapImageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        @strongify(self)
        [self.heatMapIndicator stopAnimating];
        self.changDirectionButton.enabled = YES;
    }];
    [self.sprintContainer sd_setImageWithURL:[NSURL URLWithString:self.viewModel.model.sprintImageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        @strongify(self)
        [self.sprintIndicator stopAnimating];
    }];
    [self.areaContainer sd_setImageWithURL:[NSURL URLWithString:self.viewModel.model.coverAreaImageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        @strongify(self)
        [self.areaIndicator stopAnimating];
    }];
    
    self.areaNumberLabel.text = [NSString stringWithFormat:@"( %@ )", self.viewModel.model.sumRateString];
    [self.coverAreaFrameView refreshWithData:[self.viewModel.model currentRateInfo] times:[self.viewModel.model currentTimeInfo] type:self.viewModel.model.coverAreaStyle];
    [self.coverAreaCarveView selectWithIndex:self.viewModel.model.coverAreaStyle];
}

- (UIImage *)getViewShareImage {
    
    UIScrollView *scrollView =  self.contentScrollView;
    if (!scrollView) {
        return nil;
    }
    
    CGFloat oldheight = scrollView.height;
    CGPoint oldContentOffset = scrollView.contentOffset;
    
    scrollView.height = fmaxf(scrollView.contentSize.height, oldheight);
    scrollView.contentOffset = CGPointMake(0, 0);
    UIImage *shareImage = [LogicManager getImageWithHeadImage:nil subviews:@[scrollView] backgroundImage:[UIImage imageWithColor:[UIColor blackColor]]];
    
    scrollView.height = oldheight;
    scrollView.contentOffset = oldContentOffset;
    
    return shareImage;
}

- (NSString *)transformDistance:(CGFloat)distance unitLabel:(UILabel *)unitLabel {
    
    if (distance>=1000) {
        unitLabel.text = @"KM";
        return [NSString stringWithFormat:@"%.1f", distance/1000];
    }else {
        unitLabel.text = @"M";
        return [NSString stringWithFormat:@"%.1f", distance];
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

#pragma mark - Delegate

- (void)didSelectCoverAreaCarveViewWithIndex:(NSInteger)index {
    
    self.viewModel.model.coverAreaStyle = index;
    [self.coverAreaFrameView refreshWithData:[self.viewModel.model currentRateInfo] times:[self.viewModel.model currentTimeInfo] type:self.viewModel.model.coverAreaStyle];
}

#pragma mark - Getters & Setters
- (void)setShowTimeRate:(BOOL)showTimeRate {
    _showTimeRate = showTimeRate;
    
    if (self.showTimeRate) {
        self.chooseTimeRateImageView.hidden = NO;
    } else {
        self.chooseTimeRateImageView.hidden = YES;
    }
    [self.coverAreaFrameView setShowTimeRateInView:self.showTimeRate];
    
    BLOCK_EXEC(self.didShowMapTimeRate, self.showTimeRate);
    
}

#pragma mark - 强制出图逻辑

- (IBAction)actionTap:(id)sender {
    if (self.isForceTipShow == NO) {
        return;
    }
    self.forceTipIcon.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3
          initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
                            self.forceTipIcon.transform = CGAffineTransformIdentity;
                        } completion:nil];
    self.forceOpenIcon.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3
          initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
                            self.forceOpenIcon.transform = CGAffineTransformIdentity;
                        } completion:nil];
    
    self.forceOpenBack.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8
          initialSpringVelocity:2
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
                            self.forceOpenBack.transform = CGAffineTransformMakeScale(0.1, 0.1);
                            self.forceOpenBack.frame = CGRectMake(self.iconCenter.x, self.iconCenter.y, 1, 1);
                        } completion:^(BOOL finish){self.isForceTipShow = NO;}];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.forceTipGroup.alpha = 1.f;
        self.forceOpenGroup.alpha = 0.f;
    }];
    
}

- (IBAction)actionForceClose:(id)sender {
    [self showForceOpenGroup];
}

// 显示未展开的提示标志
-(void)showForceTipAtRightCornner:(NSString*)tips
{
    self.forceOpenLabel.text = tips;
    // 背景渐显
    [UIView animateWithDuration:0.5 animations:^{self.forceTipGroup.alpha = 1.f;}];
    // icon跳动
    self.forceTipIcon.transform = CGAffineTransformMakeScale(0.25, 0.25);
    [UIView animateWithDuration:0.5 delay:0.2 usingSpringWithDamping:0.3
          initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
                            self.forceTipIcon.transform = CGAffineTransformIdentity;
                        } completion:nil];
}

// 显示未展开的提示标志
-(void)showForceOpenGroup
{
    if (self.isForceTipShow == YES) {
        return;
    }
    if(CGRectIsEmpty(self.rectForceTipBox)) self.rectForceTipBox = self.forceOpenBack.frame;
    if (CGPointEqualToPoint(self.iconCenter, CGPointZero))self.iconCenter = self.forceOpenIcon.center;
    self.forceOpenBack.frame = CGRectMake(self.iconCenter.x, self.iconCenter.y, 1, 1);
    self.forceOpenBack.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.forceTipGroup.alpha = 0.f;
    self.forceOpenGroup.alpha = 1.f;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8
          initialSpringVelocity:2
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
                            self.forceOpenBack.transform = CGAffineTransformIdentity;
                            self.forceOpenBack.frame = self.rectForceTipBox;
                        } completion:nil];
    self.forceOpenIcon.transform = CGAffineTransformMakeScale(0.25, 0.25);
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3
          initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
                            self.forceOpenIcon.transform = CGAffineTransformIdentity;
                        } completion:^(BOOL finish){self.isForceTipShow = YES;}];
}

@end
