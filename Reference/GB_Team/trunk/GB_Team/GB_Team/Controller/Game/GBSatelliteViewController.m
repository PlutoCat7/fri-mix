//
//  GBSatelliteViewController.m
//  GB_Team
//
//  Created by weilai on 16/9/13.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBSatelliteViewController.h"

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationManager.h>

#import "SPUserResizableView.h"
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

@property (strong, nonatomic) IBOutlet MAMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextView *courtNameText;
@property (weak, nonatomic) IBOutlet UITextView *courtAddrText;
@property (weak, nonatomic) IBOutlet GBHightLightButton *saveButton;

// 定位管理器
@property (strong, nonatomic) AMapLocationManager *locationManager;
// SP视图
@property (strong, nonatomic) SPUserResizableView *spView;
// 自动刷新定时器
@property (nonatomic, strong) NSTimer *timer;
// 定位地址
@property (nonatomic, assign) CLLocationCoordinate2D pA;
@property (nonatomic, assign) CLLocationCoordinate2D pB;
@property (nonatomic, assign) CLLocationCoordinate2D pC;
@property (nonatomic, assign) CLLocationCoordinate2D pD;

@end

@implementation GBSatelliteViewController

#pragma mark -
#pragma mark Memory

- (void)dealloc{
    
    
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self setupTimer];
    self.spView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self stopTimer];
    self.spView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification

- (void)textViewTextDidChange:(NSNotification *)notification {
    
    [self checkInputValid];
}

#pragma mark - Action

- (IBAction)actionSave:(id)sender {
    
    CourtInfo *courtObj = [[CourtInfo alloc] init];
    courtObj.courtName = [self.courtNameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    courtObj.courtAddress = [self.courtAddrText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    courtObj.location = [[LocationCoordinateInfo alloc] initWithLon:self.pA.longitude lat:self.pA.latitude];
    courtObj.locA = [[LocationCoordinateInfo alloc] initWithLon:self.pA.longitude lat:self.pA.latitude];;
    courtObj.locB = [[LocationCoordinateInfo alloc] initWithLon:self.pB.longitude lat:self.pB.latitude];;
    courtObj.locC = [[LocationCoordinateInfo alloc] initWithLon:self.pC.longitude lat:self.pC.latitude];;
    courtObj.locD = [[LocationCoordinateInfo alloc] initWithLon:self.pD.longitude lat:self.pD.latitude];
    
    [self showLoadingToast];
    @weakify(self);
    [CourtRequest addCourt:courtObj handler:^(id result, NSError *error) {
        @strongify(self)
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_CreateCourtSuccess object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - Private

-(void)setupUI {
    self.title=LS(@"卫星图定位 - 添加球场");
    [self setupBackButtonWithBlock:nil];
    
    [self setupMapView];
    [self setupSpView];
    [self requestLocationWithReGeocode];
}

// 地图参数设置
-(void)setupMapView {
    [self.mapView setValue:@(YES) forKey:@"RotateEnabled"];
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setScrollEnabled:YES];
    [self.mapView setMapType:MAMapTypeSatellite];
    [self.mapView setShowsScale:NO];
    [self.mapView setShowsCompass:NO];
    [self.mapView setZoomLevel:18.6 animated:YES];
    [self.mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.mapView setUserTrackingMode:MAUserTrackingModeNone animated:YES];
    });
}

- (void)checkInputValid {
    
    BOOL isInputValid = [self.courtNameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length>0 && [self.courtAddrText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length>0;
    self.saveButton.enabled = isInputValid;
}

#pragma mark - Getters & Setters

// 定位管理器
-(AMapLocationManager*)locationManager {
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
-(SPUserResizableView*)spView {
    if (!_spView) {
        _spView = [[SPUserResizableView alloc]initWithFrame:CGRectMake(MAXW/8,(MAXH - (MAXW/4)*1.544)/2,MAXW/4,(MAXW/4)*1.544)];
    }
    return _spView;
}

// 配置sp视图
-(void)setupSpView {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(MAXW/8,(MAXH - (MAXW/4)*1.544)/2,MAXW/4,(MAXW/4)*1.544)];
    self.spView.contentView = contentView;
    self.spView.delegate = self;
    [self.spView showEditingHandles];
    currentlyEditingView = self.spView;
    lastEditedView = self.spView;
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideEditingHandles)];
    [gestureRecognizer setDelegate:self];
    [self.mapView addGestureRecognizer:gestureRecognizer];
    [self.mapView addSubview:self.spView];
}

- (void)hideEditingHandles {
    [lastEditedView hideEditingHandles];
}
// 手势，与地图冲突部分特殊处理
- (void)userResizableViewDidBeginEditing:(SPUserResizableView *)userResizableView {
    [currentlyEditingView hideEditingHandles];
    currentlyEditingView = userResizableView;
    [self.mapView setScrollEnabled:NO];
    [self.mapView setZoomEnabled:NO];
}

// 框选坐标转成地图坐标
- (void)squreToMap:(SPUserResizableView *)resizableView {
    CGRect r = CGRectInset(resizableView.frame, kSPUserResizableViewInteractiveBorderSize/2, kSPUserResizableViewInteractiveBorderSize/2);
    CGPoint pointA  = CGPointMake(r.origin.x+0,
                                  r.origin.y+0);
    
    CGPoint pointB  = CGPointMake(r.origin.x+r.size.width,
                                  r.origin.y+0);
    
    CGPoint pointC  = CGPointMake(r.origin.x+0,
                                  r.origin.y+r.size.height);
    
    CGPoint pointD  = CGPointMake(r.origin.x+r.size.width,
                                  r.origin.y+r.size.height);
    self.pA = [self.mapView convertPoint:pointA toCoordinateFromView:self.mapView];
    self.pB = [self.mapView convertPoint:pointB toCoordinateFromView:self.mapView];
    self.pC = [self.mapView convertPoint:pointC toCoordinateFromView:self.mapView];
    self.pD = [self.mapView convertPoint:pointD toCoordinateFromView:self.mapView];
}

// 手势，与地图冲突部分特殊处理
- (void)userResizableViewDidEndEditing:(SPUserResizableView *)userResizableView {
    lastEditedView = userResizableView;
    [self squreToMap:userResizableView];
    [self.mapView setScrollEnabled:YES];
    [self.mapView setZoomEnabled:YES];
}

-(void)timerAction
{
    [self squreToMap:lastEditedView];
}

// 单次初步定位
#pragma mark AMapLocationManager
- (void)requestLocationWithReGeocode {
    [self showLoadingToastWithText:LS(@"正在定位")];
    // 带逆地理（返回坐标和地址信息）
    @weakify(self)
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        @strongify(self)
        [self dismissToast];
        if (!error && regeocode) {
            GBLog(@"reGeocode:%@", regeocode);
            [self updateCourseAddress:regeocode.formattedAddress];
        }
    }];
}

- (void)updateCourseAddress:(NSString *)address {
    self.courtAddrText.text = address;
}

#pragma mark -
#pragma mark 定时器相关

-(void)setupTimer {
    self.timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)stopTimer {
    if (self.timer.isValid) {
        [self.timer invalidate];
    }
    self.timer=nil;
}

@end
