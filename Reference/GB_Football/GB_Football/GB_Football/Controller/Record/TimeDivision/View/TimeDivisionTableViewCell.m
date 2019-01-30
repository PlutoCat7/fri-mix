//
//  TimeDivisionTableViewCell.m
//  GB_Football
//
//  Created by 王时温 on 2017/5/9.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "TimeDivisionTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "GBCoverAreaCarveView.h"
#import "GBCoverAreaFrameView.h"

@interface TimeDivisionTableViewCell () <
GBCoverAreaCarveViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *heatmapButton;
@property (weak, nonatomic) IBOutlet UIButton *sprintButton;
@property (weak, nonatomic) IBOutlet UIButton *areaButton;
@property (weak, nonatomic) IBOutlet UILabel *heatMapLabel;
@property (weak, nonatomic) IBOutlet UILabel *sprintLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UIButton *swipeButton;
@property (weak, nonatomic) IBOutlet UIImageView *heatmapImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sprintImageView;
@property (weak, nonatomic) IBOutlet UIImageView *coverAreaImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *divisionContainerView;
@property (weak, nonatomic) IBOutlet GBCoverAreaCarveView *coverAreaCarveView;
@property (weak, nonatomic) IBOutlet GBCoverAreaFrameView *coverAreaFrameView;

@property (nonatomic, strong) TimeDivisionCellModel *model;


@end

@implementation TimeDivisionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.coverAreaCarveView.delegate = self;
    [self localizeUI];
}

- (void)localizeUI {
    
    UIFont *italicFont  = [UIFont autoItalicAndBoldFontOfSize:13.0f];
    self.heatMapLabel.font = italicFont;
    self.sprintLabel.font = italicFont;
    self.areaLabel.font = italicFont;
    
    self.heatMapLabel.text = LS(@"half.label.whole.heatmap");
    self.sprintLabel.text = LS(@"half.label.sprint.track");
    self.areaLabel.text = LS(@"half.label.cover.area");
}

#pragma mark - Public

- (void)refreshWithModel:(TimeDivisionCellModel *)model {
    
    self.model = model;
    
    NSString *imageUrl = nil;
    if (model.currentStyle == 0) {
        imageUrl = model.heatmapImageUrl;
        [self actionHeatMap:nil];
    }else if (model.currentStyle == 1) {
        imageUrl = model.sprintImageUrl;
        [self actionSprint:nil];
    }else if (model.currentStyle == 2) {
        imageUrl = model.coverAreaImageUrl;
        [self actionArea:nil];
    }
    [self.indicator startAnimating];
    @weakify(self)
    [self.heatmapImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        @strongify(self)
        [self.indicator stopAnimating];
    }];
    
    //是否隐藏交换按钮
    self.swipeButton.hidden = !(model.currentStyle==0);
    if (model.currentStyle == 2) {//是否显示分区view
        self.contentHeightConstraint.constant = 235.f*kAppScale;
        self.divisionContainerView.hidden = NO;
        self.coverAreaFrameView.hidden = NO;
        
        [self.coverAreaCarveView selectWithIndex:model.coverAreaStyle];
        [self.coverAreaFrameView refreshWithData:[self.model currentRateInfo] times:[self.model currentTimeInfo] type:model.coverAreaStyle];
        
    }else {
        self.contentHeightConstraint.constant = 235.f*kAppScale;
        self.divisionContainerView.hidden = YES;
        self.coverAreaFrameView.hidden = YES;
    }
    
    //是否需要旋转
    [self refreshImageViewRotate];
}

#pragma mark - Action

- (IBAction)actionChangeDirection:(id)sender {
    
    [self.model swipeRateList];
    
    [self refreshImageViewRotate];
}

- (IBAction)actionHeatMap:(id)sender {
    
    [UMShareManager event:Analy_Click_Record_Heat];
    
    self.heatmapButton.selected = YES;
    self.heatMapLabel.textColor = [UIColor whiteColor];
    
    self.sprintButton.selected = NO;
    self.sprintLabel.textColor = [UIColor colorWithHex:0x909090];
    
    self.areaButton.selected = NO;
    self.areaLabel.textColor = [UIColor colorWithHex:0x909090];
    
    if ([self.delegate respondsToSelector:@selector(didSelectWithIndex:cell:)] && sender) {
        [self.delegate didSelectWithIndex:0 cell:self];
    }
}

- (IBAction)actionSprint:(id)sender {
    
    [UMShareManager event:Analy_Click_Record_Sprint];
    
    self.heatmapButton.selected = NO;
    self.heatMapLabel.textColor = [UIColor colorWithHex:0x909090];
    
    self.sprintButton.selected = YES;
    self.sprintLabel.textColor = [UIColor whiteColor];
    
    self.areaButton.selected = NO;
    self.areaLabel.textColor = [UIColor colorWithHex:0x909090];
    
    if ([self.delegate respondsToSelector:@selector(didSelectWithIndex:cell:)] && sender) {
        [self.delegate didSelectWithIndex:1 cell:self];
    }
}

- (IBAction)actionArea:(id)sender {
    
    [UMShareManager event:Analy_Click_Record_cover];
    
    self.heatmapButton.selected = NO;
    self.heatMapLabel.textColor = [UIColor colorWithHex:0x909090];
    
    self.sprintButton.selected = NO;
    self.sprintLabel.textColor = [UIColor colorWithHex:0x909090];
    
    self.areaButton.selected = YES;
    self.areaLabel.textColor = [UIColor whiteColor];
    
    
    if ([self.delegate respondsToSelector:@selector(didSelectWithIndex:cell:)] && sender) {
        [self.delegate didSelectWithIndex:2 cell:self];
    }
}

#pragma mark - Getters & Setters
- (void)setShowTimeRate:(BOOL)showTimeRate {
    _showTimeRate = showTimeRate;
    
    [self.coverAreaFrameView setShowTimeRateInView:showTimeRate];
}

#pragma mark - Private

- (void)refreshImageViewRotate {
    
    CGFloat angle = self.model.isSwipe?M_PI:0;
    CGAffineTransform at = CGAffineTransformMakeRotation(angle);
    [self.heatmapImageView setTransform:at];
}

#pragma mark - Delegate

- (void)didSelectCoverAreaCarveViewWithIndex:(NSInteger)index {
    
    if (self.model.coverAreaStyle == index) {
        return;
    }
    self.model.coverAreaStyle = index;
    //刷新覆盖面积view
    [self.coverAreaFrameView refreshWithData:[self.model currentRateInfo] times:[self.model currentTimeInfo] type:self.model.coverAreaStyle];
}

@end
