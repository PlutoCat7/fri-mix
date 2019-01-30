//
//  GBFourCornerViewController.m
//  GB_Football
//
//  Created by Pizza on 16/8/18.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBFourCornerViewController.h"
#import <AMapLocationKit/AMapLocationManager.h>
#import "GBFourCorner.h"
#import "GBHightLightButton.h"
#import "CourtRequest.h"
#import "GBFourPreViewViewController.h"
#import "CourtPreViewInfo.h"
#import "RTLabel.h"
#import "GBBoxButton.h"
#import <pop/POP.h>

@interface GBFourCornerViewController ()<GBFourCornerDelegate,AMapLocationManagerDelegate>

@property (nonatomic, assign) CLLocationCoordinate2D oneLocation;
@property (nonatomic, assign) CLLocationCoordinate2D twoLocation;
@property (nonatomic, assign) CLLocationCoordinate2D threeLocation;
@property (nonatomic, assign) CLLocationCoordinate2D fourLocation;
@property (nonatomic, assign) CLLocationCoordinate2D lastLocation;
@property (nonatomic, strong) NSMutableArray<NSValue *> *locationList;

@property (weak, nonatomic) IBOutlet GBFourCorner *cornerView;
// A点经度
@property (weak, nonatomic) IBOutlet UILabel *pointALongLabel;
// A点纬度
@property (weak, nonatomic) IBOutlet UILabel *pointALatLabel;
// B点经度
@property (weak, nonatomic) IBOutlet UILabel *pointBLongLabel;
// B点纬度
@property (weak, nonatomic) IBOutlet UILabel *pointBLatLabel;
// C点经度
@property (weak, nonatomic) IBOutlet UILabel *pointCLongLabel;
// C点纬度
@property (weak, nonatomic) IBOutlet UILabel *pointCLatLabel;
// D点经度
@property (weak, nonatomic) IBOutlet UILabel *pointDLongLabel;
// D点纬度
@property (weak, nonatomic) IBOutlet UILabel *pointDLatLabel;
// 定位按钮
@property (weak, nonatomic) IBOutlet GBHightLightButton *locateButton;
// 保存按钮
@property (weak, nonatomic) IBOutlet GBHightLightButton *preViewButton;
// 球场名称
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
// 球场地址
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
// 定位
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) NSMutableArray *locationStateList;  //定位状态
@property (nonatomic, assign) BOOL successOnceLocation;  //单点定位是否成功
@property (nonatomic, assign) BOOL startFourCornerLocate;  //是否开始四点定位
// 静态翻译
@property (weak, nonatomic) IBOutlet UILabel *tapTipStLabel;
@property (weak, nonatomic) IBOutlet UILabel *LngStLabel1;
@property (weak, nonatomic) IBOutlet UILabel *LngStLabel2;
@property (weak, nonatomic) IBOutlet UILabel *LngStLabel3;
@property (weak, nonatomic) IBOutlet UILabel *LngStLabel4;
@property (weak, nonatomic) IBOutlet UILabel *LatStLabel1;
@property (weak, nonatomic) IBOutlet UILabel *LatStLabel2;
@property (weak, nonatomic) IBOutlet UILabel *LatStLabel3;
@property (weak, nonatomic) IBOutlet UILabel *LatStLabel4;
@property (weak, nonatomic) IBOutlet UILabel *cornerStLabel1;
@property (weak, nonatomic) IBOutlet UILabel *cornerStLabel2;
@property (weak, nonatomic) IBOutlet UILabel *cornerStLabel3;
@property (weak, nonatomic) IBOutlet UILabel *cornerStLabel4;
@property (weak, nonatomic) IBOutlet UILabel *nameStLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationStLabel;

// 提示框
@property (strong, nonatomic) IBOutlet UIView *maskBox;
@property (weak, nonatomic) IBOutlet UIView *tipBack;
@property (weak, nonatomic) IBOutlet UILabel *boxTipStLbl;
@property (weak, nonatomic) IBOutlet UIView *boxView;
@property (weak, nonatomic) IBOutlet RTLabel *boxFirstHintStLbl;
@property (weak, nonatomic) IBOutlet RTLabel *boxSecondHintStLbl;
@property (weak, nonatomic) IBOutlet GBBoxButton *boxKownBtn;
@property (weak, nonatomic) IBOutlet GBBoxButton *boxNotHintBtn;

@end

@implementation GBFourCornerViewController

#pragma mark -
#pragma mark Memory

- (void)dealloc{
    [_locationManager stopUpdatingLocation];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)localizeUI{
    self.tapTipStLabel.text = LS(@"corner.label.tapflag");
    self.LngStLabel1.text = LS(@"corner.label.lng");
    self.LngStLabel2.text = LS(@"corner.label.lng");
    self.LngStLabel3.text = LS(@"corner.label.lng");
    self.LngStLabel4.text = LS(@"corner.label.lng");
    self.LatStLabel1.text = LS(@"corner.label.lat");
    self.LatStLabel2.text = LS(@"corner.label.lat");
    self.LatStLabel3.text = LS(@"corner.label.lat");
    self.LatStLabel4.text = LS(@"corner.label.lat");
    self.cornerStLabel1.text = LS(@"corner.label.corner.position1");
    self.cornerStLabel2.text = LS(@"corner.label.corner.position2");
    self.cornerStLabel3.text = LS(@"corner.label.corner.position3");
    self.cornerStLabel4.text = LS(@"corner.label.corner.position4");
    self.nameStLabel.text = LS(@"create.label.name");
    self.locationStLabel.text = LS(@"create.label.loc");
    [self.locateButton setTitle:LS(@"corner.btn.loacte") forState:UIControlStateNormal];
    [self.preViewButton setTitle:LS(@"preview.btn.preview") forState:UIControlStateNormal];
    self.nameTextField.placeholder = LS(@"corner.hint.name");
    self.addressTextField.placeholder = LS(@"corner.hint.loc");
    // Box提示框
    self.boxTipStLbl.text = LS(@"common.popbox.title.tip");
    [self.boxKownBtn setTitle:LS(@"sync.popbox.btn.got.it") forState:UIControlStateNormal];
    [self.boxNotHintBtn setTitle:LS(@"sync.popbox.btn.no.remind") forState:UIControlStateNormal];
    self.boxFirstHintStLbl.text = LS(@"create.popbox.four.close");
    self.boxSecondHintStLbl.text = LS(@"create.popbox.four.restart");
    self.boxFirstHintStLbl.font = FONT_ADAPT(13.f);
    self.boxSecondHintStLbl.font = FONT_ADAPT(13.f);
}

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

#pragma mark - Analytics

- (NSString *)pageName {
    return Analy_Page_Court_Gps;
}

#pragma mark - Notification

// 注册通知
-(void)registNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeReset) name:Notification_ResetCourtSuccess object:nil];
}

- (void)textFieldTextDidChange:(NSNotification *)notification {
    
    [self checkInputValid];
}

-(void)noticeReset
{
    [self resetCorner];
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
    
    [self.locationManager startUpdatingLocation];
    self.startFourCornerLocate = YES;
    
    if (self.successOnceLocation) {
        [self showLoadingToastWithText:LS(@"locate.tip.locating")];
        @weakify(self)
        [self performBlock:^{
            @strongify(self)
            [self dismissToast];
            [self updateSelectLocation:self.lastLocation];
        } delay:5.0f];
    }else {
        @weakify(self)
        [self requestReGeocodeLocation:^(NSError *error, CLLocation *location) {
            @strongify(self)
            if (!error) {
                self.lastLocation = location.coordinate;
                [self updateSelectLocation:self.lastLocation];
            }
        }];
    }
}

// 点击了预览按钮
- (IBAction)actionPreView:(id)sender {

    CourtInfo *courtObj = [[CourtInfo alloc] init];
    courtObj.locA = [[LocationCoordinateInfo alloc] initWithLon:self.oneLocation.longitude lat:self.oneLocation.latitude];;
    courtObj.locB = [[LocationCoordinateInfo alloc] initWithLon:self.twoLocation.longitude lat:self.twoLocation.latitude];;
    courtObj.locC = [[LocationCoordinateInfo alloc] initWithLon:self.threeLocation.longitude lat:self.threeLocation.latitude];;
    courtObj.locD = [[LocationCoordinateInfo alloc] initWithLon:self.fourLocation.longitude lat:self.fourLocation.latitude];
    
    [self showLoadingToastWithText:LS(@"create.tip.waiting")];
    @weakify(self);
    [CourtRequest preViewCourt:courtObj handler:^(id result, NSError *error) {
        @strongify(self)
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            
            [self.locationManager stopUpdatingLocation];
            GBFourPreViewViewController *preViewController = [[GBFourPreViewViewController alloc]init];
            preViewController.name = self.nameTextField.text;
            preViewController.address = self.addressTextField.text;
            preViewController.orignalPoints = [self.locationList copy];
            preViewController.fourPoints = @[[NSValue valueWithMACoordinate:self.oneLocation],
                                             [NSValue valueWithMACoordinate:self.twoLocation],
                                             [NSValue valueWithMACoordinate:self.threeLocation],
                                             [NSValue valueWithMACoordinate:self.fourLocation]];
            PreViewInfo *preInfo = (PreViewInfo *)result;
            preViewController.closePoints = @[[NSValue valueWithMACoordinate:CLLocationCoordinate2DMake(preInfo.locA.lat, preInfo.locA.lon)],
                                              [NSValue valueWithMACoordinate:CLLocationCoordinate2DMake(preInfo.locB.lat, preInfo.locB.lon)],
                                              [NSValue valueWithMACoordinate:CLLocationCoordinate2DMake(preInfo.locC.lat, preInfo.locC.lon)],
                                              [NSValue valueWithMACoordinate:CLLocationCoordinate2DMake(preInfo.locD.lat, preInfo.locD.lon)]];
            [self.navigationController pushViewController:preViewController animated:YES];
        }
    }];
    
}

- (IBAction)actionKownBtn:(id)sender {
    [self hidePopBox];
    
    [self requestReGeocodeLocation:nil];
}

- (IBAction)actionNotHintBtn:(id)sender {
    [RawCacheManager sharedRawCacheManager].isNoLocationRemind = YES;
    [self hidePopBox];
    
    [self requestReGeocodeLocation:nil];
}

#pragma mark - Private

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
    
    self.locationList = [NSMutableArray arrayWithCapacity:1];
}

-(void)setupUI
{
    self.title = LS(@"corner.nav.title");
    [self setupBackButtonWithBlock:nil];
    self.cornerView.delegate = self;
    self.locateButton.enabled = YES;
    
    self.locationList = [NSMutableArray arrayWithCapacity:1];
    
    BOOL isNoTips = [RawCacheManager sharedRawCacheManager].isNoLocationRemind;
    if (!isNoTips) {
        self.maskBox.frame = [UIApplication sharedApplication].keyWindow.bounds;
        [[UIApplication sharedApplication].keyWindow addSubview:self.maskBox];
        self.tipBack.alpha = 0.f;
        [self performSelector:@selector(showPopBox) withObject:nil afterDelay:1.0f];
        
    } else {
        [self requestReGeocodeLocation:nil];
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
    anim.toValue = @(0.0);
    anim.completionBlock = ^(POPAnimation * animation, BOOL finish){
        self.maskBox.hidden = YES;
        self.tipBack.alpha = 0.f;
        [self.maskBox removeFromSuperview];
        [self.tipBack pop_removeAnimationForKey:@"alpha"];
    };
    [self.tipBack pop_addAnimation:anim forKey:@"alpha"];
}

- (void)loadData {
    self.locationStateList = [NSMutableArray arrayWithArray:@[@(NO), @(NO), @(NO), @(NO)]];
    [self registNotification];
}

// 单点定位
- (void)requestReGeocodeLocation:(void(^)(NSError *error, CLLocation *location))complete {
    
    [self showLoadingToastWithText:LS(@"locate.tip.locating")];
    @weakify(self)
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        @strongify(self)
        [self dismissToast];
        if (error)
        {
            self.cityName = @"";
            [self showToastWithText:LS(@"locate.tip.failed")];
        }
        else
        {
            self.successOnceLocation = YES;
            
            NSString *address = regeocode.formattedAddress;
            self.addressTextField.text = address;
            self.cityName = regeocode.city;
            self.lastLocation = location.coordinate;
            
            //开始连续定位
            [self.locationManager startUpdatingLocation];
            
            //
            [RawCacheManager sharedRawCacheManager].isHongKong = [regeocode.adcode hasPrefix:HongKongCityCode_Prefix];
            [RawCacheManager sharedRawCacheManager].isMacao = [regeocode.adcode hasPrefix:MacaoCityCode_Prefix];
            
        }
        BLOCK_EXEC(complete, error, location);
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
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
        // 定位超时时间，可修改，最小2s
        _locationManager.locationTimeout = 3;
        // 逆地理请求超时时间，可修改，最小2s
        _locationManager.reGeocodeTimeout = 3;
        _locationManager.delegate = self;
        [_locationManager setDistanceFilter:1];
        _locationManager.allowsBackgroundLocationUpdates = YES;
    }
    return _locationManager;
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
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    
}

// 连续定位保存至lastLocation
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    if (location.coordinate.latitude != 0)
    {
        self.lastLocation = location.coordinate;
        
        if (self.startFourCornerLocate && [self nextPosition]!=-1) {  //开始四点定位 且还有点未定位
            [self.locationList addObject:[NSValue valueWithMACoordinate:location.coordinate]];
        }
    }
}

@end
