//
//  GBFourPreViewViewController.m
//  GB_Football
//
//  Created by Pizza on 2016/11/3.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBFourPreViewViewController.h"
#import <GoogleMaps/GoogleMaps.h>

#import "GBHightLightButton.h"
#import "GBActionSheet.h"
#import "SPUserResizableView.h"
#import "SINavigationMenuView.h"

#import "CourtRequest.h"
#import "CourtLogic.h"

#define MAXW  ([UIScreen mainScreen].bounds.size.width)
#define MAXH  ([UIScreen mainScreen].bounds.size.height)

@interface GBFourPreViewViewController ()<
SINavigationMenuDelegate,
MAMapViewDelegate,
SPUserResizableViewDelegate,
UIGestureRecognizerDelegate>

@property (nonatomic,strong) SINavigationMenuView           *navBarMenu;

// 地图图层
@property (weak, nonatomic) IBOutlet UIView *mapContainView;
@property (strong, nonatomic) MAMapView *mapView;
@property (strong, nonatomic) GMSMapView *gmsMapView;
// SP视图
@property (strong, nonatomic) SPUserResizableView *spView;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, strong) MAPolygon *polygon;
// 重新定位按钮
@property (weak, nonatomic) IBOutlet GBHightLightButton *resetButton;
// 保存按钮
@property (weak, nonatomic) IBOutlet GBHightLightButton *saveButton;

// 不可编辑的编辑框
@property (weak, nonatomic) IBOutlet UITextField *courtNameText;
@property (weak, nonatomic) IBOutlet UITextField *courtAddrText;
// 静态翻译
@property (weak, nonatomic) IBOutlet UILabel *nameStLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationStLabel;

// 框选的地址
@property (nonatomic, assign) CGPoint pA;
@property (nonatomic, assign) CGPoint pB;
@property (nonatomic, assign) CGPoint pC;
@property (nonatomic, assign) CGPoint pD;

@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, assign) MapType mapType;

@end

@implementation GBFourPreViewViewController
#pragma mark -
#pragma mark Memory

- (void)dealloc{
    
}

- (void)localizeUI {
    
    [self.saveButton setTitle:LS(@"corner.btn.save") forState:UIControlStateNormal];
    [self.resetButton setTitle:LS(@"court_four_adjust") forState:UIControlStateNormal];
    self.courtNameText.placeholder = LS(@"corner.hint.name");
    self.courtAddrText.placeholder = LS(@"corner.hint.loc");
    self.nameStLabel.text = LS(@"create.label.name");
    self.locationStLabel.text = LS(@"create.label.loc");
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    _mapView.frame = self.mapContainView.bounds;
    _gmsMapView.frame = self.mapContainView.bounds;
}

#pragma mark - Action

- (IBAction)actionEdit {
    
    self.isEdit = !self.isEdit;
    if (self.isEdit) {
        [self.resetButton setTitle:LS(@"common.btn.cancel") forState:UIControlStateNormal];
    }else {
        [self.resetButton setTitle:LS(@"court_four_adjust") forState:UIControlStateNormal];
    }
    [self resetMap];
}

// 保存
- (IBAction)actionPressSave:(id)sender {
    
    CourtInfo *courtObj = [[CourtInfo alloc] init];
    courtObj.courtName    = [self.courtNameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    courtObj.courtAddress = [self.courtAddrText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    courtObj.cityName = self.cityName;
    if (self.isEdit) {
        //坐标转换
        [self squreToMap:self.spView];
        courtObj.locA = [[LocationCoordinateInfo alloc] initWithLocation:[self transMapLocation:self.pA]];
        courtObj.locB = [[LocationCoordinateInfo alloc] initWithLocation:[self transMapLocation:self.pB]];
        courtObj.locC = [[LocationCoordinateInfo alloc] initWithLocation:[self transMapLocation:self.pC]];
        courtObj.locD = [[LocationCoordinateInfo alloc] initWithLocation:[self transMapLocation:self.pD]];
    }else {
        courtObj.locA = [[LocationCoordinateInfo alloc] initWithLocation:[self.fourPoints[0] MACoordinateValue]];
        courtObj.locB = [[LocationCoordinateInfo alloc] initWithLocation:[self.fourPoints[1] MACoordinateValue]];
        courtObj.locC = [[LocationCoordinateInfo alloc] initWithLocation:[self.fourPoints[2] MACoordinateValue]];
        courtObj.locD = [[LocationCoordinateInfo alloc] initWithLocation:[self.fourPoints[3] MACoordinateValue]];
    }
    courtObj.location = courtObj.locA;
    
    [self showLoadingToastWithText:LS(@"create.tip.waiting")];
    @weakify(self);
    [CourtRequest addCourt:courtObj handler:^(id result, NSError *error) {
        @strongify(self)
        [self dismissToast];
        if (error)
        {
            [self showToastWithText:error.domain];
        }else
        {
            CourtInfo *info = result;
            NSDictionary *dic = @{@"court_id":@(info.courtId),
                                  @"court_name":info.courtName?info.courtName:@""};
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_CreateCourtSuccess object:nil userInfo:dic];
        }
    }];
}

- (IBAction)actionLocateMyLocation:(id)sender {
    
    [self.mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
}

- (void)rightBarAction {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ResetCourtSuccess object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Delegate

#pragma mark SINavigationMenuDelegate

- (void)didSelectItemAtIndex:(NSUInteger)index {
    
    if (index==0) {
        if (self.mapType != MapType_Gaode) {
            self.mapType = MapType_Gaode;
            [RawCacheManager sharedRawCacheManager].mapType = MapType_Gaode;
            [self resetMap];
        }
    }else {
        if (self.mapType != MapType_Google) {
            self.mapType = MapType_Google;
            [RawCacheManager sharedRawCacheManager].mapType = MapType_Google;
            [self resetMap];
        }
    }
}

#pragma mark MAMapDelegate

// 角旗绘制
- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"hongdian"];
        if ([annotation.subtitle isEqualToString:@"1"]) {
            annotationView.image = [UIImage imageNamed:@"lvdian"];
        }
        return annotationView;
    }
    return nil;
}

// 球场绘制
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay {
    
    if ([overlay isKindOfClass:[MAPolygon class]])
    {
        MAPolygonRenderer *polygonRenderer = [[MAPolygonRenderer alloc] initWithPolygon:overlay];
        polygonRenderer.lineWidth   = 2.f;
        polygonRenderer.strokeColor = [UIColor colorWithHex:0x58e357 andAlpha:0.6];
        polygonRenderer.fillColor   = [UIColor colorWithHex:0x58e357 andAlpha:0.6];
        return polygonRenderer;
    }
    return nil;
}


#pragma mark SPUserResizableViewDelegate

// 手势，与地图冲突部分特殊处理
- (void)userResizableViewDidBeginEditing:(SPUserResizableView *)userResizableView {
    
    [self.spView hideEditingHandles];
    [self.mapView setScrollEnabled:NO];
    [self.mapView setZoomEnabled:NO];
}

// 手势，与地图冲突部分特殊处理
- (void)userResizableViewDidEndEditing:(SPUserResizableView *)userResizableView {
    
    [self.mapView setScrollEnabled:YES];
    [self.mapView setZoomEnabled:YES];
}

- (void)hideEditingHandles {
    
    [self.spView hideEditingHandles];
}

#pragma mark - Private

- (void)loadData {
    
    self.mapType = [RawCacheManager sharedRawCacheManager].mapType;
}

- (void)setupUI {
    
    self.title=LS(@"preview.nav.title");
    [self setupBackButtonWithBlock:nil];
    [self setupNavTitleView];
    [self setupNavigationBarRight];
    self.courtAddrText.text = self.address;
    self.courtNameText.text = self.name;
    self.resetButton.enabled = YES;
    self.saveButton.enabled = YES;
    
    [self resetMap];
}

- (void)setupNavigationBarRight {
    
    NSString *title = LS(@"preview.btn.reset");
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

- (void)setupNavTitleView {
    
    if ([RawCacheManager sharedRawCacheManager].isMacao || [RawCacheManager sharedRawCacheManager].isHongKong) {
        if (self.navigationItem)
        {
            CGRect frame = CGRectMake(0.0, 0.0, 200.0, self.navigationController.navigationBar.bounds.size.height);
            self.navBarMenu = [[SINavigationMenuView alloc] initWithFrame:frame title:(self.mapType == MapType_Google)?LS(@"court_four_google_preview"):LS(@"court_four_gaode_preview")];
            self.navBarMenu.items = @[LS(@"court_four_gaode_preview"),
                                      LS(@"court_four_google_preview")];
            self.navBarMenu.delegate = self;
            self.navigationItem.titleView = self.navBarMenu;
            [self.navBarMenu displayMenuInView:self.navigationController.view];
        }
    }else {
        
    }
}

- (void)resetMap {
    
    if (self.mapType == MapType_Google && ([RawCacheManager sharedRawCacheManager].isMacao || [RawCacheManager sharedRawCacheManager].isHongKong)) {
        _mapView.hidden = YES;
        self.gmsMapView.hidden = NO;
        if (!self.gmsMapView.superview) {
            [self.mapContainView addSubview:self.gmsMapView];
        }
        [self drawGMSCornerFlag];
        if (self.isEdit) {
            [_spView removeFromSuperview];
            _spView = nil;
            [self.gmsMapView addSubview:self.spView];

        }else {
            [_spView removeFromSuperview];
        }
    }else {
        _gmsMapView.hidden = YES;
        self.mapView.hidden = NO;
        if (!self.mapView.superview) {
            [self.mapContainView insertSubview:self.mapView atIndex:0];
        }
        [self drawMACornerFlag];
        if (self.isEdit) {
            [_spView removeFromSuperview];
            _spView = nil;
            [self.mapView addSubview:self.spView];
            
        }else {
            [_spView removeFromSuperview];
        }
    }
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

- (CLLocationCoordinate2D)transMapLocation:(CGPoint)point {
    
    if (self.mapType == 0) {
        return [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    }else {
        //需要转化为高德的坐标系
        return AMapLocationCoordinateConvert([self.gmsMapView.projection coordinateForPoint:point], AMapLocationCoordinateTypeGPS);
    }
}

#pragma mark 高德图球场位置

//画高德角旗图
- (void)drawMACornerFlag {
    
    //先清空数据
    [self.mapView removeAnnotations:[self.annotations copy]];
    [self.mapView removeOverlay:self.polygon];
    
    [self buildPolygon];
    // 大头针标记球场四角
    [self performBlock:^{[self drawMAPin];} delay:0];
}

// 根据四点生成图层
-(void)buildPolygon
{
    if (self.isEdit) {
        return;
    }
    NSArray *points = self.closePoints;
    CLLocationCoordinate2D rectPoints[4];
    rectPoints[0] = [points[0] MACoordinateValue];
    rectPoints[1] = [points[1] MACoordinateValue];
    rectPoints[2] = [points[2] MACoordinateValue];
    rectPoints[3] = [points[3] MACoordinateValue];
    MAPolygon *polygon = [MAPolygon polygonWithCoordinates:rectPoints count:4];
    self.polygon = polygon;
    [self.mapView addOverlay:polygon];
}

- (void)drawMAPin {
    
    // 初始化
    self.annotations = [[NSMutableArray alloc]init];
    //画球场边沿
    for (int i = 0 ; i < [self.orignalPoints count]; i++)
    {
        MAPointAnnotation *pin = [[MAPointAnnotation alloc] init];
        pin.coordinate = [self.orignalPoints[i] MACoordinateValue];
        [self.annotations addObject:pin];
    }
    //画四个角
    NSArray *fourPoints = self.isEdit?self.fourPoints:self.closePoints;
    for (int i = 0 ; i < [fourPoints count]; i++)
    {
        MAPointAnnotation *pin = [[MAPointAnnotation alloc] init];
        pin.subtitle = @"1";
        pin.coordinate = [fourPoints[i] MACoordinateValue];
        [self.annotations addObject:pin];
    }
    // 绘制到地图
    [self.mapView addAnnotations:self.annotations];
    [self.mapView showAnnotations:self.annotations edgePadding:UIEdgeInsetsMake(20, 20, 20, 80) animated:NO];
}

#pragma mark 谷歌球场位置

- (void)drawGMSCornerFlag {
    
    //清除
    [self.gmsMapView clear];
    
    [self setupGMSPolygons];
    // 大头针标记球场四角
    [self drawGMSPin];
}

- (void)setupGMSPolygons {
    
    if (self.isEdit) {
        return;
    }
    //路径
    GMSMutablePath *path = [GMSMutablePath path];
    [path addCoordinate:[CourtLogic transformFromGCJToWGS:[self.closePoints[0] MACoordinateValue]]];
    [path addCoordinate:[CourtLogic transformFromGCJToWGS:[self.closePoints[1] MACoordinateValue]]];
    [path addCoordinate:[CourtLogic transformFromGCJToWGS:[self.closePoints[2] MACoordinateValue]]];
    [path addCoordinate:[CourtLogic transformFromGCJToWGS:[self.closePoints[3] MACoordinateValue]]];
    
    // Create the first polygon.
    GMSPolygon *polygon = [[GMSPolygon alloc] init];
    polygon.path = path;
    polygon.fillColor =  [UIColor colorWithHex:0x58e357 andAlpha:0.6];
    polygon.strokeColor = [UIColor colorWithHex:0x58e357 andAlpha:0.6];
    polygon.strokeWidth = 2;
    polygon.tappable = NO;
    polygon.map = self.gmsMapView;
}

- (void)drawGMSPin {
    
    UIImage *pointImage = [UIImage imageNamed:@"hongdian"];
    UIImage *cornerImage = [UIImage imageNamed:@"lvdian"];
    //画球场边沿
    for (int i = 0 ; i < [self.orignalPoints count]; i++)
    {
        GMSMarker *melbourneMarker = [[GMSMarker alloc] init];
        melbourneMarker.icon = pointImage;
        melbourneMarker.position = [CourtLogic transformFromGCJToWGS:[self.orignalPoints[i] MACoordinateValue]];
        melbourneMarker.map = self.gmsMapView;
    }
    //画四个角
    NSArray *fourPoints = self.isEdit?self.fourPoints:self.closePoints;
    for (int i = 0 ; i < [fourPoints count]; i++)
    {
        GMSMarker *melbourneMarker = [[GMSMarker alloc] init];
        melbourneMarker.icon = cornerImage;
        melbourneMarker.position = [CourtLogic transformFromGCJToWGS:[fourPoints[i] MACoordinateValue]];
        melbourneMarker.map = self.gmsMapView;
    }
}

#pragma mark - Getters & Setters

// 地图初始化
- (MAMapView*)mapView {
    
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
        _mapView.delegate = self;
        [self.mapView setCenterCoordinate:[self.orignalPoints.firstObject MACoordinateValue] animated:YES];
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
        gmsMapView.camera = [GMSCameraPosition cameraWithTarget:[CourtLogic transformFromGCJToWGS:[self.orignalPoints[0] MACoordinateValue]]
                                                           zoom:18.1];
        _gmsMapView = gmsMapView;
        
        // Ask for My Location data after the map has already been added to the UI.
        dispatch_async(dispatch_get_main_queue(), ^{
            _gmsMapView.myLocationEnabled = YES;
        });
    }
    return _gmsMapView;
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
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideEditingHandles)];
        [gestureRecognizer setDelegate:self];
        [self.mapView addGestureRecognizer:gestureRecognizer];
        [self.mapView addSubview:_spView];
    }
    return _spView;
}

@end
