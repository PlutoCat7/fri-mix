//
//  GBSatelliteViewController.m
//  GB_Football
//
//  Created by Pizza on 16/8/18.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBSatelliteViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationManager.h>
#import <GoogleMaps/GoogleMaps.h>

#import "GBActionSheet.h"
#import "SPUserResizableView.h"
#import "GBHightLightButton.h"

#import "CourtRequest.h"

#define MAXW  ([UIScreen mainScreen].bounds.size.width)
#define MAXH  ([UIScreen mainScreen].bounds.size.height)
#define LTime 5  //定位超时
#define RTime 3  //地理解析超时

@interface GBSatelliteViewController ()<SPUserResizableViewDelegate,UIGestureRecognizerDelegate>
{
    // sp视图的控制中间变量
    SPUserResizableView *currentlyEditingView;
    SPUserResizableView *lastEditedView;
}
// 地图图层
@property (weak, nonatomic) IBOutlet UIView *mapContainView;
@property (strong, nonatomic) MAMapView *mapView;
@property (strong, nonatomic) GMSMapView *gmsMapView;
// 定位管理器
@property (strong, nonatomic) AMapLocationManager *locationManager;
@property (nonatomic, copy) NSString *cityName;
// SP视图
@property (strong, nonatomic) SPUserResizableView *spView;

// 定位地址
@property (nonatomic, assign) CGPoint pA;
@property (nonatomic, assign) CGPoint pB;
@property (nonatomic, assign) CGPoint pC;
@property (nonatomic, assign) CGPoint pD;

// 编辑框
@property (weak, nonatomic) IBOutlet UITextField *courtNameText;
@property (weak, nonatomic) IBOutlet UITextField *courtAddrText;
@property (weak, nonatomic) IBOutlet GBHightLightButton *saveButton;

// 静态翻译
@property (weak, nonatomic) IBOutlet UILabel *nameStLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationStLabel;

@property (nonatomic, assign) MapType mapType;
@property (nonatomic, assign) BOOL firstLocationUpdate;

@end

@implementation GBSatelliteViewController

#pragma mark -
#pragma mark Memory

- (void)dealloc{
    
    [_locationManager stopUpdatingLocation];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)localizeUI {
    
    [self.saveButton setTitle:LS(@"corner.btn.save") forState:UIControlStateNormal];
    self.courtNameText.placeholder = LS(@"corner.hint.name");
    self.courtAddrText.placeholder = LS(@"corner.hint.loc");
    self.nameStLabel.text = LS(@"create.label.name");
    self.locationStLabel.text = LS(@"create.label.loc");
}
#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    _gmsMapView.frame = self.mapContainView.bounds;
    _mapView.frame = self.mapContainView.bounds;
}

#pragma mark - Analytics

- (NSString *)pageName {
    return Analy_Page_Court_Map;
}

#pragma mark - Notification

- (void)textFieldTextDidChange:(NSNotification *)notification {
    
    [self checkInputValid];
}

#pragma mark - Delegate

// 手势，与地图冲突部分特殊处理
- (void)userResizableViewDidBeginEditing:(SPUserResizableView *)userResizableView {
    
    [currentlyEditingView hideEditingHandles];
    currentlyEditingView = userResizableView;
    [_mapView setScrollEnabled:NO];
    [_mapView setZoomEnabled:NO];
}

// 手势，与地图冲突部分特殊处理
- (void)userResizableViewDidEndEditing:(SPUserResizableView *)userResizableView {
    
    lastEditedView = userResizableView;
    [self squreToMap:userResizableView];
    [_mapView setScrollEnabled:YES];
    [_mapView setZoomEnabled:YES];
}

- (void)hideEditingHandles {
    
    [lastEditedView hideEditingHandles];
}

// 框选坐标转成地图坐标
- (void)squreToMap:(SPUserResizableView *)resizableView {
    
    CGRect r = CGRectInset(resizableView.frame, kSPUserResizableViewInteractiveBorderSize-5, kSPUserResizableViewInteractiveBorderSize-5);
    self.pA  = CGPointMake(r.origin.x+0,
                           r.origin.y+0);
    self.pB  = CGPointMake(r.origin.x+r.size.width,
                           r.origin.y+0);
    self.pC  = CGPointMake(r.origin.x+0,
                           r.origin.y+r.size.height);
    self.pD  = CGPointMake(r.origin.x+r.size.width,
                           r.origin.y+r.size.height);
}

#pragma mark - Action

- (IBAction)actionSave:(id)sender {
    
    CourtInfo *courtObj = [[CourtInfo alloc] init];
    courtObj.courtName = [self.courtNameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    courtObj.courtAddress = [self.courtAddrText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //坐标转换
    [self squreToMap:lastEditedView];
    courtObj.locA = [[LocationCoordinateInfo alloc] initWithLocation:[self transMapLocation:self.pA]];
    courtObj.locB = [[LocationCoordinateInfo alloc] initWithLocation:[self transMapLocation:self.pB]];
    courtObj.locC = [[LocationCoordinateInfo alloc] initWithLocation:[self transMapLocation:self.pC]];
    courtObj.locD = [[LocationCoordinateInfo alloc] initWithLocation:[self transMapLocation:self.pD]];
    courtObj.location = courtObj.locA;
    courtObj.cityName = self.cityName;
    
    [self showLoadingToast];
    @weakify(self);
    [CourtRequest addCourt:courtObj handler:^(id result, NSError *error) {
        @strongify(self)
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            CourtInfo *info = result;
            NSDictionary *dic = @{@"court_id":@(info.courtId),
                                  @"court_name":info.courtName?info.courtName:@""};
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_CreateCourtSuccess object:nil userInfo:dic];
        }
    }];
}

- (IBAction)actionLocateMyLocation:(id)sender {
    
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
}

- (void)rightBarAction {
    
    [GBActionSheet showWithTitle:LS(@"map-select-a-map-title")
                         button1:LS(@"map-gaode-title")
                         button2:LS(@"map-google-title")
                          cancel:LS(@"common.btn.cancel")
     handle:^(NSInteger index) {
         if (index == 0 && self.mapType == MapType_Google) {
             self.mapType = MapType_Gaode;
             [RawCacheManager sharedRawCacheManager].mapType = MapType_Gaode;
             [self resetMap];
         }else if (index == 1 && self.mapType == MapType_Gaode) {
             self.mapType = MapType_Google;
             [RawCacheManager sharedRawCacheManager].mapType = MapType_Google;
             [self resetMap];
         }
     }];
}

#pragma mark - Private

- (void)loadData {
    
    self.mapType = [RawCacheManager sharedRawCacheManager].mapType;
}

- (void)setupUI {
    
    self.title=LS(@"map.nav.title");
    [self setupBackButtonWithBlock:nil];
    [self showSitchMapButton];
    
    [self requestLocationWithReGeocode];
    
    [self resetMap];
}

- (void)setupNavigationBarRight {
    
    NSString *title = LS(@"map-switch-title");
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToHeight:24];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setSize:size];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[ColorManager styleColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(rightBarAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:rightButton];
}

- (void)checkInputValid {
    
    BOOL isInputValid = [self.courtNameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length>0 && [self.courtAddrText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length>0;
    self.saveButton.enabled = isInputValid;
}

- (void)showSitchMapButton {
    
    if ([RawCacheManager sharedRawCacheManager].isMacao || [RawCacheManager sharedRawCacheManager].isHongKong) {
        [self setupNavigationBarRight];
    }else {
        [self.navigationItem setRightBarButtonItem:nil];
    }
}

- (CLLocationCoordinate2D)transMapLocation:(CGPoint)point {
    
    if (self.mapType == 0) {
        return [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    }else {
        //需要转化为高德的坐标系
        return AMapLocationCoordinateConvert([self.gmsMapView.projection coordinateForPoint:point], AMapLocationCoordinateTypeGPS);
    }
}

- (void)resetMap {
    
    if (self.mapType == MapType_Google && ([RawCacheManager sharedRawCacheManager].isMacao || [RawCacheManager sharedRawCacheManager].isHongKong)) {
        _mapView.hidden = YES;
        [_spView removeFromSuperview];
        _spView = nil;
        self.gmsMapView.hidden = NO;
        [self.gmsMapView addSubview:self.spView];
    }else {
        _gmsMapView.hidden = YES;
        [_spView removeFromSuperview];
        _spView = nil;
        self.mapView.hidden = NO;
        [self.mapView addSubview:self.spView];
    }
}

#pragma mark - Getters & Setters

//高德地图初始化
- (MAMapView *)mapView {
    
    if (!_mapView) {
        _mapView = [[MAMapView alloc]initWithFrame:self.mapContainView.bounds];
        [_mapView setRotateEnabled:YES];
        [_mapView setSkyModelEnable:NO];
        [_mapView setRotateCameraEnabled:NO];
        [_mapView setShowsUserLocation:YES];
        [_mapView setScrollEnabled:YES];
        [_mapView setMapType:MAMapTypeSatellite];
        [_mapView setShowsScale:NO];
        [_mapView setShowsCompass:NO];
        [_mapView setZoomLevel:18.6 animated:YES];
        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
        [self.mapContainView insertSubview:_mapView atIndex:0];
        
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideEditingHandles)];
        [gestureRecognizer setDelegate:self];
        [_mapView addGestureRecognizer:gestureRecognizer];
    }
    return _mapView;
}

// 谷歌地图初始化
- (GMSMapView *)gmsMapView {
    
    if (!_gmsMapView) {
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.868
                                                                longitude:151.2086
                                                                     zoom:12];
        GMSMapView *gmsMapView = [GMSMapView mapWithFrame:self.mapContainView.bounds camera:camera];
        gmsMapView.settings.compassButton = YES;
        gmsMapView.settings.myLocationButton = YES;
        gmsMapView.mapType = kGMSTypeSatellite;
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideEditingHandles)];
        [gestureRecognizer setDelegate:self];
        [gmsMapView addGestureRecognizer:gestureRecognizer];
        _gmsMapView = gmsMapView;
        [self.mapContainView addSubview:gmsMapView];
        
        // Listen to the myLocation property of GMSMapView.
        @weakify(gmsMapView)
        @weakify(self)
        [self.yah_KVOController observe:gmsMapView keyPath:@"myLocation" block:^(id observer, id object, NSDictionary *change) {
            @strongify(gmsMapView)
            @strongify(self)
            if (!self.firstLocationUpdate) {
                // If the first location update has not yet been recieved, then jump to that
                // location.
                self.firstLocationUpdate = YES;
                CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
                gmsMapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                                        zoom:18.1];
            }
        }];
        
        // Ask for My Location data after the map has already been added to the UI.
        dispatch_async(dispatch_get_main_queue(), ^{
            _gmsMapView.myLocationEnabled = YES;
        });
    }
    return _gmsMapView;
}

// 定位管理器
- (AMapLocationManager*)locationManager
{
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc]init];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [_locationManager setPausesLocationUpdatesAutomatically:NO];
        [_locationManager setLocationTimeout:LTime];
        [_locationManager setReGeocodeTimeout:RTime];
    }
    return _locationManager;
}

// sp视图初始化
- (SPUserResizableView*)spView
{
    if (!_spView) {
        _spView = [[SPUserResizableView alloc]initWithFrame:CGRectMake(MAXW/4,60,MAXW/2,(MAXW/2)*1.544)];
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _spView.contentView = contentView;
        _spView.delegate = self;
        [_spView showEditingHandles];
        currentlyEditingView = _spView;
        lastEditedView = _spView;
    }
    return _spView;
}

// 单次初步定位
#pragma mark AMapLocationManager
- (void)requestLocationWithReGeocode {
    
    [self showLoadingToastWithText:LS(@"locate.tip.locating")];
    // 带逆地理（返回坐标和地址信息）
    @weakify(self)
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {

        @strongify(self)
        [self dismissToast];
        if (!error && regeocode) {
            self.cityName = regeocode.city;
            GBLog(@"reGeocode:%@", regeocode);
            [self updateCourseAddress:regeocode.formattedAddress];
            
            //
            [RawCacheManager sharedRawCacheManager].isHongKong = [regeocode.adcode hasPrefix:HongKongCityCode_Prefix];
            [RawCacheManager sharedRawCacheManager].isMacao = [regeocode.adcode hasPrefix:MacaoCityCode_Prefix];
            [self showSitchMapButton];
        }
    }];
}

- (void)updateCourseAddress:(NSString *)address {
    
    self.courtAddrText.text = address;
}

@end
