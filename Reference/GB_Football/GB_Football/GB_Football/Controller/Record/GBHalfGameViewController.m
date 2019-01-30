//
//  GBHalfGameViewController.m
//  GB_Football
//
//  Created by Pizza on 16/8/23.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBHalfGameViewController.h"
#import "GBPositionLabel.h"
#import "UIImageView+WebCache.h"
#import "GBGameBlockView.h"
#import "GBGameDetailUserInfoView.h"
#import "GBCoverAreaCarveView.h"
#import "GBVerticalCoverAreaFrameView.h"

#import "GBHalfGameViewModel.h"
#import "LogicManager.h"

@interface GBHalfGameViewController ()<GBCoverAreaCarveViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet GBGameDetailUserInfoView *userInfoView;

// LS(@"half.label.first")体能消耗
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

/*---------------------图形--------------------*/
//热力图
@property (weak, nonatomic) IBOutlet UIImageView *firstHeatMapContainer;
@property (weak, nonatomic) IBOutlet UIImageView *secondHeatMapContainer;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *firstHeatMapIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *secondHeatMapIndicator;
//冲刺轨迹
@property (weak, nonatomic) IBOutlet UIImageView *firstSprintContainer;
@property (weak, nonatomic) IBOutlet UIImageView *secondSprintContainer;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *firstSprintIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *secondSprintIndicator;

//覆盖面积
@property (weak, nonatomic) IBOutlet UIView *areaView;
@property (weak, nonatomic) IBOutlet UIImageView *firstAreaContainer;
@property (weak, nonatomic) IBOutlet UIImageView *secondAreaContainer;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *firstAreaIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *secondAreaIndicator;
@property (weak, nonatomic) IBOutlet UILabel *firstAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondAreaLabel;
@property (weak, nonatomic) IBOutlet GBCoverAreaCarveView *coverAreaCarveView;
@property (weak, nonatomic) IBOutlet GBVerticalCoverAreaFrameView *firstCoverAreaFrameView;
@property (weak, nonatomic) IBOutlet GBVerticalCoverAreaFrameView *secondCoverAreaFrameView;

// 静态国际化标签
@property (weak, nonatomic) IBOutlet UILabel *firstMatchStLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondMatchStLabel;
@property (weak, nonatomic) IBOutlet UILabel *carolieStLabel;
@property (weak, nonatomic) IBOutlet UILabel *sprintTimetLabel;
@property (weak, nonatomic) IBOutlet UILabel *sprintDistStLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedStLabel;
@property (weak, nonatomic) IBOutlet UILabel *movingStLabel;

@property (weak, nonatomic) IBOutlet UILabel *staticHeatMap_FirstLabel1;
@property (weak, nonatomic) IBOutlet UILabel *staticHeatMap_FirstLabel2;
@property (weak, nonatomic) IBOutlet UILabel *staticHeatMap_SecondLabel1;
@property (weak, nonatomic) IBOutlet UILabel *staticHeatMap_SecondLabel2;
@property (weak, nonatomic) IBOutlet UILabel *staticSprint_FirstLabel1;
@property (weak, nonatomic) IBOutlet UILabel *staticSprint_FirstLabel2;
@property (weak, nonatomic) IBOutlet UILabel *staticSprint_SecondLabel1;
@property (weak, nonatomic) IBOutlet UILabel *staticSprint_SecondLabel2;
@property (weak, nonatomic) IBOutlet UILabel *staticArea_FirstLabel1;
@property (weak, nonatomic) IBOutlet UILabel *staticArea_FirstLabel2;
@property (weak, nonatomic) IBOutlet UILabel *staticArea_SecondLabel1;
@property (weak, nonatomic) IBOutlet UILabel *staticArea_SecondLabel2;

@property (nonatomic, strong) GBHalfGameViewModel *viewModel;

@end

@implementation GBHalfGameViewController

#pragma mark -
#pragma mark Memory

-(void)localizeUI{
    self.carolieStLabel.text = LS(@"half.label.calorie");
    self.sprintTimetLabel.text = LS(@"half.label.sprint.time");
    self.sprintDistStLabel.text = LS(@"half.label.sprint.distance");
    self.speedStLabel.text = LS(@"half.label.fastest");
    self.movingStLabel.text = LS(@"half.label.moving");
    
    //图形
    self.staticHeatMap_FirstLabel1.text = LS(@"half.label.first");
    self.staticHeatMap_SecondLabel1.text = LS(@"half.label.second");
    self.staticHeatMap_FirstLabel2.text = LS(@"gamedata.heatmap");
    self.staticHeatMap_SecondLabel2.text = self.staticHeatMap_FirstLabel2.text;
    
    self.staticSprint_FirstLabel1.text = self.staticHeatMap_FirstLabel1.text;
    self.staticSprint_SecondLabel1.text = self.staticHeatMap_SecondLabel1.text;
    UIFont *italicFont = [UIFont autoItalicAndBoldFontOfSize:12.0f];
    self.staticSprint_FirstLabel2.font = italicFont;
    self.staticSprint_FirstLabel2.text = LS(@"half.label.sprint.track");
    self.staticSprint_SecondLabel2.font = italicFont;
    self.staticSprint_SecondLabel2.text = LS(@"half.label.sprint.track");
    
    self.staticArea_FirstLabel1.text = self.staticHeatMap_FirstLabel1.text;
    self.staticArea_SecondLabel1.text = self.staticHeatMap_SecondLabel1.text;
    self.staticArea_FirstLabel2.font = italicFont;
    self.staticArea_FirstLabel2.text = LS(@"half.label.cover.area");
    self.staticArea_SecondLabel2.font = italicFont;
    self.staticArea_SecondLabel2.text = LS(@"half.label.cover.area");
}
#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)initLoadData {
    
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.contentScrollView.contentSize = CGSizeMake(kUIScreen_Width, self.areaView.bottom);
    });
}

#pragma mark - Public

- (void)refreshWithMatchInfo:(MatchInfo *)matchInfo {
    
    self.viewModel.matchInfo = matchInfo;
    
    NSInteger firstTime = [[NSDate dateWithTimeIntervalSince1970:matchInfo.firstEndTime] minutesAfterDate:[NSDate dateWithTimeIntervalSince1970:matchInfo.firstStartTime]];
    NSString *firstContent = [NSString stringWithFormat:@"%@(%@MIN)", LS(@"half.label.first"), @(firstTime).stringValue];
    NSMutableAttributedString *fisrtContentAttri = [[NSMutableAttributedString alloc] initWithString:firstContent];
    [fisrtContentAttri addAttribute:NSFontAttributeName
                         value:[UIFont fontWithName:@"BEBAS" size:11.0f*kAppScale]
                              range:[firstContent rangeOfString:[NSString stringWithFormat:@"%@MIN", @(firstTime).stringValue]]];
    self.firstMatchStLabel.attributedText = [fisrtContentAttri copy];
    
    NSInteger secondTime = [[NSDate dateWithTimeIntervalSince1970:matchInfo.secondEndTime] minutesAfterDate:[NSDate dateWithTimeIntervalSince1970:matchInfo.secondStartTime]];
    NSString *secondContent = [NSString stringWithFormat:@"%@(%@MIN)", LS(@"half.label.second"), @(secondTime).stringValue];
    NSMutableAttributedString *secondContentAttri = [[NSMutableAttributedString alloc] initWithString:secondContent];
    [secondContentAttri addAttribute:NSFontAttributeName
                              value:[UIFont fontWithName:@"BEBAS" size:11.0f*kAppScale]
                              range:[secondContent rangeOfString:[NSString stringWithFormat:@"%@MIN", @(secondTime).stringValue]]];
    self.secondMatchStLabel.attributedText = [secondContentAttri copy];

    self.firstPhysicalLabel.text = [NSString stringWithFormat:@"%.1f", matchInfo.firstHalfData.consume];
    self.firstDashCountLabel.text = @(matchInfo.firstHalfData.sprintTime).stringValue;
    self.firstDashDistanceLabel.text = [NSString stringWithFormat:@"%.1f", matchInfo.firstHalfData.sprintDistance];
    self.firstHeightestSpeedLabel.text = [NSString stringWithFormat:@"%.1f", matchInfo.firstHalfData.maxSpeed];
    self.firstMoveDistanceSpeedLabel.text = [NSString stringWithFormat:@"%.1f", matchInfo.firstHalfData.moveDistance/1000];
    
    self.secondPhysicalLabel.text = [NSString stringWithFormat:@"%.1f", matchInfo.secondHalfData.consume];
    self.secondDashCountLabel.text = @(matchInfo.secondHalfData.sprintTime).stringValue;
    self.secondDashDistanceLabel.text = [NSString stringWithFormat:@"%.1f", matchInfo.secondHalfData.sprintDistance];
    self.secondHeightestSpeedLabel.text = [NSString stringWithFormat:@"%.1f", matchInfo.secondHalfData.maxSpeed];
    self.secondMoveDistanceSpeedLabel.text = [NSString stringWithFormat:@"%.1f", matchInfo.secondHalfData.moveDistance/1000];
    //颜色设置
    [self adjustTextColor:matchInfo];
    
    //更新球员基本信息
    self.userInfoView.matchUserInfo = matchInfo.matchUserInfo;
    
    //更新图片信息
    [self loadImageData];
}

#pragma mark - Private

- (void)loadData {
    
    self.viewModel = [[GBHalfGameViewModel alloc] init];
}

- (void)setupUI {
    
    self.coverAreaCarveView.delegate = self;
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

- (void)loadImageData {
    
    [self.firstHeatMapIndicator startAnimating];
    [self.secondHeatMapIndicator startAnimating];
    [self.firstSprintIndicator startAnimating];
    [self.secondSprintIndicator startAnimating];
    [self.firstAreaIndicator startAnimating];
    [self.secondAreaIndicator startAnimating];
    //热力图
    @weakify(self)
    [self.firstHeatMapContainer sd_setImageWithURL:[NSURL URLWithString:self.viewModel.firstModel.heatmapImageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        @strongify(self)
        [self.firstHeatMapIndicator stopAnimating];
    }];
    
    [self.secondHeatMapContainer sd_setImageWithURL:[NSURL URLWithString:self.viewModel.secondModel.heatmapImageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        @strongify(self)
        [self.secondHeatMapIndicator stopAnimating];
    }];
    //冲刺
    [self.firstSprintContainer sd_setImageWithURL:[NSURL URLWithString:self.viewModel.firstModel.sprintImageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        @strongify(self)
        [self.firstSprintIndicator stopAnimating];
    }];
    
    [self.secondSprintContainer sd_setImageWithURL:[NSURL URLWithString:self.viewModel.secondModel.sprintImageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        @strongify(self)
        [self.secondSprintIndicator stopAnimating];
    }];
    //覆盖面积
    [self.firstAreaContainer sd_setImageWithURL:[NSURL URLWithString:self.viewModel.firstModel.coverAreaImageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        @strongify(self)
        [self.firstAreaIndicator stopAnimating];
    }];
    
    [self.secondAreaContainer sd_setImageWithURL:[NSURL URLWithString:self.viewModel.secondModel.coverAreaImageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        @strongify(self)
        [self.secondAreaIndicator stopAnimating];
    }];
    
    self.firstAreaLabel.text = self.viewModel.firstModel.sumRateString;
    self.secondAreaLabel.text = self.viewModel.secondModel.sumRateString;
    [self.firstCoverAreaFrameView refreshWithData:[self.viewModel.firstModel currentRateInfo] times:[self.viewModel.firstModel currentTimeInfo] type:self.viewModel.firstModel.coverAreaStyle];
    [self.secondCoverAreaFrameView refreshWithData:[self.viewModel.secondModel currentRateInfo] times:[self.viewModel.firstModel currentTimeInfo] type:self.viewModel.secondModel.coverAreaStyle];
    [self.coverAreaCarveView selectWithIndex:self.viewModel.firstModel.coverAreaStyle];
}

- (void)adjustTextColor:(MatchInfo *)matchInfo {

    self.firstPhysicalLabel.textColor = [self colorWithfirst:matchInfo.firstHalfData.consume second:matchInfo.secondHalfData.consume];
    self.firstDashCountLabel.textColor = [self colorWithfirst:matchInfo.firstHalfData.sprintTime second:matchInfo.secondHalfData.sprintTime];
    self.firstDashDistanceLabel.textColor = [self colorWithfirst:matchInfo.firstHalfData.sprintDistance second:matchInfo.secondHalfData.sprintDistance];
    self.firstHeightestSpeedLabel.textColor = [self colorWithfirst:matchInfo.firstHalfData.maxSpeed second:matchInfo.secondHalfData.maxSpeed];
    self.firstMoveDistanceSpeedLabel.textColor = [self colorWithfirst:matchInfo.firstHalfData.moveDistance second:matchInfo.secondHalfData.moveDistance];
    
    self.secondPhysicalLabel.textColor = [self colorWithfirst:matchInfo.secondHalfData.consume second:matchInfo.firstHalfData.consume];
    self.secondDashCountLabel.textColor = [self colorWithfirst:matchInfo.secondHalfData.sprintTime second:matchInfo.firstHalfData.sprintTime];
    self.secondDashDistanceLabel.textColor = [self colorWithfirst:matchInfo.secondHalfData.sprintDistance second:matchInfo.firstHalfData.sprintDistance];
    self.secondHeightestSpeedLabel.textColor = [self colorWithfirst:matchInfo.secondHalfData.maxSpeed second:matchInfo.firstHalfData.maxSpeed];
    self.secondMoveDistanceSpeedLabel.textColor = [self colorWithfirst:matchInfo.secondHalfData.moveDistance second:matchInfo.firstHalfData.moveDistance];
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

#pragma mark - Delegate

- (void)didSelectCoverAreaCarveViewWithIndex:(NSInteger)index {
    
    self.viewModel.firstModel.coverAreaStyle = index;
    [self.firstCoverAreaFrameView refreshWithData:[self.viewModel.firstModel currentRateInfo] times:[self.viewModel.firstModel currentTimeInfo] type:self.viewModel.firstModel.coverAreaStyle];
    
    self.viewModel.secondModel.coverAreaStyle = index;
    [self.secondCoverAreaFrameView refreshWithData:[self.viewModel.secondModel currentRateInfo] times:[self.viewModel.secondModel currentTimeInfo] type:self.viewModel.secondModel.coverAreaStyle];
}

#pragma mark - Getters & Setters

- (void)setDirection:(BOOL)direction {
    
    _direction = direction;
    CGFloat angle = direction?M_PI:0;
    CGAffineTransform at = CGAffineTransformMakeRotation(angle);
    
    [self.firstHeatMapContainer setTransform:at];
    [self.secondHeatMapContainer setTransform:at];
    [self.firstSprintContainer setTransform:at];
    [self.secondSprintContainer setTransform:at];
    [self.firstAreaContainer setTransform:at];
    [self.secondAreaContainer setTransform:at];
    
    //覆盖面积翻转
    [self.viewModel swipeCoverArea];
    [self.firstCoverAreaFrameView refreshWithData:[self.viewModel.firstModel currentRateInfo] times:[self.viewModel.firstModel currentTimeInfo] type:self.viewModel.firstModel.coverAreaStyle];
    [self.secondCoverAreaFrameView refreshWithData:[self.viewModel.secondModel currentRateInfo] times:[self.viewModel.secondModel currentTimeInfo] type:self.viewModel.secondModel.coverAreaStyle];
}

- (void)setShowTimeRate:(BOOL)showTimeRate {
    _showTimeRate = showTimeRate;
    
    [self.firstCoverAreaFrameView setShowTimeRateInView:showTimeRate];
    [self.secondCoverAreaFrameView setShowTimeRateInView:showTimeRate];
}

@end
