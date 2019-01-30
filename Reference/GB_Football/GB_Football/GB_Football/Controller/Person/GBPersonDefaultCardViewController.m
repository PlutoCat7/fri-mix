//
//  GBPersonDefaultCardViewController.m
//  GB_Football
//
//  Created by Pizza on 16/8/8.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBPersonDefaultCardViewController.h"
#import "GBPlayerDataRankViewController.h"
#import "GBMenuViewController.h"
#import "GBPositionLabel.h"
#import "UIImageView+WebCache.h"
#import "GBRadarChartView.h"
#import "THLabel.h"

#import "UserRequest.h"
#import "UMShareManager.h"
#import "FriendRequest.h"
#import "GBChartsLogic.h"

@interface GBPersonDefaultCardViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

// 球员姓名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
// 地区
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
// 团队名称
@property (weak, nonatomic) IBOutlet THLabel *teamNameLabel;
@property (weak, nonatomic) IBOutlet THLabel *scoreLabel;
// 头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
// 选择场上位置图标
@property (weak, nonatomic) IBOutlet GBPositionLabel *posIcon1;
// 球衣号码
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
// 比赛场次
@property (weak, nonatomic) IBOutlet UILabel *stageLabel;
// 身高
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
// 体重
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
// 年龄
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *radarDataLabels;

// 平均移动距离
@property (weak, nonatomic) IBOutlet UILabel *aveMoveLabel;
// 平均最高速度
@property (weak, nonatomic) IBOutlet UILabel *aveSpeedLabel;
// 平均体能消耗
@property (weak, nonatomic) IBOutlet UILabel *avePhysicalLabel;
// 历史移动距离
@property (weak, nonatomic) IBOutlet UILabel *hisMoveLabel;
// 历史速度
@property (weak, nonatomic) IBOutlet UILabel *hisSpeedLabel;
// 历史体格
@property (weak, nonatomic) IBOutlet UILabel *hisPhysicalLabel;

// 静态标签
@property (weak, nonatomic) IBOutlet UILabel *myTeanStLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreStLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberStLabel;
@property (weak, nonatomic) IBOutlet UILabel *roundStLabel;
@property (weak, nonatomic) IBOutlet UILabel *posStLabel;
@property (weak, nonatomic) IBOutlet UILabel *regionStLabel;
@property (weak, nonatomic) IBOutlet UILabel *heightStLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightStLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageStLabel;
@property (weak, nonatomic) IBOutlet UILabel *aveMoveStLabel;
@property (weak, nonatomic) IBOutlet UILabel *aveSpeedStLabel;
@property (weak, nonatomic) IBOutlet UILabel *avePhysicalStLabel;
@property (weak, nonatomic) IBOutlet UILabel *hisMoveStLabel;
@property (weak, nonatomic) IBOutlet UILabel *hisSpeedStLabel;
@property (weak, nonatomic) IBOutlet UILabel *hisPhysicalStLabel;
@property (weak, nonatomic) IBOutlet UILabel *radarAreaStLabel;
@property (weak, nonatomic) IBOutlet UILabel *radarDistanceStLabel;
@property (weak, nonatomic) IBOutlet UILabel *radarSprintStLabel;
@property (weak, nonatomic) IBOutlet UILabel *radarEruptStLabel;
@property (weak, nonatomic) IBOutlet UILabel *radarEndurStLabel;
@property (weak, nonatomic) IBOutlet UILabel *radarSpeedStLabel;

@property (weak, nonatomic) IBOutlet GBRadarChartView *radarChartView;
@property (weak, nonatomic) IBOutlet UIView *dataContainerView;
@property (weak, nonatomic) IBOutlet UIButton *reviewRankButton;
@property (weak, nonatomic) IBOutlet UIImageView *arrowOneImageView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowTowImageView;
    
@end

@implementation GBPersonDefaultCardViewController

#pragma mark -
#pragma mark Memory

#pragma mark - Life Cycle

- (void)dealloc {
    [self.arrowOneImageView.layer removeAllAnimations];
    [self.arrowTowImageView.layer removeAllAnimations];
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if ([self.navigationController.topViewController isMemberOfClass:[GBMenuViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.headImageView.clipsToBounds = YES;
        [self.headImageView.layer setCornerRadius:self.headImageView.width/2];
        [self.headImageView.layer setMasksToBounds:YES];
        
        self.contentScrollView.contentSize = CGSizeMake(kUIScreen_Width, self.dataContainerView.bottom);
    });
}

#pragma mark - Analytics

- (NSString *)pageName {
    return Analy_Page_Card;
}

- (void)shareSuccess {
    [UMShareManager event:Analy_Click_Share_Card];
}

#pragma mark - Notification

#pragma mark - Delegate
- (BOOL)showShareItem {
    return self.userId != 0 && self.userId == [RawCacheManager sharedRawCacheManager].userInfo.userId;
}

- (UIImage *)shareImage {
    
    UIScrollView *scrollView =  self.contentScrollView;
    scrollView.autoresizesSubviews = NO;
    CGFloat oldheight = scrollView.height;
    CGPoint oldContentOffset = scrollView.contentOffset;
    
    scrollView.height = scrollView.contentSize.height>oldheight?scrollView.contentSize.height:oldheight;
    scrollView.contentOffset = CGPointMake(0, 0);
    UIImage *shareImage = [LogicManager getImageWithHeadImage:nil subviews:@[scrollView] backgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0x0d0d0d]]];
    
    scrollView.height = oldheight;
    scrollView.contentOffset = oldContentOffset;
    scrollView.autoresizesSubviews = YES;
    
    return shareImage;
}

#pragma mark - Action

- (void)rightItemAction {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ShowMainView object:nil];
}

- (void)actionAddFriend {
    [self showLoadingToast];
    @weakify(self)
    [FriendRequest addFriend:self.userId handler:^(id result, NSError *error) {
        @strongify(self)
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            [self showToastWithText:LS(@"frient.hint.invitation")];
        }
    }];
}

- (IBAction)actionLookRank:(id)sender {
    [UMShareManager event:Analy_Click_Card_Index];
    
    GBPlayerDataRankViewController *vc = [[GBPlayerDataRankViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
    
#pragma mark - Private

-(void)setupUI
{
    [super setupUI];
    
    self.title = LS(@"starcard.nav.title");
    [self setUpGradientLabel:self.teamNameLabel];
    [self.teamNameLabel setTextInsets:UIEdgeInsetsMake(0, 10*kAppScale, 0, 0)];
    [self setUpGradientLabel:self.scoreLabel];

    if (self.userId == [RawCacheManager sharedRawCacheManager].userInfo.userId) {
        PlayerStarInfo *starInfo = [PlayerStarInfo playerStarInfoWithUserInfo:[RawCacheManager sharedRawCacheManager].userInfo];
        [self refreshUI:starInfo];
        
    }
    
    [self showLoadingToast];
    @weakify(self)
    [UserRequest getPlayerStarInfo:self.userId handler:^(id result, NSError *error) {
        @strongify(self)
        [self dismissToast];
        if (error) {
            if (error.code == RESULT_Not_Friend) {
                [self showToastWithText:LS(@"frient.not.friend")];
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Friend_Not_Friend object:nil];
                @weakify(self)
                [self performBlock:^{
                    
                    @strongify(self)
                    [self.navigationController yh_popViewController:self animated:YES];
                } delay:2.0f];
            }else {
                [self showToastWithText:error.domain];
            }
        }else {
            [self refreshUI:result];
            [self setUpRankView];
        }
    }];
    
}
    
- (void)setUpRankView {
    if (self.userId == [RawCacheManager sharedRawCacheManager].userInfo.userId) {
        self.reviewRankButton.hidden = NO;
        self.arrowOneImageView.hidden = NO;
        self.arrowTowImageView.hidden = NO;
        
        [self animateWithArrow:self.arrowOneImageView delay:0];
        [self animateWithArrow:self.arrowTowImageView delay:1];
        
    }
}
    
- (void)animateWithArrow:(UIView *)view delay:(NSTimeInterval)delay{
    CABasicAnimation *positionAnima = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnima.duration = 2;
    positionAnima.fromValue = [NSValue valueWithCGPoint:view.layer.position];
    positionAnima.toValue = [NSValue valueWithCGPoint:CGPointMake(view.layer.position.x + 20, view.layer.position.y)];
    positionAnima.removedOnCompletion = NO;
    positionAnima.repeatCount = HUGE_VALF;
    positionAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CABasicAnimation *opacityAnima = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnima.duration = 2;
    opacityAnima.fromValue = @(0.0);
    opacityAnima.toValue = @(1.0);
    opacityAnima.repeatCount = HUGE_VALF;
    opacityAnima.removedOnCompletion = NO;
    
    CAAnimationGroup *animaGroup = [CAAnimationGroup animation];
    animaGroup.duration = 2;
    animaGroup.beginTime = CACurrentMediaTime() + delay;
    animaGroup.fillMode = kCAFillModeForwards;
    animaGroup.removedOnCompletion = NO;
    animaGroup.repeatCount = HUGE_VALF;
    animaGroup.animations = @[positionAnima,opacityAnima];

    [view.layer addAnimation:animaGroup forKey:@"Animation"];

}

- (void)setUpGradientLabel:(THLabel *)label {
    
    label.gradientStartColor = [UIColor colorWithHex:0xfff9ed];
    label.gradientEndColor = [UIColor colorWithHex:0xffd990];
    label.textAlignment = NSTextAlignmentCenter;
}

- (void)localizeUI{
    
    UIFont *italicFont = [UIFont autoItalicAndBoldFontOfSize:11.0f];
    self.myTeanStLabel.font = italicFont;
    self.scoreStLabel.font = italicFont;
    self.myTeanStLabel.text = LS(@"team.home.my.team");
    self.scoreStLabel.text = LS(@"starcard.label.index");
    
    self.numberStLabel.text = LS(@"starcard.label.number");
    self.roundStLabel.text = LS(@"starcard.label.round");
    self.posStLabel.text = LS(@"full.label.positon");
    self.regionStLabel.text = LS(@"starcard.label.region");
    self.heightStLabel.text = LS(@"starcard.label.height");
    self.weightStLabel.text = LS(@"starcard.label.weight");
    self.ageStLabel.text = LS(@"starcard.label.age");
    
    self.aveMoveStLabel.text = LS(@"starcard.label.average.distance");
    self.aveSpeedStLabel.text = LS(@"starcard.label.average.maxspeed");
    self.avePhysicalStLabel.text = LS(@"starcard.label.average.physical");
    self.hisMoveStLabel.text = LS(@"starcard.label.best.distance");
    self.hisSpeedStLabel.text = LS(@"starcard.label.best.speed");
    self.hisPhysicalStLabel.text = LS(@"starcard.label.best.physical");
    
    self.radarAreaStLabel.text = LS(@"starcard.label.area");
    self.radarDistanceStLabel.text = LS(@"starcard.label.distance");
    self.radarSprintStLabel.text = LS(@"starcard.label.sprint");
    self.radarEruptStLabel.text = LS(@"starcard.label.erupt");
    self.radarEndurStLabel.text = LS(@"starcard.label.endur");
    self.radarSpeedStLabel.text = LS(@"starcard.label.speed");
}

- (void)refreshUI:(PlayerStarInfo *)starInfo {
    
    if (self.userId != 0 && self.userId != [RawCacheManager sharedRawCacheManager].userInfo.userId && !starInfo.isFriend) {
        [self setupRightNavButton];
    }
    
    NSString *teamName = starInfo.user_data.teamName.length == 0 ? LS(@"team.info.name.empty") : starInfo.user_data.teamName;
    self.teamNameLabel.text = teamName;
    self.scoreLabel.text = @(starInfo.extend_data.score).stringValue;
    self.nameLabel.text = starInfo.user_data.nick;
    self.cityLabel.text = [NSString stringWithFormat:@"%@",
                           [LogicManager areaStringWithProvinceId:starInfo.user_data.provinceId cityId:starInfo.user_data.cityId regionId:starInfo.user_data.regionId]];
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:starInfo.user_data.imageUrl] placeholderImage:[UIImage imageNamed:@"portrait"]];
    NSArray *positionList = [starInfo.user_data.position componentsSeparatedByString:@","];
    self.posIcon1.index = [positionList.firstObject integerValue];
    self.numberLabel.text = @(starInfo.user_data.teamNo).stringValue;
    self.stageLabel.text = @(starInfo.extend_data.matchCount).stringValue;
    
    [self setPersonLabel:self.heightLabel number:starInfo.user_data.height unit:@"CM"];
    [self setPersonLabel:self.weightLabel number:starInfo.user_data.weight unit:@"KG"];
    [self setPersonLabel:self.ageLabel number:[NSDate date].year-[NSDate dateWithTimeIntervalSince1970:starInfo.user_data.birthday].year unit:@"AGE"];
    
    [self setDataLabel:self.aveMoveLabel number:starInfo.extend_data.avgMove/1000 unit:@"KM"];
    [self setDataLabel:self.aveSpeedLabel number:starInfo.extend_data.avgHighSpeed unit:@"M/S"];
    [self setDataLabel:self.avePhysicalLabel number:starInfo.extend_data.avgPC unit:@"KCAL"];
    [self setDataLabel:self.hisMoveLabel number:starInfo.extend_data.singleMaxMove/1000 unit:@"KM"];
    [self setDataLabel:self.hisSpeedLabel number:starInfo.extend_data.singleMaxHighSpeed unit:@"M/S"];
    [self setDataLabel:self.hisPhysicalLabel number:starInfo.extend_data.singleMaxPC unit:@"KCAL"];
    
    //蜘蛛图赋值
    NSArray<NSNumber *> *radarDatas = [GBChartsLogic dataWithPlayerStarInfo:starInfo.extend_data];
    [self.radarChartView setDatas:radarDatas];
    if (radarDatas.count == self.radarDataLabels.count) {
        for (NSInteger i=0; i<radarDatas.count; i++) {
            NSNumber *numer = radarDatas[i];
            UILabel *label = self.radarDataLabels[i];
            label.text = [NSString stringWithFormat:@"%.1f", numer.floatValue];
        }
    }
}

- (void)setupRightNavButton {
    
    NSString *title = LS(@"inivte-add-friend.title");
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToHeight:24];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setSize:size];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[ColorManager styleColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(actionAddFriend) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:rightButton];
    
}

- (void)setPersonLabel:(UILabel *)label number:(NSInteger)number unit:(NSString *)unit {
    
    NSString *text = [NSString stringWithFormat:@"%td %@", number, unit];
    NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithString:text];
    NSRange range = [text rangeOfString:unit];
    [mString addAttribute:NSForegroundColorAttributeName
                    value:[UIColor colorWithHex:0x909090]
                    range:range];
    [mString addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:12.0f*kAppScale]
                    range:range];
    label.attributedText = [mString copy];
}

- (void)setDataLabel:(UILabel *)label number:(CGFloat)number unit:(NSString *)unit {
    
    NSString *text = [NSString stringWithFormat:@"%.1f   %@", number, unit];
    NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithString:text];
    NSRange range = [text rangeOfString:unit];
    [mString addAttribute:NSForegroundColorAttributeName
                    value:[UIColor colorWithHex:0x909090]
                    range:range];
    [mString addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:@"BEBAS" size:12.0f*kAppScale]
                    range:range];
    label.attributedText = [mString copy];
}

@end
