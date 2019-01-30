//
//  GBAchievementViewController.m
//  GB_Football
//
//  Created by 王时温 on 2017/1/6.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBAchievementViewController.h"
#import "LanguageManager.h"
#import "GBSharePan.h"

@interface GBAchievementViewController ()<GBSharePanDelegate>

@property (weak, nonatomic) IBOutlet UIView *ch_View;
@property (weak, nonatomic) IBOutlet UIView *en_View;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *closeView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *shareView;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *myHighestSpeedLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *mySpeedLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *myHighestSpeedHistoryLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *rankLabel;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *percentLabel;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *thirdView_1;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *thirdView_2;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *thirdView_3;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *countryHighestSpeedLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *countrySpeedLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *frontHighestSpeedLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *frontHighestContentLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *frontSpeedLabel;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *unitLableList;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lastPassLabel;   //我前一位单位label

//分享页面
@property (strong, nonatomic)  GBSharePan *sharePan;
@property (strong, nonatomic)  UIImage      *shotImage;

@property (nonatomic, strong) MatchAchieveInfo *achieveInfo;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL isShowShare;

@end

@implementation GBAchievementViewController

- (instancetype)initWithAchieve:(MatchAchieveInfo *)achieveInfo isShowShare:(BOOL)isShowShare {
    
    self = [super init];
    if (self) {
        _achieveInfo = achieveInfo;
        _isShowShare = isShowShare;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)closeEvent:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)shareEvent:(id)sender {
    
    [self hideNavItems];
    self.shotImage = [UIImage imageWithCapeture];
    [self.sharePan showSharePanWithDelegate:self];
}

#pragma mark - Private

- (void)setupUI {
    
}

- (void)refreshUI {
    
    if (self.achieveInfo.display_type == 1) {
        
        [(UILabel *)self.myHighestSpeedLabel[self.index] setText:LS(@"achieve.person.highest.speed")];
        [(UILabel *)self.mySpeedLabel[self.index] setText:[NSString stringWithFormat:@"%.2f", self.achieveInfo.last_max_speed]];
        [(UILabel *)self.myHighestSpeedHistoryLabel[self.index] setText:LS(@"achieve.person.highest.history.speed")];
        [(UILabel *)self.rankLabel[self.index] setText:[NSString stringWithFormat:@"%.2f", self.achieveInfo.history_max_speed]];
        
        [(UILabel *)self.percentLabel[self.index] setText:[NSString stringWithFormat:@"%td%%", self.achieveInfo.speed_pass_ratio]];
        
        if (self.achieveInfo.last_max_speed>self.achieveInfo.history_max_speed) {
            [(UIView *)self.thirdView_3[self.index] setAlpha:1];
            [(UIView *)self.thirdView_2[self.index] setAlpha:0];
            [(UIView *)self.thirdView_1[self.index] setAlpha:0];
        }else if (self.achieveInfo.last_max_speed<self.achieveInfo.history_max_speed) {
            [(UIView *)self.thirdView_3[self.index] setAlpha:0];
            [(UIView *)self.thirdView_2[self.index] setAlpha:0];
            [(UIView *)self.thirdView_1[self.index] setAlpha:1];
        }else {
            [(UIView *)self.thirdView_3[self.index] setAlpha:0];
            [(UIView *)self.thirdView_2[self.index] setAlpha:1];
            [(UIView *)self.thirdView_1[self.index] setAlpha:0];
        }
        
        [(UILabel *)self.countryHighestSpeedLabel[self.index] setText:LS(@"achieve.national.highest.speed")];
        [(UILabel *)self.countrySpeedLabel[self.index] setText:[NSString stringWithFormat:@"%.2f", self.achieveInfo.country_max_speed]];
        if (self.achieveInfo.country_speed_rank == 1) {
            [(UILabel *)self.frontHighestContentLabel[self.index] setText:LS(@"achieve.congratulation")];
            [(UILabel *)self.frontHighestSpeedLabel[self.index] setText:LS(@"achieve.best.record")];
            
            [(UILabel *)self.frontSpeedLabel[self.index] setAlpha:0];
            [(UILabel *)self.lastPassLabel[self.index] setAlpha:0];
        }else {
            [(UILabel *)self.frontHighestContentLabel[self.index] setText:LS(@"achieve.national.pass.position.speed")];
            [(UILabel *)self.frontHighestSpeedLabel[self.index] setText:LS(@"achieve.national.pass.speed")];
            [(UILabel *)self.frontSpeedLabel[self.index] setAlpha:1];
            [(UILabel *)self.lastPassLabel[self.index] setAlpha:1];
            [(UILabel *)self.frontSpeedLabel[self.index] setText:[NSString stringWithFormat:@"%.2f", self.achieveInfo.pass_my_max_speed]];
        }
        
        for (UILabel *unitLabel in self.unitLableList) {
            unitLabel.text = @"M/S";
        }
    }else if (self.achieveInfo.display_type == 2){
        [(UILabel *)self.myHighestSpeedLabel[self.index] setText:LS(@"achieve.person.highest.distance")];
        [(UILabel *)self.mySpeedLabel[self.index] setText:[NSString stringWithFormat:@"%.2f", self.achieveInfo.last_max_move_distance/1000]];
        [(UILabel *)self.myHighestSpeedHistoryLabel[self.index] setText:LS(@"achieve.person.highest.history.distance")];
        [(UILabel *)self.rankLabel[self.index] setText:[NSString stringWithFormat:@"%.2f", self.achieveInfo.history_max_distance/1000]];
        
        [(UILabel *)self.percentLabel[self.index] setText:[NSString stringWithFormat:@"%td%%", self.achieveInfo.distance_pass_ratio]];
        
        if (self.achieveInfo.last_max_move_distance>self.achieveInfo.history_max_distance) {
            [(UIView *)self.thirdView_3[self.index] setAlpha:1];
            [(UIView *)self.thirdView_2[self.index] setAlpha:0];
            [(UIView *)self.thirdView_1[self.index] setAlpha:0];
        }else if (self.achieveInfo.last_max_move_distance<self.achieveInfo.history_max_distance) {
            [(UIView *)self.thirdView_3[self.index] setAlpha:0];
            [(UIView *)self.thirdView_2[self.index] setAlpha:0];
            [(UIView *)self.thirdView_1[self.index] setAlpha:1];
        }else {
            [(UIView *)self.thirdView_3[self.index] setAlpha:0];
            [(UIView *)self.thirdView_2[self.index] setAlpha:1];
            [(UIView *)self.thirdView_1[self.index] setAlpha:0];
        }
        
        [(UILabel *)self.countryHighestSpeedLabel[self.index] setText:LS(@"achieve.national.highest.distance")];
        [(UILabel *)self.countrySpeedLabel[self.index] setText:[NSString stringWithFormat:@"%.2f", self.achieveInfo.country_max_distance/1000]];
        if (self.achieveInfo.country_move_distance_rank == 1) {
            [(UILabel *)self.frontHighestContentLabel[self.index] setText:LS(@"achieve.congratulation")];
            [(UILabel *)self.frontHighestSpeedLabel[self.index] setText:LS(@"achieve.best.record")];
            
            [(UILabel *)self.frontSpeedLabel[self.index] setAlpha:0];
            [(UILabel *)self.lastPassLabel[self.index] setAlpha:0];
        }else {
            [(UILabel *)self.frontHighestContentLabel[self.index] setText:LS(@"achieve.national.pass.position.distance")];
            [(UILabel *)self.frontHighestSpeedLabel[self.index] setText:LS(@"achieve.national.pass.distance")];
            [(UILabel *)self.frontSpeedLabel[self.index] setAlpha:1];
            [(UILabel *)self.lastPassLabel[self.index] setAlpha:1];
            [(UILabel *)self.frontSpeedLabel[self.index] setText:[NSString stringWithFormat:@"%.2f", self.achieveInfo.pass_my_max_distance-self.achieveInfo.last_max_move_distance]];
        }
        
        for (UILabel *unitLabel in self.unitLableList) {
            unitLabel.text = @"KM";
        }
        [(UILabel *)self.lastPassLabel[self.index] setText:@"M"];
    }
}

- (void)localizeUI {
    
    NSString *langPre = [[LanguageManager sharedLanguageManager]getCurrentAppLanguage].langPrefix;
    if ([langPre hasPrefix:@"zh"]) {
        self.ch_View.alpha = 1;
        self.en_View.alpha = 0;
        self.index = 0;
    } else {
        self.ch_View.alpha = 0;
        self.en_View.alpha = 1;
        self.index = 1;
    }
    
    if (self.isShowShare) {
        ((UIView *)self.shareView[self.index]).hidden = NO;
    } else {
        ((UIView *)self.shareView[self.index]).hidden = YES;
    }
    
    [self refreshUI];
}

#pragma mark - 分享功能

- (GBSharePan*)sharePan
{
    if (!_sharePan)
    {
        _sharePan = [[GBSharePan alloc] init];
        _sharePan.delegate = self;
    }
    return _sharePan;
}
// share delegate
- (void)GBSharePanAction:(GBSharePan*)pan tag:(SHARE_TYPE)tag
{
    @weakify(self)
    [[[UMShareManager alloc]init] screenShare:tag image:self.shotImage complete:^(NSInteger state)
     {
         @strongify(self)
         switch (state)
         {
             case 0:
             {
                 [self showToastWithText:LS(@"share.toast.success")];
                 [self showNavItems];
                 [pan hide:^(BOOL ok){}];
             }break;
             case 1:
             {
                 [self showToastWithText:LS(@"share.toast.fail")];
                 [self showNavItems];
                 [pan hide:^(BOOL ok){}];
             }break;
             default:
                 break;
         }
     }];
}

- (void)GBSharePanActionCancel:(GBSharePan *)pan
{
    [self showNavItems];
}

-(void)hideNavItems
{
    [(UIView *)self.closeView[self.index] setAlpha:0];
    [(UIView *)self.shareView[self.index] setAlpha:0];
}

-(void)showNavItems
{
    [(UIView *)self.closeView[self.index] setAlpha:1];
    [(UIView *)self.shareView[self.index] setAlpha:1];
}

@end
