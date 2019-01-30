//
//  GBFourCornerViewController.m
//  GB_Team
//
//  Created by weilai on 16/9/13.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBFourCornerViewController.h"
#import "GBFourPreViewController.h"

#import <AMapLocationKit/AMapLocationManager.h>

#import "GBFourCorner.h"
#import "CourtRequest.h"
#import "RTLabel.h"
#import <pop/POP.h>

@interface GBFourCornerViewController ()<GBFourCornerDelegate,AMapLocationManagerDelegate>

@property (nonatomic, assign) CLLocationCoordinate2D oneLocation;
@property (nonatomic, assign) CLLocationCoordinate2D twoLocation;
@property (nonatomic, assign) CLLocationCoordinate2D threeLocation;
@property (nonatomic, assign) CLLocationCoordinate2D fourLocation;
@property (nonatomic, assign) CLLocationCoordinate2D lastLocation;
@property (nonatomic, assign) CLLocationCoordinate2D onceLocation;

@property (weak, nonatomic) IBOutlet GBFourCorner *cornerView;
@property (weak, nonatomic) IBOutlet UILabel *pointALongLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointALatLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointBLongLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointBLatLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointCLongLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointCLatLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointDLongLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointDLatLabel;
@property (weak, nonatomic) IBOutlet GBHightLightButton *locateButton;
@property (weak, nonatomic) IBOutlet GBHightLightButton *preViewButton;
@property (weak, nonatomic) IBOutlet UITextView *nameTextField;
@property (weak, nonatomic) IBOutlet UITextView *addressTextField;

// 提示框
@property (strong, nonatomic) IBOutlet UIView *maskBox;
@property (weak, nonatomic) IBOutlet UIView *tipBack;
@property (weak, nonatomic) IBOutlet UIView *boxView;
@property (weak, nonatomic) IBOutlet RTLabel *boxFirstHintStLbl;
@property (weak, nonatomic) IBOutlet RTLabel *boxSecondHintStLbl;
// 定位
@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) NSMutableArray *locationStateList;  //定位状态

@end

@implementation GBFourCornerViewController

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

// 注册通知
-(void)registNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeReset) name:Notification_ResetCourtSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeReStartLocate) name:Notification_RestartLocate object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
}

// 压入后台
- (void)applicationWillResignActive:(UIApplication *)application
{
    [self.locationManager stopUpdatingLocation];
}

// 返回到前台
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self.locationManager startUpdatingLocation];
}

#pragma mark - Notification

- (void)textFieldTextDidChange:(NSNotification *)notification {
    
    [self checkInputValid];
}

-(void)noticeReset
{
    [self resetCorner];
}

-(void)noticeReStartLocate
{
    [self.locationManager startUpdatingLocation];
}

#pragma mark - Delegate
- (void)GBFourCorner:(GBFourCorner*)cornerView didSelectAtIndex:(NSInteger)index
{
    self.selectIndex = index;
}
#pragma mark - Action

// 点击了定位按钮
- (IBAction)actionLocate:(id)sender {
    
    [self showLoadingToastWithText:LS(@"正在定位")];
    [self performBlock:^{
        [self dismissToast];
        [self updateSelectLocation:self.lastLocation];
    } delay:10.0f];
}
// 点击了保存按钮
- (IBAction)actionSave:(id)sender {
    
    CourtInfo *courtObj = [[CourtInfo alloc] init];
    courtObj.courtName = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    courtObj.courtAddress = [self.addressTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    courtObj.location = [[LocationCoordinateInfo alloc] initWithLon:self.oneLocation.longitude lat:self.oneLocation.latitude];
    courtObj.locA = [[LocationCoordinateInfo alloc] initWithLon:self.oneLocation.longitude lat:self.oneLocation.latitude];;
    courtObj.locB = [[LocationCoordinateInfo alloc] initWithLon:self.twoLocation.longitude lat:self.twoLocation.latitude];;
    courtObj.locC = [[LocationCoordinateInfo alloc] initWithLon:self.threeLocation.longitude lat:self.threeLocation.latitude];;
    courtObj.locD = [[LocationCoordinateInfo alloc] initWithLon:self.fourLocation.longitude lat:self.fourLocation.latitude];
    
    [self showLoadingToast];
    @weakify(self);
    [CourtRequest preViewCourt:courtObj handler:^(id result, NSError *error) {
        @strongify(self)
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            [self.locationManager stopUpdatingLocation];
            PreViewInfo *preInfo = (PreViewInfo *)result;
            GBFourPreViewController *preViewController = [[GBFourPreViewController alloc]init];
            preViewController.name = self.nameTextField.text;
            preViewController.address = self.addressTextField.text;
            preViewController.onceLocation = self.onceLocation.latitude == 0 ? self.lastLocation : self.onceLocation;
            preViewController.oneLocation = self.oneLocation;
            preViewController.twoLocation = self.twoLocation;
            preViewController.threeLocation = self.threeLocation;
            preViewController.fourLocation = self.fourLocation;
            preViewController.calOneLocation   = preInfo.locA.location;
            preViewController.calTwoLocation   = preInfo.locB.location;
            preViewController.calThreeLocation = preInfo.locC.location;
            preViewController.calFourLocation  = preInfo.locD.location;
            [self.navigationController pushViewController:preViewController animated:YES];
        }
    }];
}

- (IBAction)actionKnow:(id)sender {
    [self hidePopBox];
    
    [self requestLocation:YES isBtnLocation:NO];
}

- (IBAction)actionNotHit:(id)sender {
    [RawCacheManager sharedRawCacheManager].isNoLocationRemind = YES;
    [self hidePopBox];
    
    [self requestLocation:YES isBtnLocation:NO];
}

#pragma mark - Private

-(void)setupUI {
    
    self.title = LS(@"四角定位 - 添加球场");
    [self setupBackButtonWithBlock:nil];
    
    self.cornerView.delegate = self;
    self.locateButton.enabled = YES;
    
    self.locationStateList = [NSMutableArray arrayWithArray:@[@(NO), @(NO), @(NO), @(NO)]];
    [self registNotification];
    
    // Box提示框
    self.boxFirstHintStLbl.text = LS(@"<font color='#CCCCCC'>在四点定位</font><font color='#01FF00'>过程中</font><font color='#CCCCCC'>，请不要</font><font color='#01FF00'>切换APP</font><font color='#CCCCCC'>或</font><font color='#01FF00'>关闭APP</font>");
    self.boxSecondHintStLbl.text = LS(@"<font color='#CCCCCC'>如果切换APP将会</font><font color='#01FF00'>影响定位的准确性</font>");
    self.boxFirstHintStLbl.font = [UIFont systemFontOfSize:20.f];
    self.boxSecondHintStLbl.font = [UIFont systemFontOfSize:20.f];
    
    BOOL isNoTips = [RawCacheManager sharedRawCacheManager].isNoLocationRemind;
    if (!isNoTips) {
        self.maskBox.frame = [UIApplication sharedApplication].keyWindow.bounds;
        [[UIApplication sharedApplication].keyWindow addSubview:self.maskBox];
        self.tipBack.alpha = 0.f;
        [self performSelector:@selector(showPopBox) withObject:nil afterDelay:1.0f];
        
    } else {
        [self requestLocation:YES isBtnLocation:NO];
    }
}

-(void)showPopBox
{
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.toValue = @(1.0);
    anim.completionBlock = ^(POPAnimation * animation, BOOL finish){
        self.maskBox.hidden = NO;
        self.tipBack.alpha = 1.f;
        [self.tipBack pop_removeAnimationForKey:@"alpha"];
    };
    [self.tipBack pop_addAnimation:anim forKey:@"alpha"];
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.2, 0.2)];
    scaleAnimation.toValue   = [NSValue valueWithCGSize:CGSizeMake(1,1)];
    scaleAnimation.springBounciness = 15.f;
    scaleAnimation.completionBlock = ^(POPAnimation * animation, BOOL finish){
        [self.boxView.layer pop_removeAnimationForKey:@"scaleAnim"];
    };
    [self.boxView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
}

-(void)hidePopBox
{
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.toValue = @(0.0);    anim.completionBlock = ^(POPAnimation * animation, BOOL finish){
        self.maskBox.hidden = YES;
        self.tipBack.alpha = 0.f;
        [self.maskBox removeFromSuperview];
        [self.tipBack pop_removeAnimationForKey:@"alpha"];
    };
    [self.tipBack pop_addAnimation:anim forKey:@"alpha"];
}

// 重置初始化
-(void)resetCorner
{
    self.selectIndex = -1;
    self.locationStateList = [NSMutableArray arrayWithArray:@[@(NO), @(NO), @(NO), @(NO)]];
    _oneLocation.longitude = 0;
    _oneLocation.latitude  = 0;
    self.pointALongLabel.text = @"";
    self.pointALatLabel.text  = @"";
    _twoLocation.longitude = 0;
    _twoLocation.latitude  = 0;
    self.pointBLongLabel.text = @"";
    self.pointBLatLabel.text  = @"";
    _threeLocation.longitude = 0;
    _threeLocation.latitude  = 0;
    self.pointCLongLabel.text = @"";
    self.pointCLatLabel.text = @"";
    _fourLocation.longitude = 0;
    _fourLocation.latitude = 0;
    self.pointDLongLabel.text = @"";
    self.pointDLatLabel.text = @"";
    self.selectIndex = 0;
    self.preViewButton.enabled = NO;
    [self.locationManager startUpdatingLocation];
}

// 单点定位
- (void)requestLocation:(BOOL)withReGeocode isBtnLocation:(BOOL)isBtnLocation {
    
    [self showLoadingToastWithText:LS(@"正在定位")];
    @weakify(self)
    [self.locationManager requestLocationWithReGeocode:withReGeocode completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        @strongify(self)
        [self dismissToast];
        if (error) {
            [self showToastWithText:LS(@"定位失败")];
        }else {
            if (location.coordinate.latitude == 0 && location.coordinate.longitude == 0) {
                [self showToastWithText:LS(@"定位失败")];
                return;
            }
            if (withReGeocode) { //设置球场地址
                NSString *address = regeocode.formattedAddress;
                GBLog(@"球场地址:%@", address);
                self.addressTextField.text = address;
                self.onceLocation = location.coordinate;
                [self alwaysLocateConfig];
                [self.locationManager startUpdatingLocation];
            }
        }
        
    }];
}

- (void)updateSelectLocation:(CLLocationCoordinate2D)location {
    
    NSString *lonString = [NSString stringWithFormat:@"%06f", location.longitude];
    NSString *latString = [NSString stringWithFormat:@"%06f", location.latitude];
    if (self.selectIndex == 0) {
        _oneLocation.longitude = location.longitude;
        _oneLocation.latitude = location.latitude;
        self.pointALongLabel.text = lonString;
        self.pointALatLabel.text = latString;
        
    } else if (self.selectIndex == 1) {
        _twoLocation.longitude = location.longitude;
        _twoLocation.latitude = location.latitude;
        self.pointBLongLabel.text = lonString;
        self.pointBLatLabel.text = latString;
        
    } else if (self.selectIndex == 2) {
        _threeLocation.longitude = location.longitude;
        _threeLocation.latitude = location.latitude;
        self.pointCLongLabel.text = lonString;
        self.pointCLatLabel.text = latString;
        
    } else if (self.selectIndex == 3) {
        _fourLocation.longitude = location.longitude;
        _fourLocation.latitude = location.latitude;
        self.pointDLongLabel.text = lonString;
        self.pointDLatLabel.text = latString;
    }
    [self.locationStateList replaceObjectAtIndex:self.selectIndex withObject:[NSNumber numberWithBool:YES]];
    self.selectIndex = [self nextPosition];
    
    [self checkInputValid];
}

- (NSInteger)nextPosition {
    
    for (NSInteger index=0; index<self.locationStateList.count; index++) {
        if (![self.locationStateList[index] boolValue]) {
            return index;
        }
    }
    return -1; //已定位完成
}

#pragma mark - Getters & Setters

- (AMapLocationManager *)locationManager {
    
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        // 带逆地理信息的一次定位（返回坐标和地址信息）
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        // 定位超时时间，可修改，最小2s
        _locationManager.locationTimeout = 3;
        // 逆地理请求超时时间，可修改，最小2s
        _locationManager.reGeocodeTimeout = 3;
    }
    
    return _locationManager;
}

// 连续定位参数设置
-(void)alwaysLocateConfig
{
    // 连续定位参数设置
    self.locationManager.delegate = self;
    [self.locationManager setDistanceFilter:1];
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    
    if (_selectIndex == selectIndex) {//已选中再次点击取消
        _selectIndex = -1;
    }else {
        _selectIndex = selectIndex;
    }
    self.locateButton.enabled = !(self.selectIndex==-1);
    
    for (NSInteger index=0; index<self.locationStateList.count; index++) {
        if (index == 0) {
            self.cornerView.pointA = [self.locationStateList[index] boolValue]?STATE_RED:STATE_WHITE;
        } else if (index == 1) {
            self.cornerView.pointB = [self.locationStateList[index] boolValue]?STATE_RED:STATE_WHITE;
        } else if (index == 2) {
            self.cornerView.pointC = [self.locationStateList[index] boolValue]?STATE_RED:STATE_WHITE;
        } else if (index == 3) {
            self.cornerView.pointD = [self.locationStateList[index] boolValue]?STATE_RED:STATE_WHITE;
        }
    }
    
    if (self.selectIndex == 0) {
        self.cornerView.pointA = STATE_HEAD;
    } else if (self.selectIndex == 1) {
        self.cornerView.pointB = STATE_HEAD;
    } else if (self.selectIndex == 2) {
        self.cornerView.pointC = STATE_HEAD;
    } else if (self.selectIndex == 3) {
        self.cornerView.pointD = STATE_HEAD;
    }
}

- (void)checkInputValid {
    
    BOOL isCanSave = YES;
    for (NSInteger index=0; index<self.locationStateList.count; index++) {
        if (![self.locationStateList[index] boolValue]) {
            isCanSave = NO;
            break;
        }
    }
    BOOL isInputValid = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length>0 && [self.addressTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length>0;
    self.preViewButton.enabled = isCanSave && isInputValid;
}

#pragma mark - AMap Delegate

// 连续定位失败
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {
    // [self showToastWithText:LS(@"定位失败")];
}

// 连续定位保存至lastLocation
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
    if (location.coordinate.latitude != 0) {
        self.lastLocation = location.coordinate;
    }
}

@end
